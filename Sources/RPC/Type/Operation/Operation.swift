//
//  Operation.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation
import TezosCore

// MARK: InjectableOperation

public struct RPCInjectableOperation: Hashable, Codable {
    public let branch: BlockHash
    public let data: String
    
    public init(branch: BlockHash, data: String) {
        self.branch = branch
        self.data = data
    }
}
