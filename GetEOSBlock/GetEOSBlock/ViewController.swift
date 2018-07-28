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
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
