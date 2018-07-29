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
    
    let trxId1 = "4d0c96e4dbf6691df87c966cf46fd5f5faa4a29ae12693179317d1c54880a43c" // voter, 1 action
    let trxId2 = "4adb329489fdfdb43213a630e93dd13bf1f21b332efa67b9bd65bc0ca976c1cc" // ram, 3 actions
    let blockNum = "8157990"
    let action1 = Action(name: "newaccount", account: "eosio")
    let action2 = Action(name: "buyrambytes", account: "eosio")
    let contract = Contract(account: "eosio", name: "newaccount", ricardianContract: "The newaccount action creates a new account")
    
    override func setUp() {
        super.setUp()
    }

    
    func testFetchDataFromURL() {

        let exp = expectation(description: "Successful download")
        EOSAPI.current.fetchDataFrom(url: self.getBlockURL()) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if error != nil { XCTFail("waitForExpectation timed out with error: \(error!)")}
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
            if error != nil { XCTFail("waitForExpectation timed out with error: \(error!)") }
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
            if error != nil { XCTFail("waitForExpectation timed out with error: \(error!)")}
        }
    }
    
    func testGetBlock() {
        
        let exp = expectation(description: "Got block")
        EOSAPI.current.getBlock(numberOrId: self.blockNum) { block, error in
            XCTAssertNotNil(block)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if error != nil { XCTFail("waitForExpectation timed out with error: \(error!)")}
        }
    }
    
    func testGetTransactionActions() {
        
        let exp = expectation(description: "Got action")
        EOSAPI.current.getTransactionActions(byId: self.trxId1) { actions, error in
            XCTAssertNotNil(actions)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if error != nil { XCTFail("waitForExpectation timed out with error: \(error!)") }
        }
    }
    
    func testGetContractForAction() {
        
        let exp = expectation(description: "Got contract")
        EOSAPI.current.getContract(forAction: self.action1) { contract, error in
            XCTAssertNotNil(contract)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if error != nil { XCTFail("waitForExpectation timed out with error: \(error!)") }
        }
    }
    
    func testGetContractsForActions() {
        
        let exp = expectation(description: "Got array of contracts")
        EOSAPI.current.getContratsFor(actions: [self.action1, self.action2]) { contracts, error in
            XCTAssertNotNil(contracts)
            XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if error != nil { XCTFail("waitForExpectation timed out with error: \(error!)") }
        }
    }
    
}
