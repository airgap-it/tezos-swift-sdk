//
//  ManagerOperationResult.swift
//  
//
//  Created by Julia Samol on 18.07.22.
//

import TezosCore

// MARK: RPCSuccessfulManagerOperationResult

public enum RPCSuccessfulManagerOperationResult: Hashable, Codable {
    case reveal(Reveal)
    case transactionToContract(TransactionToContract)
    case transactionToTxRollup(TransactionToTxRollup)
    case origination(Origination)
    case delegation(Delegation)
    case setDepositsLimit(SetDepositsLimit)
    case scRollupOriginate(ScRollupOriginate)
    
    private enum Kind: String, Codable {
        case reveal
        case transaction
        case origination
        case delegation
        case setDepositsLimit = "set_deposits_limit"
        case scRollupOriginate = "sc_rollup_originate"
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .reveal:
            self = .reveal(try .init(from: decoder))
        case .transaction:
            if let toContract = try? TransactionToContract(from: decoder) {
                self = .transactionToContract(toContract)
            } else if let toTxRollup = try? TransactionToTxRollup(from: decoder) {
                self = .transactionToTxRollup(toTxRollup)
            } else {
                throw TezosError.invalidValue("Unknown RPCSuccessfulManagerOperationResult transaction.")
            }
        case .origination:
            self = .origination(try .init(from: decoder))
        case .delegation:
            self = .delegation(try .init(from: decoder))
        case .setDepositsLimit:
            self = .setDepositsLimit(try .init(from: decoder))
        case .scRollupOriginate:
            self = .scRollupOriginate(try .init(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .reveal(let reveal):
            try reveal.encode(to: encoder)
        case .transactionToContract(let transactionToContract):
            try transactionToContract.encode(to: encoder)
        case .transactionToTxRollup(let transactionToTxRollup):
            try transactionToTxRollup.encode(to: encoder)
        case .origination(let origination):
            try origination.encode(to: encoder)
        case .delegation(let delegation):
            try delegation.encode(to: encoder)
        case .setDepositsLimit(let setDepositsLimit):
            try setDepositsLimit.encode(to: encoder)
        case .scRollupOriginate(let scRollupOriginate):
            try scRollupOriginate.encode(to: encoder)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case kind
    }
}

// MARK: RPCSuccessfulManagerOperationResult.Reveal

extension RPCSuccessfulManagerOperationResult {
    
    public struct Reveal: Hashable, Codable {
        private let kind: Kind
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.kind = .reveal
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCSuccessfulManagerOperationResult.TransactionToContract

extension RPCSuccessfulManagerOperationResult {
    
    public struct TransactionToContract: Hashable, Codable {
        private let kind: Kind
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.kind = .reveal
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCSuccessfulManagerOperationResult.TransactionToTxRollup

extension RPCSuccessfulManagerOperationResult {
    
    public struct TransactionToTxRollup: Hashable, Codable {
        private let kind: Kind
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.kind = .reveal
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCSuccessfulManagerOperationResult.Origination

extension RPCSuccessfulManagerOperationResult {
    
    public struct Origination: Hashable, Codable {
        private let kind: Kind
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.kind = .reveal
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCSuccessfulManagerOperationResult.Delegation

extension RPCSuccessfulManagerOperationResult {
    
    public struct Delegation: Hashable, Codable {
        private let kind: Kind
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.kind = .reveal
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCSuccessfulManagerOperationResult.SetDepositsLimit

extension RPCSuccessfulManagerOperationResult {
    
    public struct SetDepositsLimit: Hashable, Codable {
        private let kind: Kind
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.kind = .reveal
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCSuccessfulManagerOperationResult.ScRollupOriginate

extension RPCSuccessfulManagerOperationResult {
    
    public struct ScRollupOriginate: Hashable, Codable {
        private let kind: Kind
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.kind = .reveal
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}
