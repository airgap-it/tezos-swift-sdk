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

extension Chains {
    static var mainRaw: String { "main" }
    static var testRaw: String { "test" }
    
    public var main: ChainsChain { self(chainID: Self.mainRaw) }
    public var test: ChainsChain { self(chainID: Self.testRaw) }
    
    func callAsFunction(chainID: ChainID) -> ChainsChain {
        self(chainID: chainID.base58)
    }
}

struct ChainsClient: Chains {
    let baseURL: URL
    let http: HTTP
    
    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains */ parentURL.appendingPathComponent("chains")
        self.http = http
    }
    
    func callAsFunction(chainID: String) -> ChainsChain {
        ChainsChainClient(parentURL: baseURL, chainID: chainID, http: http)
    }
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

extension ChainsChain {
    func patch(bootstrapped: Bool) async throws -> SetBootstrappedResult {
        try await patch(bootstrapped: bootstrapped, configuredWith: .init())
    }
}

public typealias ChainsChainPatchConfiguration = HeadersOnlyConfiguration

struct ChainsChainClient: ChainsChain {
    let baseURL: URL
    let http: HTTP
    
    init(parentURL: URL, chainID: String, http: HTTP) {
        self.baseURL = /* /chains/<chain_id> */ parentURL.appendingPathComponent(chainID)
        self.http = http
    }
    
    func patch(bootstrapped: Bool, configuredWith configuration: ChainsChainPatchConfiguration) async throws -> SetBootstrappedResult {
        try await http.patch(
            baseURL: baseURL,
            endpoint: "/",
            headers: configuration.headers,
            parameters: [],
            request: SetBootstrappedRequest(bootstrapped: bootstrapped)
        )
    }
    
    var blocks: ChainsChainBlocks { ChainsChainBlocksClient(parentURL: baseURL, http: http) }
    var chainID: ChainsChainChainID { ChainsChainChainIDClient(parentURL: baseURL, http: http) }
    var invalidBlocks: ChainsChainInvalidBlocks { ChainsChainInvalidBlocksClient(parentURL: baseURL, http: http) }
    var isBootstrapped: ChainsChainIsBootstrapped { ChainsChainIsBootstrappedClient(parentURL: baseURL, http: http) }
    var levels: ChainsChainLevels { ChainsChainLevelsClient(parentURL: baseURL, http: http) }
}

// MARK: /chains/<chain_id>/blocks

public protocol ChainsChainBlocks {
    func get(configuredWith configuration: ChainsChainBlocksGetConfiguration) async throws -> GetBlocksResponse
    
    // TODO: Block
}

extension ChainsChainBlocks {
    func get() async throws -> GetBlocksResponse {
        try await get(configuredWith: .init())
    }
}

public struct ChainsChainBlocksGetConfiguration: BaseConfiguration {
    let length: UInt32?
    let head: BlockHash?
    let minDate: String?
    let headers: [HTTPHeader]
    
    public init(length: UInt32? = nil, head: BlockHash? = nil, minDate: String? = nil, headers: [HTTPHeader] = []) {
        self.length = length
        self.head = head
        self.minDate = minDate
        self.headers = headers
    }
}

struct ChainsChainBlocksClient: ChainsChainBlocks {
    let baseURL: URL
    let http: HTTP
    
    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/blocks */ parentURL.appendingPathComponent("blocks")
        self.http = http
    }
    
    func get(configuredWith configuration: ChainsChainBlocksGetConfiguration) async throws -> GetBlocksResponse {
        var parameters = [HTTPParameter]()
        if let length = configuration.length {
            parameters.append(("length", String(length)))
        }
        if let head = configuration.head {
            parameters.append(("head", head.base58))
        }
        if let minDate = configuration.minDate {
            parameters.append(("min_date", minDate))
        }
        
        return try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: parameters)
    }
}

// MARK: /chains/<chain_id>/chain_id

public protocol ChainsChainChainID {
    func get(configuredWith configuration: ChainsChainChainIDGetConfiguration) async throws -> GetChainIDResponse
}

extension ChainsChainChainID {
    func get() async throws -> GetChainIDResponse {
        try await get(configuredWith: .init())
    }
}

public typealias ChainsChainChainIDGetConfiguration = HeadersOnlyConfiguration

struct ChainsChainChainIDClient: ChainsChainChainID {
    let baseURL: URL
    let http: HTTP
    
    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/chain_id */ parentURL.appendingPathComponent("chain_id")
        self.http = http
    }
    
    func get(configuredWith configuration: ChainsChainChainIDGetConfiguration) async throws -> GetChainIDResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/invalid_blocks

public protocol ChainsChainInvalidBlocks {
    func get(configuredWith configuration: ChainsChainInvalidBlocksGetConfiguration) async throws -> GetInvalidBlocksResponse
    
    func callAsFunction(blockHash: BlockHash) -> ChainsChainInvalidBlocksBlock
}

extension ChainsChainInvalidBlocks {
    func get() async throws -> GetInvalidBlocksResponse {
        try await get(configuredWith: .init())
    }
}

public typealias ChainsChainInvalidBlocksGetConfiguration = HeadersOnlyConfiguration

