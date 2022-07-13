//
//  ChainsRPC.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation
import TezosCore

// MARK: /chains

public protocol Chains {
    func callAsFunction(chainID: String) -> ChainsChain
}

// MARK: /chains/<chain_id>

public protocol ChainsChain {
    func patch(bootstrapped: Bool, configuredWith configuration: ChainsChainPatchConfiguration) async throws -> SetBootstrappedResult
    
    var blocks: ChainsChainBlocks { get }
    var chainID: ChainsChainChainID { get }
    var invalidBlocks: ChainsChainInvalidBlocks { get }
    var isBootstrapped: ChainsChainIsBootstrapped { get }
    var levels: ChainsChainLevels { get }
}

// MARK: /chains/<chain_id>/blocks

public protocol ChainsChainBlocks {
    func get(configuredWith configuration: ChainsChainBlocksGetConfiguration) async throws -> GetBlocksResponse
    
    func callAsFunction(blockID: String) -> Block
}

// MARK: /chains/<chain_id>/chain_id

public protocol ChainsChainChainID {
    func get(configuredWith configuration: ChainsChainChainIDGetConfiguration) async throws -> GetChainIDResponse
}

// MARK: /chains/<chain_id>/invalid_blocks

public protocol ChainsChainInvalidBlocks {
    func get(configuredWith configuration: ChainsChainInvalidBlocksGetConfiguration) async throws -> GetInvalidBlocksResponse
    
    func callAsFunction(blockHash: BlockHash) -> ChainsChainInvalidBlocksBlock
}

// MARK: /chains/<chain_id>/invalid_blocks/<block_hash>

public protocol ChainsChainInvalidBlocksBlock {
    func get(configuredWith configuration: ChainsChainInvalidBlocksBlockGetConfiguration) async throws -> GetInvalidBlockResponse
    func delete(configuredWith configuration: ChainsChainInvalidBlocksBlockDeleteConfiguration) async throws -> DeleteInvalidBlockResponse
}

// MARK: /chains/<chain_id>/is_bootstrapped

public protocol ChainsChainIsBootstrapped {
    func get(configuredWith configuration: ChainsChainIsBootstrappedGetConfiguration) async throws -> GetBootstrappedStatusResponse
}

// MARK: /chains/<chain_id>/levels

public protocol ChainsChainLevels {
    var caboose: ChainsChainLevelsCaboose { get }
    var checkpoint: ChainsChainLevelsCheckpoint { get }
    var savepoint: ChainsChainLevelsSavepoint { get }
}

// MARK: /chains/<chain_id>/levels/caboose

public protocol ChainsChainLevelsCaboose {
    func get(configuredWith configuration: ChainsChainLevelsCabooseGetConfiguration) async throws -> GetCabooseResponse
}

// MARK: /chains/<chain_id>/levels/checkpoint

public protocol ChainsChainLevelsCheckpoint {
    func get(configuredWith configuration: ChainsChainLevelsCheckpointGetConfiguration) async throws -> GetCheckpointResponse
}

// MARK: /chains/<chain_id>/levels/savepoint

public protocol ChainsChainLevelsSavepoint {
    func get(configuredWith configuration: ChainsChainLevelsSavepointGetConfiguration) async throws -> GetSavepointResponse
}
