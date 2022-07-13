//
//  InjectionRPC.swift
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

struct InjectionClient: Injection {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /injection */ parentURL.appendingPathComponent("injection")
        self.http = http
    }
    
    var block: InjectionBlock { InjectionBlockClient(parentURL: baseURL, http: http) }
    var operation: InjectionOperation { InjectionOperationClient(parentURL: baseURL, http: http) }
    var `protocol`: InjectionProtocol { InjectionProtocolClient(parentURL: baseURL, http: http) }
}

// MARK: /injection/block

public protocol InjectionBlock {
    func post(
        data: String,
        operations: [[RPCInjectableOperation]],
        configuredWith configuration: InjectionBlockPostConfiguration
    ) async throws -> InjectBlockResponse
}

extension InjectionBlock {
    func post(data: String, operations: [[RPCInjectableOperation]]) async throws -> InjectBlockResponse {
        try await post(data: data, operations: operations, configuredWith: .init())
    }
}

public struct InjectionBlockPostConfiguration: BaseConfiguration {
    let async: Bool?
    let force: Bool?
    let chain: ChainID?
    let headers: [HTTPHeader]
    
    public init(async: Bool? = nil, force: Bool? = nil, chain: ChainID? = nil, headers: [HTTPHeader] = []) {
        self.async = async
        self.force = force
        self.chain = chain
        self.headers = headers
    }
}

struct InjectionBlockClient: InjectionBlock {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /injection/block */ parentURL.appendingPathComponent("block")
        self.http = http
    }
    
    func post(
        data: String,
        operations: [[RPCInjectableOperation]],
        configuredWith configuration: InjectionBlockPostConfiguration
    ) async throws -> InjectBlockResponse {
        var parameters = [HTTPParameter]()
        if let async = configuration.async, async {
            parameters.append(("async", nil))
        }
        if let force = configuration.force, force {
            parameters.append(("force", nil))
        }
        if let chain = configuration.chain {
            parameters.append(("chain", chain.base58))
        }
        
        return try await http.post(
            baseURL: baseURL,
            endpoint: "/",
            headers: configuration.headers,
            parameters: parameters,
            request: InjectBlockRequest(data: data, operations: operations)
        )
    }
}

// MARK: /injection/operation

public protocol InjectionOperation {
    func post(data: String, configuredWith configuration: InjectionOperationPostConfiguration) async throws -> InjectOperationResponse
}

extension InjectionOperation {
    func post(data: String) async throws -> InjectOperationResponse {
        try await post(data: data, configuredWith: .init())
    }
}

public struct InjectionOperationPostConfiguration: BaseConfiguration {
    let async: Bool?
    let chain: ChainID?
    let headers: [HTTPHeader]
    
    public init(async: Bool? = nil, chain: ChainID? = nil, headers: [HTTPHeader] = []) {
        self.async = async
        self.chain = chain
        self.headers = headers
    }
}

struct InjectionOperationClient: InjectionOperation {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /injection/operation */ parentURL.appendingPathComponent("operation")
        self.http = http
    }
    
    func post(data: String, configuredWith configuration: InjectionOperationPostConfiguration) async throws -> InjectOperationResponse {
        var parameters = [HTTPParameter]()
        if let async = configuration.async, async {
            parameters.append(("async", nil))
        }
        if let chain = configuration.chain {
            parameters.append(("chain", chain.base58))
        }
        
        return try await http.post(
            baseURL: baseURL,
            endpoint: "/",
            headers: configuration.headers,
            parameters: parameters,
            request: InjectOperationRequest(data)
        )
    }
}

// MARK: /injection/protocol

public protocol InjectionProtocol {
    func post(
        expectedEnvVersion: UInt16,
        components: [RPCProtocolComponent],
        configuredWith configuration: InjectionProtocolPostConfiguration
    ) async throws -> InjectProtocolResponse
}

extension InjectionProtocol {
    func post(expectedEnvVersion: UInt16, components: [RPCProtocolComponent]) async throws -> InjectProtocolResponse {
        try await post(expectedEnvVersion: expectedEnvVersion, components: components, configuredWith: .init())
    }
}

public struct InjectionProtocolPostConfiguration: BaseConfiguration {
    let async: Bool?
    let headers: [HTTPHeader]
    
    public init(async: Bool? = nil, headers: [HTTPHeader] = []) {
        self.async = async
        self.headers = headers
    }
}

struct InjectionProtocolClient: InjectionProtocol {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* /injection/protocol */ parentURL.appendingPathComponent("protocol")
        self.http = http
    }
    
    func post(
        expectedEnvVersion: UInt16,
        components: [RPCProtocolComponent],
        configuredWith configuration: InjectionProtocolPostConfiguration
    ) async throws -> InjectProtocolResponse {
        var parameters = [HTTPParameter]()
        if let async = configuration.async, async {
            parameters.append(("async", nil))
        }
        
        return try await http.post(
            baseURL: baseURL,
            endpoint: "/",
            headers: configuration.headers,
            parameters: parameters,
            request: InjectProtocolRequest(expectedEnvVersion: expectedEnvVersion, components: components)
        )
    }
}
