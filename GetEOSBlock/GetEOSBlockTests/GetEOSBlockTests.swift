//
//  GetEOSBlockTests.swift
//  GetEOSBlockTests
//
//  Created by Serguei Vinnitskii on 7/28/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import XCTest
@testable import GetEOSBlock

class GetEOSBlockTests: XCTestCase {
    
    // URLs (because they are private in EOSAPI)
    let basePath = "https://api.eosnewyork.io"
    func getChainURL() -> URL {
        return URL(string: "\(self.basePath)/v1/chain/get_info")!
    }
    func getBlockURL() -> URL {
        return URL(string: "\(self.basePath)/v1/chain/get_block")!
    }
    func getTransactionHistoryURL() -> URL {
        return URL(string: "\(self.basePath)/v1/history/get_transaction")!
    }
    func getActionContractURL() -> URL {
        return URL(string: "\(self.basePath)/v1/chain/get_abi")!
    }
    
    let trxId = "4d0c96e4dbf6691df87c966cf46fd5f5faa4a29ae12693179317d1c54880a43c" // voter, 1 action
    let trxId2 = "4adb329489fdfdb43213a630e93dd13bf1f21b332efa67b9bd65bc0ca976c1cc" // ram, 3 actions
    let blockNum = "8157990"

    
    func testFetchDataFromURL() {

        let exp = expectation(description: "Successful download")
        EOSAPI.current.fetchDataFrom(url: self.getBlockURL()) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if error != nil {
                XCTFail("waitForExpectation timed out with error: \(error!)")
            }
        }
    }
    
    func testFetchDataFromURLWithParameters() {
        
        let exp = expectation(description: "Successful download")
        let params = ["block_num_or_id" : self.blockNum]

        EOSAPI.current.fetchData(fromURL: self.getBlockURL(), withParameters: params) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if error != nil {
                XCTFail("waitForExpectation timed out with error: \(error!)")
            }
        }
    }
    
    func testGetChain() {
        
        let exp = expectation(description: "Got chain")
        EOSAPI.current.getChain { chain, error in
            XCTAssertNotNil(chain)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if error != nil {
                XCTFail("waitForExpectation timed out with error: \(error!)")
            }
        }
    }
    
    func allMethods() {
        
//        EOSAPI.current.fetchDataFrom(url: <#T##URL#>, completion: <#T##(Data?, APIError?) -> Void#>)
//        EOSAPI.current.fetchData(fromURL: <#T##URL#>, withParameters: <#T##[String : String]#>, completion: <#T##(Data?, APIError?) -> Void#>)
//
//        EOSAPI.current.getChain(completion: <#T##(Chain?, APIError?) -> Void#>)
//        EOSAPI.current.getBlock(numberOrId: <#T##String#>, completion: <#T##(Block?, APIError?) -> Void#>)
//        EOSAPI.current.getTransactionActions(byId: <#T##String#>, completion: <#T##([Action]?, APIError?) -> Void#>)
//        EOSAPI.current.getContract(forAction: <#T##Action#>, completion: <#T##(Contract?, APIError?) -> Void#>)
//        EOSAPI.current.getContratsFor(actions: <#T##[Action]#>, completion: <#T##([Contract]?) -> Void#>)
//        EOSAPI.current.renderContractsForActions(contracts: <#T##[Contract]#>, actions: <#T##[Action]#>)
        
        
    }
    
}
