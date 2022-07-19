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

// MARK: /injection/block

public protocol InjectionBlock {
    func post(
        data: String,
        operations: [[RPCInjectableOperation]],
        configuredWith configuration: InjectionBlockPostConfiguration
    ) async throws -> BlockHash
}

// MARK: /injection/operation

public protocol InjectionOperation {
    func post(data: String, configuredWith configuration: InjectionOperationPostConfiguration) async throws -> OperationHash
}

// MARK: /injection/protocol

public protocol InjectionProtocol {
    func post(
        expectedEnvVersion: UInt16,
        components: [RPCProtocolComponent],
        configuredWith configuration: InjectionProtocolPostConfiguration
    ) async throws -> ProtocolHash
}
