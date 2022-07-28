//
//  ChainsRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore

// MARK: Chains

public extension Chains {
    var main: ChainRPC { self(chainID: .main) }
    var test: ChainRPC { self(chainID: .test) }
    
    func callAsFunction(chainID: ChainID) -> ChainRPC {
        self(chainID: .id(chainID))
    }
}

// MARK: ChainsChain

public extension ChainsChain {
    func patch(bootstrapped: Bool) async throws {
        try await patch(bootstrapped: bootstrapped, configuredWith: .init())
    }
}

// MARK: ChainsChainBlocks

public extension ChainsChainBlocks {
    var head: BlockRPC { self(blockID: .head) }
    
    func get() async throws -> [BlockHash] {
        try await get(configuredWith: .init())
    }
    
    func callAsFunction(blockID: BlockHash) -> BlockRPC {
        self(blockID: .hash(blockID))
    }
}

// MARK: ChainsChainChainID

public extension ChainsChainChainID {
    func get() async throws -> ChainID {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainInvalidBlocks

public extension ChainsChainInvalidBlocks {
    func get() async throws -> [RPCInvalidBlock] {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainInvalidBlocksBlock

public extension ChainsChainInvalidBlocksBlock {
    func get() async throws -> RPCInvalidBlock {
        try await get(configuredWith: .init())
    }
    
    func delete() async throws {
        try await delete(configuredWith: .init())
    }
}

// MARK: ChainsChainIsBootstrapped

public extension ChainsChainIsBootstrapped {
    func get() async throws -> RPCChainBootstrappedStatus {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainLevelsCaboose

public extension ChainsChainLevelsCaboose {
    func get() async throws -> RPCChainCaboose {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainLevelsCheckpoint

public extension ChainsChainLevelsCheckpoint {
    func get() async throws -> RPCChainCheckpoint {
        try await get(configuredWith: .init())
    }
}

// MARK: ChainsChainLevelsSavepoint

public extension ChainsChainLevelsSavepoint {
    func get() async throws -> RPCChainSavepoint {
        try await get(configuredWith: .init())
    }
}
