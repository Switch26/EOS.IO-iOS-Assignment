//
//  ContractDetailsViewController.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/29/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import UIKit

class ContractDetailsViewController: UIViewController {
    
    @IBOutlet weak var transactionEntryField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contractTextView: UITextView!
    
    let trxId = "4d0c96e4dbf6691df87c966cf46fd5f5faa4a29ae12693179317d1c54880a43c" // voter, 1 action
    let trxId2 = "4adb329489fdfdb43213a630e93dd13bf1f21b332efa67b9bd65bc0ca976c1cc" // ram, 3 actions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkButton.layer.cornerRadius = 4
        self.contractTextView.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.transactionEntryField.becomeFirstResponder()
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        guard let validTransactionText = transactionEntryField.text, transactionEntryField.text?.isEmpty == false else {
            let alert = UIAlertController.simpleAlert(withTitle: "Transaction Field is empty", message: "")
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.activityIndicator.startAnimating()
        
        //1. Get Actions
        EOSAPI.current.getTransactionActions(byId: validTransactionText) { (actions, error) in
            guard let validActions = actions, error == nil else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.handleNetworkManagerErrors(error: error!)
                }
                return
            }
            
            //2. Get Contracts
            EOSAPI.current.getContratsFor(actions: validActions, completion: { contracts, error  in
                guard let validContracts = contracts, error == nil else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.handleNetworkManagerErrors(error: error!)
                    }
                    return
                }
                
                // 3. Render Contract
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if let contracts = EOSAPI.current.renderContractsForActions(contracts: validContracts, actions: validActions) {
                    self.contractTextView.text = contracts.joined(separator: "\n\n\n")
                    }
                }
            })
        }
    }
    
    @IBAction func prePopulateButtonPressed(_ sender: UIButton) {
        self.transactionEntryField.text = trxId2
        self.transactionEntryField.resignFirstResponder()
    }
    
}
