//
//  ChainLevels.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import Foundation
import TezosCore

// MARK: RPCChainCaboose

public struct RPCChainCaboose: Hashable, Codable {
    public let blockHash: BlockHash
    public let level: UInt32
    
    public init(blockHash: BlockHash, level: UInt32) {
        self.blockHash = blockHash
        self.level = level
    }
    
    enum CodingKeys: String, CodingKey {
        case blockHash = "block_hash"
        case level
    }
}

// MARK: RPCChainCheckpoint

public struct RPCChainCheckpoint: Hashable, Codable {
    public let blockHash: BlockHash
    public let level: UInt32
    
    public init(blockHash: BlockHash, level: UInt32) {
        self.blockHash = blockHash
        self.level = level
    }
    
    enum CodingKeys: String, CodingKey {
        case blockHash = "block_hash"
        case level
    }
}

// MARK: RPCChainSavepoint

public struct RPCChainSavepoint: Hashable, Codable {
    public let blockHash: BlockHash
    public let level: UInt32
    
    public init(blockHash: BlockHash, level: UInt32) {
        self.blockHash = blockHash
        self.level = level
    }
    
    enum CodingKeys: String, CodingKey {
        case blockHash = "block_hash"
        case level
    }
}
