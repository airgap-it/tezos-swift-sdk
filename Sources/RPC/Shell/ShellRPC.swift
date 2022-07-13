//
//  ShellRPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import Foundation
import TezosCore

public protocol ShellSimplifiedRPC {
    func getBlocks(chainID: String, configuredWith configuration: GetBlocksConfiguration) async throws -> GetBlocksResponse
    func getChainID(chainID: String, configuredWith configuration: GetChainIDConfiguration) async throws -> GetChainIDResponse
    func isBootstrapped(chainID: String, configuredWith configuration: IsBootstrappedConfiguration) async throws -> GetBootstrappedStatusResponse
    
    func injectOperation(_ data: String, configuredWith configuration: InjectOperationConfiguration) async throws -> InjectOperationResponse
}

// MARK: Extensions

public extension ShellSimplifiedRPC {
    func getBlocks(chainID: String) async throws -> GetBlocksResponse {
        try await getBlocks(chainID: chainID, configuredWith: .init())
    }
    
    func getBlocks(chainID: ChainID, configuredWith configuration: GetBlocksConfiguration = .init()) async throws -> GetBlocksResponse {
        try await getBlocks(chainID: chainID.base58, configuredWith: configuration)
    }
    
    func getChainID(chainID: String) async throws -> GetChainIDResponse {
        try await getChainID(chainID: chainID, configuredWith: .init())
    }
    
    func getChainID(chainID: ChainID, configuredWith configuration: GetChainIDConfiguration = .init()) async throws -> GetChainIDResponse {
        try await getChainID(chainID: chainID.base58, configuredWith: configuration)
    }
    
    func isBootstrapped(chainID: String) async throws -> GetBootstrappedStatusResponse {
        try await isBootstrapped(chainID: chainID, configuredWith: .init())
    }
    
    func isBootstrapped(chainID: ChainID, configuredWith configuration: IsBootstrappedConfiguration = .init()) async throws -> GetBootstrappedStatusResponse {
        try await isBootstrapped(chainID: chainID.base58, configuredWith: configuration)
    }
    
    func injectOperation(_ data: String) async throws -> InjectOperationResponse {
        try await injectOperation(data, configuredWith: .init())
    }
}

// MARK: Configuration

public typealias GetBlocksConfiguration = ChainsChainBlocksGetConfiguration
public typealias GetChainIDConfiguration = ChainsChainChainIDGetConfiguration
public typealias IsBootstrappedConfiguration = ChainsChainIsBootstrappedGetConfiguration

public typealias InjectOperationConfiguration = InjectionOperationPostConfiguration

// MARK: Client

struct ShellSimplifiedRPCClient: ShellSimplifiedRPC {
    private let chains: Chains
    private let injection: Injection
    
    init(chains: Chains, injection: Injection) {
        self.chains = chains
        self.injection = injection
    }
    
    func getBlocks(chainID: String, configuredWith configuration: GetBlocksConfiguration) async throws -> GetBlocksResponse {
        try await chains(chainID: chainID).blocks.get(configuredWith: configuration)
    }
    
    func getChainID(chainID: String, configuredWith configuration: GetChainIDConfiguration) async throws -> GetChainIDResponse {
        try await chains(chainID: chainID).chainID.get(configuredWith: configuration)
    }
    
    func isBootstrapped(chainID: String, configuredWith configuration: IsBootstrappedConfiguration) async throws -> GetBootstrappedStatusResponse {
        try await chains(chainID: chainID).isBootstrapped.get(configuredWith: configuration)
    }
    
    func injectOperation(_ data: String, configuredWith configuration: InjectOperationConfiguration) async throws -> InjectOperationResponse {
        try await injection.operation.post(data: data, configuredWith: configuration)
    }
}
