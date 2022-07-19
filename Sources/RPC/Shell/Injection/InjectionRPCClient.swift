//
//  InjectionRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation

// MARK: /injection

class InjectionClient<HTTPClient: HTTP>: Injection {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* /injection */ parentURL.appendingPathComponent("injection")
        self.http = http
    }
    
    lazy var block: InjectionBlock = InjectionBlockClient(parentURL: baseURL, http: http)
    lazy var operation: InjectionOperation = InjectionOperationClient(parentURL: baseURL, http: http)
    lazy var `protocol`: InjectionProtocol = InjectionProtocolClient(parentURL: baseURL, http: http)
}

// MARK: /injection/block

struct InjectionBlockClient<HTTPClient: HTTP>: InjectionBlock {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
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

struct InjectionOperationClient<HTTPClient: HTTP>: InjectionOperation {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
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

struct InjectionProtocolClient<HTTPClient: HTTP>: InjectionProtocol {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
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
