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
