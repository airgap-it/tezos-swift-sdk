//
//  InjectionRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore

// MARK: InjectionBlock

extension InjectionBlock {
    func post(data: String, operations: [[RPCInjectableOperation]]) async throws -> BlockHash {
        try await post(data: data, operations: operations, configuredWith: .init())
    }
}

// MARK: InjectionOperation

extension InjectionOperation {
    func post(data: String) async throws -> OperationHash {
        try await post(data: data, configuredWith: .init())
    }
}

// MARK: InjectionProtocol

extension InjectionProtocol {
    func post(expectedEnvVersion: UInt16, components: [RPCProtocolComponent]) async throws -> ProtocolHash {
        try await post(expectedEnvVersion: expectedEnvVersion, components: components, configuredWith: .init())
    }
}
