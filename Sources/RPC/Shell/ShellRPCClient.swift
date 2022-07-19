//
//  ShellRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation

struct ShellSimplifiedRPCClient: ShellSimplifiedRPC {
    private let chains: Chains
    private let injection: Injection
    
    init(chains: Chains, injection: Injection) {
        self.chains = chains
        self.injection = injection
    }
    
    func getBlocks(chainID: RPCChainID, configuredWith configuration: GetBlocksConfiguration) async throws -> GetBlocksResponse {
        try await chains(chainID: chainID).blocks.get(configuredWith: configuration)
    }
    
    func getChainID(chainID: RPCChainID, configuredWith configuration: GetChainIDConfiguration) async throws -> GetChainIDResponse {
        try await chains(chainID: chainID).chainID.get(configuredWith: configuration)
    }
    
    func isBootstrapped(chainID: RPCChainID, configuredWith configuration: IsBootstrappedConfiguration) async throws -> GetBootstrappedStatusResponse {
        try await chains(chainID: chainID).isBootstrapped.get(configuredWith: configuration)
    }
    
    func injectOperation(_ data: String, configuredWith configuration: InjectOperationConfiguration) async throws -> InjectOperationResponse {
        try await injection.operation.post(data: data, configuredWith: configuration)
    }
}
