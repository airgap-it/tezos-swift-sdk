//
//  ShellRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore

public struct ShellSimplifiedRPCClient<ChainsRPC: Chains, InjectionRPC: Injection>: ShellSimplifiedRPC {
    private let chains: ChainsRPC
    private let injection: InjectionRPC
    
    init(chains: ChainsRPC, injection: InjectionRPC) {
        self.chains = chains
        self.injection = injection
    }
    
    public func getBlocks(chainID: RPCChainID, configuredWith configuration: GetBlocksConfiguration) async throws -> [BlockHash] {
        try await chains(chainID: chainID).blocks.get(configuredWith: configuration)
    }
    
    public func getChainID(chainID: RPCChainID, configuredWith configuration: GetChainIDConfiguration) async throws -> ChainID {
        try await chains(chainID: chainID).chainID.get(configuredWith: configuration)
    }
    
    public func isBootstrapped(chainID: RPCChainID, configuredWith configuration: IsBootstrappedConfiguration) async throws -> RPCChainBootstrappedStatus {
        try await chains(chainID: chainID).isBootstrapped.get(configuredWith: configuration)
    }
    
    public func injectOperation(_ data: String, configuredWith configuration: InjectOperationConfiguration) async throws -> OperationHash {
        try await injection.operation.post(data: data, configuredWith: configuration)
    }
}
