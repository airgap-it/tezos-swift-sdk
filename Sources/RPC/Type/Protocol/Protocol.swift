//
//  Protocol.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation

// MARK: ProtocolComponent

public struct RPCProtocolComponent: Hashable, Codable {
    public let name: String
    public let implementation: String
    public let interface: String?
    
    public init(name: String, implementation: String, interface: String? = nil) {
        self.name = name
        self.implementation = implementation
        self.interface = interface
    }
}
