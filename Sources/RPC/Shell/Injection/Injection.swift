//
//  Injection.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation
import TezosCore

// MARK: /injection

public protocol Injection {
    var block: InjectionBlock { get }
    var operation: InjectionOperation { get }
    var `protocol`: InjectionProtocol { get }
}

// MARK: /injection/block

public protocol InjectionBlock {
    func post(
        data: String,
        operations: [[RPCInjectableOperation]],
        configureWith configuration: PostInjectionBlockConfiguration
    ) async throws -> InjectBlockResponse
}

extension InjectionBlock {
    func post(data: String, operations: [[RPCInjectableOperation]]) async throws -> InjectBlockResponse {
        try await post(data: data, operations: operations, configureWith: .init())
    }
}

public struct PostInjectionBlockConfiguration {
    let async: Bool?
    let force: Bool?
    let chain: ChainID?
    let headers: [(String, String?)]
    
    public init(async: Bool? = nil, force: Bool? = nil, chain: ChainID? = nil, headers: [(String, String?)] = []) {
        self.async = async
        self.force = force
        self.chain = chain
        self.headers = headers
    }
}

// MARK: /injection/operation

public protocol InjectionOperation {
    func post(data: String, configureWith configuration: PostInjectionOperationConfiguration) async throws -> InjectOperationResponse
}

extension InjectionOperation {
    func post(data: String) async throws -> InjectOperationResponse {
        try await post(data: data, configureWith: .init())
    }
}

public struct PostInjectionOperationConfiguration {
    let async: Bool?
    let chain: ChainID?
    let headers: [(String, String?)]
    
    public init(async: Bool? = nil, chain: ChainID? = nil, headers: [(String, String?)] = []) {
        self.async = async
        self.chain = chain
        self.headers = headers
    }
}

// MARK: /injection/protocol

public protocol InjectionProtocol {
    func post(
        expectedEnvVersion: UInt16,
        components: [RPCProtocolComponent],
        configureWith configuration: PostInjectionProtocolConfiguration
    ) async throws -> InjectProtocolResponse
}

extension InjectionProtocol {
    func post(expectedEnvVersion: UInt16, components: [RPCProtocolComponent]) async throws -> InjectProtocolResponse {
        try await post(expectedEnvVersion: expectedEnvVersion, components: components, configureWith: .init())
    }
}

public struct PostInjectionProtocolConfiguration {
    let async: Bool?
    let headers: [(String, String?)]
    
    public init(async: Bool? = nil, headers: [(String, String?)] = []) {
        self.async = async
        self.headers = headers
    }
}
