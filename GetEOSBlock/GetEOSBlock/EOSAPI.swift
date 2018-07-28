//
//  EOSAPI.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/28/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import UIKit

enum APIError: Error {
    case networkError(String) // associated value enum
    case parsingJSONError
    case serverError(String)
}

struct Chain: Codable {
    
//    let serverVersion: String
//    let chainId: String
    let headBlockNum: Int // latest block
//    let lastIrreversibleBlockNum: Int
//    let lastIrreversibleBlockId: String
//    let headBlockId: String
//    let headBlockProducer: String
    
}

struct Block: Codable {
    
    var previous: String?
//    var timestamp: Date?
//    var transactionMerkleRoot: String?
//    var producer: String?
//    var producerChanges: [String]?
//    var producerSignature: String?
//    var cycles: [String]?
//    var id: String?
    var blockNum: Int
    var refBlockPrefix: Int
}

//https://api.eosnewyork.io/v1/chain/get_block --data '{"block_num_or_id" :8157990}'

struct EOSAPI {

    static let current = EOSAPI() // singleton
    //var chain = Chain(headBlockNum: 0)
    
    // URLS
    private static let basePath = "https://api.eosnewyork.io"
    private func getChainURL() -> URL {
        return URL(string: "\(EOSAPI.basePath)/v1/chain/get_info")!
    }
    private func getBlockURL() -> URL {
        return URL(string: "\(EOSAPI.basePath)/v1/chain/get_block")!
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    
    func getChain(completion: @escaping (Chain?, _ error: APIError?) -> Void) {
        
        EOSAPI.current.fetchDataFrom(url: EOSAPI.current.getChainURL()) { optionalData, optionalError in
            guard let validData = optionalData, optionalError == nil else { return completion(nil, optionalError) }
            let chain = try? EOSAPI.current.decoder.decode(Chain.self, from: validData)
            let apiError = chain == nil ? APIError.parsingJSONError : nil
            //if chain != nil { self?.chain = chain! }
            return completion(chain, apiError)
        }
    }
    
    func getBlock(numberOrId: String, completion: @escaping (Block?, _ errror: APIError?) -> Void) {

        let params = ["block_num_or_id" : numberOrId]
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: EOSAPI.current.getBlockURL())
        request.httpMethod = "POST"
        guard let jsonData = try? JSONEncoder().encode(params) else { return completion(nil, APIError.parsingJSONError) }
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let validData = data, error == nil else { return completion(nil, APIError.networkError(error.debugDescription))}
            let block = try? EOSAPI.current.decoder.decode(Block.self, from: validData)
            let apiError = block == nil ? APIError.parsingJSONError : nil
            return completion(block, apiError)
        }
        task.resume()
    }
    
    private func fetchDataFrom(url: URL, completion:@escaping (Data?, _ optionalError: APIError?) -> ()) {
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            completion(data, (error != nil) ? APIError.networkError(error!.localizedDescription) : nil)
        }
        task.resume()
    }
}
