//
//  ChainsTypes.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation
import TezosCore

// MARK: /chains/<chain_id>

public struct SetBootstrappedRequest: Hashable, Codable {
    public let bootstrapped: Bool
    
    public init(bootstrapped: Bool) {
        self.bootstrapped = bootstrapped
    }
}

public typealias SetBootstrappedResult = EmptyResponse

// MARK: /chains/<chain_id>/blocks

public typealias GetBlocksResponse = [BlockHash]

// MARK: /chains/<chain_id>/chain_id

public typealias GetChainIDResponse = ChainID

// MARK: /chains/<chain_id>/invalid_blocks

public typealias GetInvalidBlocksResponse = [RPCInvalidBlock]

// MARK: /chains/<chain_id>/invalid_blocks/<block_hash>

public typealias GetInvalidBlockResponse = RPCInvalidBlock
public typealias DeleteInvalidBlockResponse = EmptyResponse

// MARK: /chains/<chain_id>/is_bootstrapped

public struct GetBootstrappedStatusResponse: Hashable, Codable {
    public let bootstrapped: Bool
    public let syncState: RPCChainStatus
    
    public init(bootstrapped: Bool, syncState: RPCChainStatus) {
        self.bootstrapped = bootstrapped
        self.syncState = syncState
    }
    
    enum CodingKeys: String, CodingKey {
        case bootstrapped
        case syncState = "sync_state"
    }
}

// MARK: /chains/<chain_id>/levels/caboose

public struct GetCabooseResponse: Hashable, Codable {
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

// MARK: /chains/<chain_id>/levels/checkpoint

public struct GetCheckpointResponse: Hashable, Codable {
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

// MARK: /chains/<chain_id>/levels/savepoint

public struct GetSavepointResponse: Hashable, Codable {
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
