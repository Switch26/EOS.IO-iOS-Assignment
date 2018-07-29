//
//  EOSAPI.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/28/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import Foundation

enum APIError: Error {
    case networkError(String)
    case parsingJSONError
    case parsingStringError
    case invalidArgument
}


// Quick Model to parse JSON using JSONDecoder()
struct Transaction: Codable { let trx: Trx? }
struct Trx: Codable { let trx: TrxWithinTrx? }
struct TrxWithinTrx: Codable { let actions: [Action]? }
struct Action: Codable {
    let name: String?
    let account: String?
}

struct ActionContractResponse: Codable { let abi: Abi? }
struct Abi: Codable { let actions: [Contract]?}
struct Contract: Codable {
    var account: String?
    let name: String?
    let ricardianContract: String?
}


struct EOSAPI {

    static let current = EOSAPI() // singleton
    
    // URLs
    private static let basePath = "https://api.eosnewyork.io"
    private func getChainURL() -> URL {
        return URL(string: "\(EOSAPI.basePath)/v1/chain/get_info")!
    }
    private func getBlockURL() -> URL {
        return URL(string: "\(EOSAPI.basePath)/v1/chain/get_block")!
    }
    private func getTransactionHistoryURL() -> URL {
        return URL(string: "\(EOSAPI.basePath)/v1/history/get_transaction")!
    }
    private func getActionContractURL() -> URL {
        return URL(string: "\(EOSAPI.basePath)/v1/chain/get_abi")!
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(customDateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: Internal Utility methods
    internal func fetchDataFrom(url: URL, completion:@escaping (Data?, _ optionalError: APIError?) -> Void) {
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            completion(data, (error != nil) ? APIError.networkError(error!.localizedDescription) : nil)
        }
        task.resume()
    }
    
    internal func fetchData(fromURL url: URL, withParameters params: [String: String], completion:@escaping (Data?, _ optionalError: APIError?) -> Void) {
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let jsonData = try? JSONEncoder().encode(params) else { return completion(nil, APIError.parsingJSONError) }
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else { return completion(nil, APIError.networkError(error.debugDescription))}
            return completion(validData, nil)
        }
        task.resume()
    }

    // MARK: External methods
    func getChain(completion: @escaping (Chain?, _ error: APIError?) -> Void) {
        
        EOSAPI.current.fetchDataFrom(url: EOSAPI.current.getChainURL()) { optionalData, optionalError in
            guard let validData = optionalData, optionalError == nil else { return completion(nil, optionalError) }
            let chain = try? EOSAPI.current.decoder.decode(Chain.self, from: validData)
            let apiError = chain == nil ? APIError.parsingJSONError : nil
            return completion(chain, apiError)
        }
    }
    
    func getBlock(numberOrId: String, completion: @escaping (Block?, _ errror: APIError?) -> Void) {

        guard numberOrId.isEmpty == false else { return completion(nil, APIError.invalidArgument) }
        let params = ["block_num_or_id" : numberOrId]
        EOSAPI.current.fetchData(fromURL: EOSAPI.current.getBlockURL(), withParameters: params) { (data, error) in
            guard let validData = data, error == nil else { return completion(nil, error) }
            let block = try? EOSAPI.current.decoder.decode(Block.self, from: validData)
            let apiError = block == nil ? APIError.parsingJSONError : nil
            return completion(block, apiError)
        }
    }
    

    func getTransactionActions(byId id: String, completion: @escaping ([Action]?, _ errror: APIError?) -> Void) {

        guard id.isEmpty == false else { return completion(nil, APIError.invalidArgument) }
        let params = ["id" : id]
        EOSAPI.current.fetchData(fromURL: EOSAPI.current.getTransactionHistoryURL(), withParameters: params) { (data, error) in
            guard let validData = data, error == nil else { return completion(nil, error) }
            let transaction = try? EOSAPI.current.decoder.decode(Transaction.self, from: validData)
            let apiError = transaction?.trx?.trx?.actions == nil ? APIError.parsingJSONError : nil
            return completion(transaction?.trx?.trx?.actions, apiError)
        }
    }
    

    func getContract(forAction: Action, completion: @escaping (Contract?, _ errror: APIError?) -> Void) {
        
        guard let validName = forAction.account else { return completion(nil, APIError.invalidArgument) }
        let params = ["account_name" : validName]
        EOSAPI.current.fetchData(fromURL: EOSAPI.current.getActionContractURL(), withParameters: params) { (data, error) in
            guard let validData = data, error == nil else { return completion(nil, error) }
            let abi = try? EOSAPI.current.decoder.decode(ActionContractResponse.self, from: validData)
            var contract = abi?.abi?.actions?.filter({ $0.name == forAction.name }).first
            contract?.account = forAction.account
            let apiError = contract == nil ? APIError.parsingJSONError : nil
            return completion(contract, apiError)
        }
    }
    
    func renderContractsForActions(contracts: [Contract], actions: [Action]) throws -> [String]? {
        
        var arrayOfContracts: [String] = []
        do {
            try actions.forEach { action in
                let contract = contracts.filter({ $0.name == action.name && $0.account == action.account }).first?.ricardianContract
                let editOutPlaceholdersContract = contract?.replacingOccurrences(of: "{{", with: "").replacingOccurrences(of: "}}", with: "")
                guard let validContractText = editOutPlaceholdersContract else { throw APIError.parsingStringError }
                arrayOfContracts.append(validContractText)
            }
        } catch {
            throw APIError.parsingStringError
        }
        return arrayOfContracts
    }
    
    //let json = try? JSONSerialization.jsonObject(with: validData, options: .mutableContainers)
    //print("json : \(json)")
}
