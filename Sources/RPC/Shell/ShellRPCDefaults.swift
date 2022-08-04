//
//  ShellRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore

public extension ShellSimplifiedRPC {
    func getBlocks(chainID: RPCChainID = .main) async throws -> [BlockHash] {
        try await getBlocks(chainID: chainID, configuredWith: .init())
    }
    
    func getChainID(chainID: RPCChainID = .main) async throws -> ChainID {
        try await getChainID(chainID: chainID, configuredWith: .init())
    }
    
    func isBootstrapped(chainID: RPCChainID = .main) async throws -> RPCChainBootstrappedStatus {
        try await isBootstrapped(chainID: chainID, configuredWith: .init())
    }
    
    func injectOperation(_ data: String) async throws -> OperationHash {
        try await injectOperation(data, configuredWith: .init())
    }
}
