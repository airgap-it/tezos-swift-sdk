//
//  Block.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation
import TezosCore

// MARK: Block

public struct RPCBlock: Hashable, Codable {
    
}

// MARK: InvalidBlock

public struct RPCInvalidBlock: Hashable, Codable {
    public let block: BlockHash
    public let level: Int32
    public let errors: [RPCError]
}
