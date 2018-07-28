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
        
        /*
        EOSAPI.current.getChain { (chain, error) in
//            print("error: \(error)")
//            print("chain: \(chain)")
            
            guard let latestBlockNumber = chain?.headBlockNum else { return }
            
            EOSAPI.current.getBlock(numberOrId: String(latestBlockNumber)) { (block, error) in
                print("error: \(error)")
                print("block: \(block)")
            }
        }*/
        
        let trxId = "4d0c96e4dbf6691df87c966cf46fd5f5faa4a29ae12693179317d1c54880a43c"
        EOSAPI.current.getTransactionActions(byId: trxId) { (actions, error) in
            let account = actions?.first?.account
            print("account: \(account)")
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