struct ChainsChainInvalidBlocksClient: ChainsChainInvalidBlocks {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/invalid_blocks */ parentURL.appendingPathComponent("invalid_blocks")
        self.http = http
    }
    
    func get(configuredWith configuration: ChainsChainInvalidBlocksGetConfiguration) async throws -> GetInvalidBlocksResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }

    func callAsFunction(blockHash: BlockHash) -> ChainsChainInvalidBlocksBlock {
        ChainsChainInvalidBlocksBlockClient(parentURL: baseURL, blockHash: blockHash, http: http)
    }
}


// MARK: /chains/<chain_id>/invalid_blocks/<block_hash>

public protocol ChainsChainInvalidBlocksBlock {
    func get(configuredWith configuration: ChainsChainInvalidBlocksBlockGetConfiguration) async throws -> GetInvalidBlockResponse
    func delete(configuredWith configuration: ChainsChainInvalidBlocksBlockDeleteConfiguration) async throws -> DeleteInvalidBlockResponse
}

extension ChainsChainInvalidBlocksBlock {
    func get() async throws -> GetInvalidBlockResponse {
        try await get(configuredWith: .init())
    }
    
    func delete() async throws -> DeleteInvalidBlockResponse {
        try await delete(configuredWith: .init())
    }
}

public typealias ChainsChainInvalidBlocksBlockGetConfiguration = HeadersOnlyConfiguration
public typealias ChainsChainInvalidBlocksBlockDeleteConfiguration = HeadersOnlyConfiguration

struct ChainsChainInvalidBlocksBlockClient: ChainsChainInvalidBlocksBlock {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, blockHash: BlockHash, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/invalid_blocks/<block_hash> */ parentURL.appendingPathComponent(blockHash.base58)
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainInvalidBlocksBlockGetConfiguration) async throws -> GetInvalidBlockResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    func delete(configuredWith configuration: ChainsChainInvalidBlocksBlockDeleteConfiguration) async throws -> DeleteInvalidBlockResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/is_bootstrapped

public protocol ChainsChainIsBootstrapped {
    func get(configuredWith configuration: ChainsChainIsBootstrappedGetConfiguration) async throws -> GetBootstrappedStatusResponse
}

extension ChainsChainIsBootstrapped {
    func get() async throws -> GetBootstrappedStatusResponse {
        try await get(configuredWith: .init())
    }
}

public typealias ChainsChainIsBootstrappedGetConfiguration = HeadersOnlyConfiguration

struct ChainsChainIsBootstrappedClient: ChainsChainIsBootstrapped {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/is_bootstrapped */ parentURL.appendingPathComponent("is_bootstrapped")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainIsBootstrappedGetConfiguration) async throws -> GetBootstrappedStatusResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/levels

public protocol ChainsChainLevels {
    var caboose: ChainsChainLevelsCaboose { get }
    var checkpoint: ChainsChainLevelsCheckpoint { get }
    var savepoint: ChainsChainLevelsSavepoint { get }
}

struct ChainsChainLevelsClient: ChainsChainLevels {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/levels */ parentURL.appendingPathComponent("levels")
        self.http = http
    }

    var caboose: ChainsChainLevelsCaboose { ChainsChainLevelsCabooseClient(parentURL: baseURL, http: http) }
    var checkpoint: ChainsChainLevelsCheckpoint { ChainsChainLevelsCheckpointClient(parentURL: baseURL, http: http) }
    var savepoint: ChainsChainLevelsSavepoint { ChainsChainLevelsSavepointClient(parentURL: baseURL, http: http) }
}

// MARK: /chains/<chain_id>/levels/caboose

public protocol ChainsChainLevelsCaboose {
    func get(configuredWith configuration: ChainsChainLevelsCabooseGetConfiguration) async throws -> GetCabooseResponse
}

extension ChainsChainLevelsCaboose {
    func get() async throws -> GetCabooseResponse {
        try await get(configuredWith: .init())
    }
}

public typealias ChainsChainLevelsCabooseGetConfiguration = HeadersOnlyConfiguration

struct ChainsChainLevelsCabooseClient: ChainsChainLevelsCaboose {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/levels/caboose */ parentURL.appendingPathComponent("caboose")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainLevelsCabooseGetConfiguration) async throws -> GetCabooseResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/levels/checkpoint

public protocol ChainsChainLevelsCheckpoint {
    func get(configuredWith configuration: ChainsChainLevelsCheckpointGetConfiguration) async throws -> GetCheckpointResponse
}

extension ChainsChainLevelsCheckpoint {
    func get() async throws -> GetCheckpointResponse {
        try await get(configuredWith: .init())
    }
}

public typealias ChainsChainLevelsCheckpointGetConfiguration = HeadersOnlyConfiguration

struct ChainsChainLevelsCheckpointClient: ChainsChainLevelsCheckpoint {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/levels/checkpoint */ parentURL.appendingPathComponent("checkpoint")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainLevelsCheckpointGetConfiguration) async throws -> GetCheckpointResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/levels/savepoint

public protocol ChainsChainLevelsSavepoint {
    func get(configuredWith configuration: ChainsChainLevelsSavepointGetConfiguration) async throws -> GetSavepointResponse
}

extension ChainsChainLevelsSavepoint {
    func get() async throws -> GetSavepointResponse {
        try await get(configuredWith: .init())
    }
}

public typealias ChainsChainLevelsSavepointGetConfiguration = HeadersOnlyConfiguration

struct ChainsChainLevelsSavepointClient: ChainsChainLevelsSavepoint {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/levels/savepoint */ parentURL.appendingPathComponent("savepoint")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainLevelsSavepointGetConfiguration) async throws -> GetSavepointResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}
