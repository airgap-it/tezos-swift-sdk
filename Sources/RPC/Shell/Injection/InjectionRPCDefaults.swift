//
//  InjectionRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation

// MARK: InjectionBlock

extension InjectionBlock {
    func post(data: String, operations: [[RPCInjectableOperation]]) async throws -> InjectBlockResponse {
        try await post(data: data, operations: operations, configuredWith: .init())
    }
}

// MARK: InjectionOperation

extension InjectionOperation {
    func post(data: String) async throws -> InjectOperationResponse {
        try await post(data: data, configuredWith: .init())
    }
}

// MARK: InjectionProtocol

extension InjectionProtocol {
    func post(expectedEnvVersion: UInt16, components: [RPCProtocolComponent]) async throws -> InjectProtocolResponse {
        try await post(expectedEnvVersion: expectedEnvVersion, components: components, configuredWith: .init())
    }
}
