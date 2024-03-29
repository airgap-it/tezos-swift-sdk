//
//  InjectionTypes.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

// MARK: /injection/block

public struct InjectBlockRequest: Hashable, Codable {
    public let data: String
    public let operations: [[RPCInjectableOperation]]
    
    public init(data: String, operations: [[RPCInjectableOperation]]) {
        self.data = data
        self.operations = operations
    }
}

// MARK: /injection/protocol

public struct InjectProtocolRequest: Hashable, Codable {
    public let expectedEnvVersion: UInt16
    public let components: [RPCProtocolComponent]
    
    public init(expectedEnvVersion: UInt16, components: [RPCProtocolComponent]) {
        self.expectedEnvVersion = expectedEnvVersion
        self.components = components
    }
    
    enum CodingKeys: String, CodingKey {
        case expectedEnvVersion = "expected_env_version"
        case components
    }
}
