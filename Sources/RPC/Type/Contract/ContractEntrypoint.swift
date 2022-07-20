//
//  ContractEntrypoint.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation
import TezosMichelson

// MARK: RPCContractEntrypoints

public struct RPCContractEntrypoints: Hashable, Codable {
    public let unreachable: [RPCUnreachableEntrypoint]
    public let entrypoints: [String: Micheline]
    
    public init(unreachable: [RPCUnreachableEntrypoint], entrypoints: [String: Micheline]) {
        self.unreachable = unreachable
        self.entrypoints = entrypoints
    }
}

// MARK: RPCUnreachableEntrypoint

public struct RPCUnreachableEntrypoint: Hashable, Codable {
    public let path: String
    
    public init(path: String) {
        self.path = path
    }
}
