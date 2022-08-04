//
//  ChainsRPC.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import TezosCore

// MARK: /chains

public protocol Chains {
    associatedtype ChainRPC: ChainsChain
    
    func callAsFunction(chainID: RPCChainID) -> ChainRPC
}

// MARK: /chains/<chain_id>

public protocol ChainsChain {
    associatedtype BlocksRPC: ChainsChainBlocks
    associatedtype ChainIDRPC: ChainsChainChainID
    associatedtype InvalidBlocksRPC: ChainsChainInvalidBlocks
    associatedtype IsBootstrappedRPC: ChainsChainIsBootstrapped
    associatedtype LevelsRPC: ChainsChainLevels
    
    func patch(bootstrapped: Bool, configuredWith configuration: ChainsChainPatchConfiguration) async throws
    
    var blocks: BlocksRPC { get }
    var chainID: ChainIDRPC { get }
    var invalidBlocks: InvalidBlocksRPC { get }
    var isBootstrapped: IsBootstrappedRPC { get }
    var levels: LevelsRPC { get }
}

// MARK: /chains/<chain_id>/blocks

public protocol ChainsChainBlocks {
    associatedtype BlockRPC: Block
    
    func get(configuredWith configuration: ChainsChainBlocksGetConfiguration) async throws -> [BlockHash]
    
    func callAsFunction(blockID: RPCBlockID) -> BlockRPC
}

// MARK: /chains/<chain_id>/chain_id

public protocol ChainsChainChainID {
    func get(configuredWith configuration: ChainsChainChainIDGetConfiguration) async throws -> ChainID
}

// MARK: /chains/<chain_id>/invalid_blocks

public protocol ChainsChainInvalidBlocks {
    associatedtype BlockRPC: ChainsChainInvalidBlocksBlock
    
    func get(configuredWith configuration: ChainsChainInvalidBlocksGetConfiguration) async throws -> [RPCInvalidBlock]
    
    func callAsFunction(blockHash: BlockHash) -> BlockRPC
}

// MARK: /chains/<chain_id>/invalid_blocks/<block_hash>

public protocol ChainsChainInvalidBlocksBlock {
    func get(configuredWith configuration: ChainsChainInvalidBlocksBlockGetConfiguration) async throws -> RPCInvalidBlock
    func delete(configuredWith configuration: ChainsChainInvalidBlocksBlockDeleteConfiguration) async throws
}

// MARK: /chains/<chain_id>/is_bootstrapped

public protocol ChainsChainIsBootstrapped {
    func get(configuredWith configuration: ChainsChainIsBootstrappedGetConfiguration) async throws -> RPCChainBootstrappedStatus
}

// MARK: /chains/<chain_id>/levels

public protocol ChainsChainLevels {
    associatedtype CabooseRPC
    associatedtype CheckpointRPC
    associatedtype SavepointRPC
    
    var caboose: CabooseRPC { get }
    var checkpoint: CheckpointRPC { get }
    var savepoint: SavepointRPC { get }
}

// MARK: /chains/<chain_id>/levels/caboose

public protocol ChainsChainLevelsCaboose {
    func get(configuredWith configuration: ChainsChainLevelsCabooseGetConfiguration) async throws -> RPCChainCaboose
}

// MARK: /chains/<chain_id>/levels/checkpoint

public protocol ChainsChainLevelsCheckpoint {
    func get(configuredWith configuration: ChainsChainLevelsCheckpointGetConfiguration) async throws -> RPCChainCheckpoint
}

// MARK: /chains/<chain_id>/levels/savepoint

public protocol ChainsChainLevelsSavepoint {
    func get(configuredWith configuration: ChainsChainLevelsSavepointGetConfiguration) async throws -> RPCChainSavepoint
}
