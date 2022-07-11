//
//  Chains.swift
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

extension Chains {
    static var mainRaw: String { "main" }
    static var testRaw: String { "test" }
    
    public var main: ChainsChain { self(chainID: Self.mainRaw) }
    public var test: ChainsChain { self(chainID: Self.testRaw) }
    
    func callAsFunction(chainID: ChainID) -> ChainsChain {
        self(chainID: chainID.base58)
    }
}

// MARK: /chains/<chain_id>

public protocol ChainsChain {
    func patch(bootstrapped: Bool, configureWith configuration: PatchChainsChainConfiguration) async throws -> SetBootstrappedResult
    
    var blocks: ChainsChainBlock { get }
    var chainID: ChainsChainChainID { get }
    var invalidBlocks: ChainsChainInvalidBlocks { get }
    var levels: ChainsChainLevels { get }
}

extension ChainsChain {
    func patch(bootstrapped: Bool) async throws -> SetBootstrappedResult {
        try await patch(bootstrapped: bootstrapped, configureWith: .init())
    }
}

public struct PatchChainsChainConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

// MARK: /chains/<chain_id>/blocks

public protocol ChainsChainBlock {
    func get(configureWith configuration: GetChainsChainBlockConfiguration) async throws -> GetBlocksResponse
    
    // TODO: Block
}

extension ChainsChainBlock {
    func get() async throws -> GetBlocksResponse {
        try await get(configureWith: .init())
    }
}

public struct GetChainsChainBlockConfiguration {
    let length: UInt32?
    let head: BlockHash?
    let minDate: String?
    let headers: [(String, String?)]
    
    public init(length: UInt32? = nil, head: BlockHash? = nil, minDate: String? = nil, headers: [(String, String?)] = []) {
        self.length = length
        self.head = head
        self.minDate = minDate
        self.headers = headers
    }
}

// MARK: /chains/<chain_id>/chain_id

public protocol ChainsChainChainID {
    func get(configureWith configuration: GetChainsChainChainIDConfiguration) async throws -> GetChainIDResponse
}

extension ChainsChainChainID {
    func get() async throws -> GetChainIDResponse {
        try await get(configureWith: .init())
    }
}

public struct GetChainsChainChainIDConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

// MARK: /chains/<chain_id>/invalid_blocks

public protocol ChainsChainInvalidBlocks {
    func get(configureWith configuration: GetChainsChainInvalidBlocksConfiguration) async throws -> GetInvalidBlocksResponse
    
    func callAsFunction(blockHash: String) -> ChainsChainInvalidBlocksBlock
}

extension ChainsChainInvalidBlocks {
    func get() async throws -> GetInvalidBlocksResponse {
        try await get(configureWith: .init())
    }
    
    public func callAsFunction(blockHash: BlockHash) -> ChainsChainInvalidBlocksBlock {
        self(blockHash: blockHash.base58)
    }
}

public struct GetChainsChainInvalidBlocksConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}


// MARK: /chains/<chain_id>/invalid_blocks/<block_hash>

public protocol ChainsChainInvalidBlocksBlock {
    func get(configureWith configuration: GetChainsChainInvalidBlocksBlockConfiguration) async throws -> GetInvalidBlockResponse
    func delete(configureWith configuration: DeleteChainsChainInvalidBlocksBlockConfiguration) async throws -> DeleteInvalidBlockResponse
}

extension ChainsChainInvalidBlocksBlock {
    func get() async throws -> GetInvalidBlockResponse {
        try await get(configureWith: .init())
    }
    
    func delete() async throws -> DeleteInvalidBlockResponse {
        try await delete(configureWith: .init())
    }
}

public struct GetChainsChainInvalidBlocksBlockConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

public struct DeleteChainsChainInvalidBlocksBlockConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

// MARK: /chains/<chain_id>/is_bootstrapped

public protocol ChainsChainIsBootstrapped {
    func get(configureWith configuration: GetChainsChainIsBootstrappedConfiguration) async throws -> GetBootstrappedStatusResponse
}

extension ChainsChainIsBootstrapped {
    func get() async throws -> GetBootstrappedStatusResponse {
        try await get(configureWith: .init())
    }
}

public struct GetChainsChainIsBootstrappedConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

// MARK: /chains/<chain_id>/levels

public protocol ChainsChainLevels {
    var caboose: ChainsChainLevelsCaboose { get }
    var checkpoint: ChainsChainLevelsCheckpoint { get }
    var savepoint: ChainsChainLevelsSavepoint { get }
}

// MARK: /chains/<chain_id>/levels/caboose

public protocol ChainsChainLevelsCaboose {
    func get(configureWith configuration: GetChainsChainLevelsCabooseConfiguration) async throws -> GetCabooseResponse
}

extension ChainsChainLevelsCaboose {
    func get() async throws -> GetCabooseResponse {
        try await get(configureWith: .init())
    }
}

public struct GetChainsChainLevelsCabooseConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

// MARK: /chains/<chain_id>/levels/checkpoint

public protocol ChainsChainLevelsCheckpoint {
    func get(configureWith configuration: GetChainsChainLevelsCheckpointConfiguration) async throws -> GetCheckpointResponse
}

extension ChainsChainLevelsCheckpoint {
    func get() async throws -> GetCheckpointResponse {
        try await get(configureWith: .init())
    }
}

public struct GetChainsChainLevelsCheckpointConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

// MARK: /chains/<chain_id>/levels/savepoint

public protocol ChainsChainLevelsSavepoint {
    func get(configureWith configuration: GetChainsChainLevelsSavepointConfiguration) async throws -> GetSavepointResponse
}

extension ChainsChainLevelsSavepoint {
    func get() async throws -> GetSavepointResponse {
        try await get(configureWith: .init())
    }
}

public struct GetChainsChainLevelsSavepointConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}
