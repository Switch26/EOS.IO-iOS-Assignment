//
//  ViewController.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/28/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        EOSAPI.current.getChain { (chain, error) in
//            print("error: \(error)")
//            print("chain: \(chain)")
            
            guard let latestBlockNumber = chain?.headBlockNum else { return }
            
            EOSAPI.current.getBlock(numberOrId: String(latestBlockNumber)) { (block, error) in
                print("error: \(error)")
                print("block: \(block)")
            }
        }
        
        let trxId = "4d0c96e4dbf6691df87c966cf46fd5f5faa4a29ae12693179317d1c54880a43c" // voter, 1 action
        let trxId2 = "4adb329489fdfdb43213a630e93dd13bf1f21b332efa67b9bd65bc0ca976c1cc" // ram, 3 actions
        EOSAPI.current.getTransactionActions(byId: trxId2) { (actions, error) in
            
            //print("actions: \(actions)")
            
            guard let validActions = actions else { return }
            EOSAPI.current.getContratsFor(actions: validActions, completion: { contracts in
                guard let validContracts = contracts else { return } // throw error
                
                let contracts = try? EOSAPI.current.renderContractsForActions(contracts: validContracts, actions: validActions)
                
//                do {
//                    let arrayOfContracs = try EOSAPI.current.renderContractsForActions(contracts: validContracts, actions: validActions)
//                } catch APIError.parsingStringError {
//                    //handle error
//                }
                
                print("contractText: \(contracts)")
            })
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
