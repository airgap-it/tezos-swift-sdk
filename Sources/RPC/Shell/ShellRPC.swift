//
//  ShellRPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import TezosCore

public protocol ShellSimplifiedRPC {
    func getBlocks(chainID: RPCChainID, configuredWith configuration: GetBlocksConfiguration) async throws -> [BlockHash]
    func getChainID(chainID: RPCChainID, configuredWith configuration: GetChainIDConfiguration) async throws -> ChainID
    func isBootstrapped(chainID: RPCChainID, configuredWith configuration: IsBootstrappedConfiguration) async throws -> RPCChainBootstrappedStatus
    
    func injectOperation(_ data: String, configuredWith configuration: InjectOperationConfiguration) async throws -> OperationHash
}
