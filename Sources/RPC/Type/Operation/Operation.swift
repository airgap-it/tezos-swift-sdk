//
//  Operation.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation
import TezosCore

// MARK: RPCOperation

public struct RPCOperation: Hashable, Codable {
    // TODO
}

// MARK: ApplicableOperation

public struct RPCApplicableOperation: Hashable, Codable {
    // TODO
}

// MARK: AppliedOperation

public struct RPCAppliedOperation: Hashable, Codable {
    // TODO
}

// MARK: InjectableOperation

public struct RPCInjectableOperation: Hashable, Codable {
    public let branch: BlockHash
    public let data: String
    
    public init(branch: BlockHash, data: String) {
        self.branch = branch
        self.data = data
    }
}

// MARK: RunnableOperation

public struct RPCRunnableOperation: Hashable, Codable {
    // TODO
}
