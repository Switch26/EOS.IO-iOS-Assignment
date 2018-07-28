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

struct EOSAPI {

    static let current = EOSAPI() // singleton
    //var chain = Chain(headBlockNum: 0)
    
    // URLS
    private static let basePath = "https://api.eosnewyork.io"
    private func getChainInfo() -> URL {
        return URL(string: "\(EOSAPI.basePath)/v1/chain/get_info")!
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    
    func updateChain(completion: @escaping (Chain?, _ error: APIError?) -> Void) {
        
        EOSAPI.current.fetchDataFrom(url: EOSAPI.current.getChainInfo()) { optionalData, optionalError in
            guard let validData = optionalData, optionalError == nil else { return completion(nil, optionalError) }
            let chain = try? EOSAPI.current.decoder.decode(Chain.self, from: validData)
            let apiError = chain == nil ? APIError.parsingJSONError : nil
            //if chain != nil { self?.chain = chain! }
            return completion(chain, apiError)
        }
    }
    
    private func fetchDataFrom(url: URL, completion:@escaping (Data?, _ optionalError: APIError?) -> ()) {
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            completion(data, (error != nil) ? APIError.networkError(error!.localizedDescription) : nil)
        }
        task.resume()
    }
}
