//
//  Block.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/29/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import Foundation

struct Block: Codable {
    
    var previous: String?
    var timestamp: Date?
    var transactionMerkleRoot: String?
    var producer: String?
    var producerChanges: [String]?
    var producerSignature: String?
    var cycles: [String]?
    var id: String?
    var blockNum: Int
    var refBlockPrefix: Int
    var inputTransactions: [String]?
    
}
