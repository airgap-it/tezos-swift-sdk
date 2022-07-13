//
//  ShellRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

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
