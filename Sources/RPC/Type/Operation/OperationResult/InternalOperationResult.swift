//
//  InternalOperationResult.swift
//  
//
//  Created by Julia Samol on 18.07.22.
//

import Foundation
import TezosCore
import TezosOperation

// MARK: RPCInternalOperationResult

public enum RPCInternalOperationResult: Hashable, Codable {
    case transaction(Transaction)
    case origination(Origination)
    case delegation(Delegation)
    
    public var source: Address {
        switch self {
        case .transaction(let transaction):
            return transaction.source
        case .origination(let origination):
            return origination.source
        case .delegation(let delegation):
            return delegation.source
        }
    }
    
    public var nonce: UInt16 {
        switch self {
        case .transaction(let transaction):
            return transaction.nonce
        case .origination(let origination):
            return origination.nonce
        case .delegation(let delegation):
            return delegation.nonce
        }
    }
    
    public var amount: Mutez? {
        switch self {
        case .transaction(let transaction):
            return transaction.amount
        case .origination(_):
            return nil
        case .delegation(_):
            return nil
        }
    }
    
    public var balance: Mutez? {
        switch self {
        case .transaction(_):
            return nil
        case .origination(let origination):
            return origination.balance
        case .delegation(_):
            return nil
        }
    }
    
    public var destination: Address? {
        switch self {
        case .transaction(let transaction):
            return transaction.destination
        case .origination(_):
            return nil
        case .delegation(_):
            return nil
        }
    }
    
    public var delegate: Address? {
        switch self {
        case .transaction(_):
            return nil
        case .origination(let origination):
            return origination.delegate
        case .delegation(let delegation):
            return delegation.delegate
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .transaction(let transaction):
            return transaction.parameters
        case .origination(_):
            return nil
        case .delegation(_):
            return nil
        }
    }
    
    public var script: Script? {
        switch self {
        case .transaction(_):
            return nil
        case .origination(let origination):
            return origination.script
        case .delegation(_):
            return nil
        }
    }
    
    public var result: RPCOperationResult {
        switch self {
        case .transaction(let transaction):
            return .transaction(transaction.result)
        case .origination(let origination):
            return .origination(origination.result)
        case .delegation(let delegation):
            return .delegation(delegation.result)
        }
    }
    
    private enum Kind: String, Codable {
        case transaction
        case origination
        case delegation
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .transaction:
            self = .transaction(try .init(from: decoder))
        case .origination:
            self = .origination(try .init(from: decoder))
        case .delegation:
            self = .delegation(try .init(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .transaction(let transaction):
            try transaction.encode(to: encoder)
        case .origination(let origination):
            try origination.encode(to: encoder)
        case .delegation(let delegation):
            try delegation.encode(to: encoder)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case kind
    }
}

// MARK: RPCInternalOperationResult.Transaction

extension RPCInternalOperationResult {
    
    public struct Transaction: Hashable, Codable {
        public let source: Address
        public let nonce: UInt16
        public let amount: Mutez
        public let destination: Address
        public let parameters: Parameters?
        public let result: RPCOperationResult.Transaction
        
        public init(
            source: Address,
            nonce: UInt16,
            amount: Mutez,
            destination: Address,
            parameters: Parameters? = nil,
            result: RPCOperationResult.Transaction
        ) {
            self.source = source
            self.nonce = nonce
            self.amount = amount
            self.destination = destination
            self.parameters = parameters
            self.result = result
        }
    }
}

// MARK: RPCInternalOperationResult.Origination

extension RPCInternalOperationResult {
    
    public struct Origination: Hashable, Codable {
        public let source: Address
        public let nonce: UInt16
        public let balance: Mutez
        public let delegate: Address?
        public let script: Script
        public let result: RPCOperationResult.Origination
        
        public init(
            source: Address,
            nonce: UInt16,
            balance: Mutez,
            delegate: Address? = nil,
            script: Script,
            result: RPCOperationResult.Origination
        ) {
            self.source = source
            self.nonce = nonce
            self.balance = balance
            self.delegate = delegate
            self.script = script
            self.result = result
        }
    }
}

// MARK: RPCInternalOperationResult.Delegation

extension RPCInternalOperationResult {
    
    public struct Delegation: Hashable, Codable {
        public let source: Address
        public let nonce: UInt16
        public let delegate: Address?
        public let result: RPCOperationResult.Delegation
        
        public init(
            source: Address,
            nonce: UInt16,
            delegate: Address? = nil,
            result: RPCOperationResult.Delegation
        ) {
            self.source = source
            self.nonce = nonce
            self.delegate = delegate
            self.result = result
        }
    }
}
