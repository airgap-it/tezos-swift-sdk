//
//  OperationMetadata.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation

// MARK: RPCOperationListMetadata

public struct RPCOperationListMetadata: Hashable, Codable {
    public let maxSize: Int32
    public let maxOperations: Int32?
    
    public init(maxSize: Int32, maxOperations: Int32? = nil) {
        self.maxSize = maxSize
        self.maxOperations = maxOperations
    }
    
    enum CodingKeys: String, CodingKey {
        case maxSize = "max_size"
        case maxOperations = "max_op"
    }
}
