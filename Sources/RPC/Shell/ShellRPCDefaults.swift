//
//  ShellRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

public extension ShellSimplifiedRPC {
    func getBlocks(chainID: RPCChainID = .main) async throws -> GetBlocksResponse {
        try await getBlocks(chainID: chainID, configuredWith: .init())
    }
    
    func getChainID(chainID: RPCChainID = .main) async throws -> GetChainIDResponse {
        try await getChainID(chainID: chainID, configuredWith: .init())
    }
    
    func isBootstrapped(chainID: RPCChainID = .main) async throws -> GetBootstrappedStatusResponse {
        try await isBootstrapped(chainID: chainID, configuredWith: .init())
    }
    
    func injectOperation(_ data: String) async throws -> InjectOperationResponse {
        try await injectOperation(data, configuredWith: .init())
    }
}
