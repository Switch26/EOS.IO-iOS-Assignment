//
//  Chain.swift
//  GetEOSBlock
//
//  Created by Serguei Vinnitskii on 7/29/18.
//  Copyright © 2018 Serguei Vinnitskii. All rights reserved.
//

import Foundation

struct Chain: Codable {
    
    let serverVersion: String
    let chainId: String
    let headBlockNum: Int // latest block
    let lastIrreversibleBlockNum: Int
    let lastIrreversibleBlockId: String
    let headBlockId: String
    let headBlockProducer: String
    
}
