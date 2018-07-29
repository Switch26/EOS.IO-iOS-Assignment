//
//  ShowBlockInfoViewController.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/29/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import UIKit

class ShowBlockInfoViewController: UIViewController {
    
    var block: Block?

    @IBOutlet weak var blockNumberLabel: UILabel!
    @IBOutlet weak var blockDetailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let validBlock = self.block {
            self.blockNumberLabel.text = "#" + "\(validBlock.blockNum)"
            self.blockDetailsTextView.text = self.prepareStringDescription(forBlock: validBlock)
        }
    }
    
    func prepareStringDescription(forBlock block: Block) -> String {
        
        var description = ""
        if let producer = block.producer {
            description += "Producer: \(producer)\n\n"
        }
        if let timeStamp = block.timestamp {
            description += "Timestamp: \(timeStamp)\n\n"
        }
        if let blockId = block.id {
            description += "Block Id: \(blockId)\n\n"
        }
        if let previousBlock = block.previous {
            description += "Previous Block: \(previousBlock)\n\n"
        }
        if let merkleRoot = block.transactionMerkleRoot {
            description += "Transaction Merkle Root: \(merkleRoot)\n\n"
        }
        if let transactions = block.inputTransactions {
            var transactionsText = ""
            let _ = transactions.map { trans in
                if trans.count > 0 {
                    transactionsText += trans
                }
            }
            if transactionsText.count > 0 {
                description += "\(transactionsText)\n\n"
            }
        }
        
        return description
    }

}
