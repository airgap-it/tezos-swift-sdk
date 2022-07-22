//
//  ChainsRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

// MARK: /chains

struct ChainsClient<HTTPClient: HTTP>: Chains {
    let baseURL: URL
    let http: HTTPClient
    
    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains */ parentURL.appendingPathComponent("chains")
        self.http = http
    }
    
    func callAsFunction(chainID: RPCChainID) -> ChainsChainClient<HTTPClient> {
        .init(parentURL: baseURL, chainID: chainID, http: http)
    }
}

// MARK: /chains/<chain_id>

class ChainsChainClient<HTTPClient: HTTP>: ChainsChain {
    let baseURL: URL
    let http: HTTPClient
    
    init(parentURL: URL, chainID: RPCChainID, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id> */ parentURL.appendingPathComponent(chainID.rawValue)
        self.http = http
    }
    
    func patch(bootstrapped: Bool, configuredWith configuration: ChainsChainPatchConfiguration) async throws {
        let _: EmptyResponse = try await http.patch(
            baseURL: baseURL,
            endpoint: "/",
            headers: configuration.headers,
            parameters: [],
            request: SetBootstrappedRequest(bootstrapped: bootstrapped)
        )
    }
    
    lazy var blocks: ChainsChainBlocksClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    lazy var chainID: ChainsChainChainIDClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    lazy var invalidBlocks: ChainsChainInvalidBlocksClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    lazy var isBootstrapped: ChainsChainIsBootstrappedClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    lazy var levels: ChainsChainLevelsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: /chains/<chain_id>/blocks

struct ChainsChainBlocksClient<HTTPClient: HTTP>: ChainsChainBlocks {
    let baseURL: URL
    let http: HTTPClient
    
    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/blocks */ parentURL.appendingPathComponent("blocks")
        self.http = http
    }
    
    func get(configuredWith configuration: ChainsChainBlocksGetConfiguration) async throws -> [BlockHash] {
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
    
    func callAsFunction(blockID: RPCBlockID) -> BlockClient<HTTPClient> {
        .init(parentURL: baseURL, blockID: blockID, http: http)
    }
}

// MARK: /chains/<chain_id>/chain_id

struct ChainsChainChainIDClient<HTTPClient: HTTP>: ChainsChainChainID {
    let baseURL: URL
    let http: HTTPClient
    
    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/chain_id */ parentURL.appendingPathComponent("chain_id")
        self.http = http
    }
    
    func get(configuredWith configuration: ChainsChainChainIDGetConfiguration) async throws -> ChainID {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/invalid_blocks

struct ChainsChainInvalidBlocksClient<HTTPClient: HTTP>: ChainsChainInvalidBlocks {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/invalid_blocks */ parentURL.appendingPathComponent("invalid_blocks")
        self.http = http
    }
    
    func get(configuredWith configuration: ChainsChainInvalidBlocksGetConfiguration) async throws -> [RPCInvalidBlock] {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }

    func callAsFunction(blockHash: BlockHash) -> ChainsChainInvalidBlocksBlockClient<HTTPClient> {
        .init(parentURL: baseURL, blockHash: blockHash, http: http)
    }
}


// MARK: /chains/<chain_id>/invalid_blocks/<block_hash>

struct ChainsChainInvalidBlocksBlockClient<HTTPClient: HTTP>: ChainsChainInvalidBlocksBlock {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, blockHash: BlockHash, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/invalid_blocks/<block_hash> */ parentURL.appendingPathComponent(blockHash.base58)
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainInvalidBlocksBlockGetConfiguration) async throws -> RPCInvalidBlock {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    func delete(configuredWith configuration: ChainsChainInvalidBlocksBlockDeleteConfiguration) async throws {
        let _: EmptyResponse = try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/is_bootstrapped

struct ChainsChainIsBootstrappedClient<HTTPClient: HTTP>: ChainsChainIsBootstrapped {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/is_bootstrapped */ parentURL.appendingPathComponent("is_bootstrapped")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainIsBootstrappedGetConfiguration) async throws -> RPCChainBootstrappedStatus {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/levels

class ChainsChainLevelsClient<HTTPClient: HTTP>: ChainsChainLevels {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/levels */ parentURL.appendingPathComponent("levels")
        self.http = http
    }

    lazy var caboose: ChainsChainLevelsCabooseClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    lazy var checkpoint: ChainsChainLevelsCheckpointClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    lazy var savepoint: ChainsChainLevelsSavepointClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: /chains/<chain_id>/levels/caboose

struct ChainsChainLevelsCabooseClient<HTTPClient: HTTP>: ChainsChainLevelsCaboose {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/levels/caboose */ parentURL.appendingPathComponent("caboose")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainLevelsCabooseGetConfiguration) async throws -> RPCChainCaboose {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/levels/checkpoint

struct ChainsChainLevelsCheckpointClient<HTTPClient: HTTP>: ChainsChainLevelsCheckpoint {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/levels/checkpoint */ parentURL.appendingPathComponent("checkpoint")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainLevelsCheckpointGetConfiguration) async throws -> RPCChainCheckpoint {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: /chains/<chain_id>/levels/savepoint

struct ChainsChainLevelsSavepointClient<HTTPClient: HTTP>: ChainsChainLevelsSavepoint {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /chains/<chain_id>/levels/savepoint */ parentURL.appendingPathComponent("savepoint")
        self.http = http
    }

    func get(configuredWith configuration: ChainsChainLevelsSavepointGetConfiguration) async throws -> RPCChainSavepoint {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}
