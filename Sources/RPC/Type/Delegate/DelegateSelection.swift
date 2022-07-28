//
//  DelegateSelection.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import TezosCore

// MARK: RPCDelegateSelection

public enum RPCDelegateSelection: Hashable, Codable {
    private static let randomRawValue: String = "random"
    
    case random
    case roundRobin([[Key.Public]])
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        if let random = try? String(from: decoder), random == Self.randomRawValue {
            self = .random
        } else if let publiKeys = try? [[Key.Public]](from: decoder) {
            self = .roundRobin(publiKeys)
        } else {
            throw TezosError.invalidValue("Unknown RPCDelegateSelection value.")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .random:
            try Self.randomRawValue.encode(to: encoder)
        case .roundRobin(let array):
            try array.encode(to: encoder)
        }
    }
}
