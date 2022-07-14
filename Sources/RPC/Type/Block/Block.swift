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
    public let `protocol`: ProtocolHash
    public let chainID: ChainID
    public let hash: BlockHash
    public let header: RPCBlockHeader
    public let metadata: RPCBlockHeaderMetadata?
    public let operations: [[RPCOperation]]
    
    enum CodingKeys: String, CodingKey {
        case `protocol`
        case chainID = "chain_id"
        case hash
        case header
        case metadata
        case operations
    }
}

// MARK: InvalidBlock

public struct RPCInvalidBlock: Hashable, Codable {
    public let block: BlockHash
    public let level: Int32
    public let errors: [RPCError]
}
