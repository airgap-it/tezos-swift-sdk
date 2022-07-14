//
//  ContractEntrypoint.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation

// MARK: RPCUnreachableEntrypoint

public struct RPCUnreachableEntrypoint: Hashable, Codable {
    public let path: String
    
    public init(path: String) {
        self.path = path
    }
}
