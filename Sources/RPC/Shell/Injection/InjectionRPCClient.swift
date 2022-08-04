//
//  InjectionRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

// MARK: /injection

public class InjectionClient<HTTPClient: HTTP>: Injection {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /injection */ parentURL.appendingPathComponent("injection")
        self.http = http
    }
    
    public lazy var block: InjectionBlockClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var operation: InjectionOperationClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var `protocol`: InjectionProtocolClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: /injection/block

public struct InjectionBlockClient<HTTPClient: HTTP>: InjectionBlock {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /injection/block */ parentURL.appendingPathComponent("block")
        self.http = http
    }
    
    public func post(
        data: String,
        operations: [[RPCInjectableOperation]],
        configuredWith configuration: InjectionBlockPostConfiguration
    ) async throws -> BlockHash {
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

public struct InjectionOperationClient<HTTPClient: HTTP>: InjectionOperation {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /injection/operation */ parentURL.appendingPathComponent("operation")
        self.http = http
    }
    
    public func post(data: String, configuredWith configuration: InjectionOperationPostConfiguration) async throws -> OperationHash {
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
            request: data
        )
    }
}

// MARK: /injection/protocol

public struct InjectionProtocolClient<HTTPClient: HTTP>: InjectionProtocol {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /injection/protocol */ parentURL.appendingPathComponent("protocol")
        self.http = http
    }
    
    public func post(
        expectedEnvVersion: UInt16,
        components: [RPCProtocolComponent],
        configuredWith configuration: InjectionProtocolPostConfiguration
    ) async throws -> ProtocolHash {
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
