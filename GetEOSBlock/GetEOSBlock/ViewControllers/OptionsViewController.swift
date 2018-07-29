//
//  OptionsViewController.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/29/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var ricardianContractButton: UIButton!
    @IBOutlet weak var latestBlockButton: UIButton!
    @IBOutlet weak var activityIndicator_latestBlock: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ricardianContractButton.layer.cornerRadius = 4
        self.latestBlockButton.layer.cornerRadius = 4

    }
    
    @IBAction func getLatestBlockPressed(_ sender: UIButton) {
        self.activityIndicator_latestBlock.startAnimating()
        
        // 1. Download chain info and look up latest block
        EOSAPI.current.getChain { (chain, error) in
            
            guard let latestBlockNumber = chain?.headBlockNum, error == nil else {
                DispatchQueue.main.async {
                    self.activityIndicator_latestBlock.stopAnimating()
                    self.handleNetworkManagerErrors(error: error!)
                }
                return
            }
            
            //2. Download latest block
            EOSAPI.current.getBlock(numberOrId: String(latestBlockNumber)) { (block, error) in
                
                guard let validBlock = block, error == nil else {
                    DispatchQueue.main.async {
                        self.activityIndicator_latestBlock.stopAnimating()
                        self.handleNetworkManagerErrors(error: error!)
                    }
                    return
                }
                
                // 3. We have valid block
                DispatchQueue.main.async {
                    self.activityIndicator_latestBlock.stopAnimating()
                    self.performSegue(withIdentifier: "showBlockInfo", sender: validBlock)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showBlockInfo":
            if let showBlockInfoVC = segue.destination as? ShowBlockInfoViewController, let validBlock = sender as? Block {
                showBlockInfoVC.block = validBlock
            }
        default:
            break
        }
    }

}
