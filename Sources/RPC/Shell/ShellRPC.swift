//
//  ShellRPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import Foundation
import TezosCore

public protocol ShellSimplifiedRPC {
    func getBlocks(chainID: String, configureWith configuration: GetBlocksConfiguration) async throws
    func getChainID(chainID: String, configureWith configuration: GetChainIDConfiguration) async throws
    func isBootstrapped(chainID: String, configureWith configuration: IsBootstrappedConfiguration) async throws
    
    func injectOperation(_ data: String, configureWith configuration: InjectOperationConfiguration) async throws
}

public extension ShellSimplifiedRPC {
    func getBlocks(chainID: String) async throws {
        try await getBlocks(chainID: chainID, configureWith: .init())
    }
    
    func getBlocks(chainID: ChainID, configureWith configuration: GetBlocksConfiguration = .init()) async throws {
        try await getBlocks(chainID: chainID.base58, configureWith: configuration)
    }
    
    func getChainID(chainID: String) async throws {
        try await getChainID(chainID: chainID, configureWith: .init())
    }
    
    func getChainID(chainID: ChainID, configureWith configuration: GetChainIDConfiguration) async throws {
        try await getChainID(chainID: chainID.base58, configureWith: configuration)
    }
    
    func isBootstrapped(chainID: String) async throws {
        try await isBootstrapped(chainID: chainID, configureWith: .init())
    }
    
    func isBootstrapped(chainID: ChainID, configureWith configuration: IsBootstrappedConfiguration) async throws {
        try await isBootstrapped(chainID: chainID.base58, configureWith: configuration)
    }
    
    func injectOperation(_ data: String) async throws {
        try await injectOperation(data, configureWith: .init())
    }
}

// MARK: Configuration

public struct GetBlocksConfiguration {
    let length: UInt32?
    let head: BlockHash?
    let minDate: String?
    let headers: [(String, String?)]
    
    public init(length: UInt32? = nil, head: BlockHash? = nil, minDate: String? = nil, headers: [(String, String?)] = []) {
        self.length = length
        self.head = head
        self.minDate = minDate
        self.headers = headers
    }
}

public struct GetChainIDConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

public struct IsBootstrappedConfiguration {
    let headers: [(String, String?)]
    
    public init(headers: [(String, String?)] = []) {
        self.headers = headers
    }
}

public struct InjectOperationConfiguration {
    let async: Bool?
    let chainID: ChainID?
    let headers: [(String, String?)]
    
    public init(async: Bool? = nil, chainID: ChainID? = nil, headers: [(String, String?)] = []) {
        self.async = async
        self.chainID = chainID
        self.headers = headers
    }
}
