//
//  ChainsRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

// MARK: /chains

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

class ChainsChainClient: ChainsChain {
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
    
    lazy var blocks: ChainsChainBlocks = ChainsChainBlocksClient(parentURL: baseURL, http: http)
    lazy var chainID: ChainsChainChainID = ChainsChainChainIDClient(parentURL: baseURL, http: http)
    lazy var invalidBlocks: ChainsChainInvalidBlocks = ChainsChainInvalidBlocksClient(parentURL: baseURL, http: http)
    lazy var isBootstrapped: ChainsChainIsBootstrapped = ChainsChainIsBootstrappedClient(parentURL: baseURL, http: http)
    lazy var levels: ChainsChainLevels = ChainsChainLevelsClient(parentURL: baseURL, http: http)
}

// MARK: /chains/<chain_id>/blocks

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
    
    func callAsFunction(blockID: String) -> Block {
        BlockClient(parentURL: baseURL, blockID: blockID, http: http)
    }
}

// MARK: /chains/<chain_id>/chain_id

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

class ChainsChainLevelsClient: ChainsChainLevels {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /chains/<chain_id>/levels */ parentURL.appendingPathComponent("levels")
        self.http = http
    }

    lazy var caboose: ChainsChainLevelsCaboose = ChainsChainLevelsCabooseClient(parentURL: baseURL, http: http)
    lazy var checkpoint: ChainsChainLevelsCheckpoint = ChainsChainLevelsCheckpointClient(parentURL: baseURL, http: http)
    lazy var savepoint: ChainsChainLevelsSavepoint = ChainsChainLevelsSavepointClient(parentURL: baseURL, http: http)
}

// MARK: /chains/<chain_id>/levels/caboose

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
