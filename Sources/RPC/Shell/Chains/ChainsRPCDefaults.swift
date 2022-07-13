//
//  ChainsRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

// MARK: Chains

public extension Chains {
    static var mainRaw: String { "main" }
    static var testRaw: String { "test" }
    
    var main: ChainsChain { self(chainID: Self.mainRaw) }
    var test: ChainsChain { self(chainID: Self.testRaw) }
    
    func callAsFunction(chainID: ChainID) -> ChainsChain {
        self(chainID: chainID.base58)
    }
}

// MARK: ChainsChain

public extension ChainsChain {
    func patch(bootstrapped: Bool) async throws -> SetBootstrappedResult {
        try await patch(bootstrapped: bootstrapped, configuredWith: .init())
    }
}

// MARK: ChainsChainBlocks

public extension ChainsChainBlocks {
    static var headRaw: String { "head" }
    
    var head: Block { self(blockID: Self.headRaw) }
    
    func get() async throws -> GetBlocksResponse {
        try await get(configuredWith: .init())
    }
    
    func callAsFunction(blockID: BlockHash) -> Block {
        self(blockID: blockID.base58)
    }
}

// MARK: ChainsChainChainID

public extension ChainsChainChainID {
    func get() async throws -> GetChainIDResponse {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainInvalidBlocks

public extension ChainsChainInvalidBlocks {
    func get() async throws -> GetInvalidBlocksResponse {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainInvalidBlocksBlock

public extension ChainsChainInvalidBlocksBlock {
    func get() async throws -> GetInvalidBlockResponse {
        try await get(configuredWith: .init())
    }
    
    func delete() async throws -> DeleteInvalidBlockResponse {
        try await delete(configuredWith: .init())
    }
}

// MARK: ChainsChainIsBootstrapped

public extension ChainsChainIsBootstrapped {
    func get() async throws -> GetBootstrappedStatusResponse {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainLevelsCaboose

public extension ChainsChainLevelsCaboose {
    func get() async throws -> GetCabooseResponse {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainLevelsCheckpoint

public extension ChainsChainLevelsCheckpoint {
    func get() async throws -> GetCheckpointResponse {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainLevelsSavepoint

public extension ChainsChainLevelsSavepoint {
    func get() async throws -> GetSavepointResponse {
        try await get(configuredWith: .init())
    }
}
