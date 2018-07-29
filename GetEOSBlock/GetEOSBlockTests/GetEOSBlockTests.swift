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
    
    // URLs
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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
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
