//
//  InjectionRPCConfiguration.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore

public struct InjectionBlockPostConfiguration: BaseConfiguration {
    public let async: Bool?
    public let force: Bool?
    public let chain: ChainID?
    public let headers: [HTTPHeader]
    
    public init(async: Bool? = nil, force: Bool? = nil, chain: ChainID? = nil, headers: [HTTPHeader] = []) {
        self.async = async
        self.force = force
        self.chain = chain
        self.headers = headers
    }
}

public struct InjectionOperationPostConfiguration: BaseConfiguration {
    public let async: Bool?
    public let chain: ChainID?
    public let headers: [HTTPHeader]
    
    public init(async: Bool? = nil, chain: ChainID? = nil, headers: [HTTPHeader] = []) {
        self.async = async
        self.chain = chain
        self.headers = headers
    }
}

public struct InjectionProtocolPostConfiguration: BaseConfiguration {
    public let async: Bool?
    public let headers: [HTTPHeader]
    
    public init(async: Bool? = nil, headers: [HTTPHeader] = []) {
        self.async = async
        self.headers = headers
    }
}
