//
//  OperationMetadata.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import TezosCore

// MARK: RPCOperationMetadata

public enum RPCOperationMetadata: String, Codable {
    case tooLarge = "too large"
}

// MARK: RPCOperationMetadata.Endorsement

extension RPCOperationMetadata {
    
    public struct Endorsement: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let delegate: KeyHash.Public
        public let endorsementPower: Int32
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, delegate: KeyHash.Public, endorsementPower: Int32) {
            self.balanceUpdates = balanceUpdates
            self.delegate = delegate
            self.endorsementPower = endorsementPower
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case delegate
            case endorsementPower = "endorsement_power"
        }
    }
}

// MARK: RPCOperationMetadata.Preendorsement

extension RPCOperationMetadata {
    
    public struct Preendorsement: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let delegate: KeyHash.Public
        public let preendorsementPower: Int32
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, delegate: KeyHash.Public, preendorsementPower: Int32) {
            self.balanceUpdates = balanceUpdates
            self.delegate = delegate
            self.preendorsementPower = preendorsementPower
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case delegate
            case preendorsementPower = "preendorsement_power"
        }
    }
}

// MARK: RPCOperationMetadata.SeedNonceRevelation

extension RPCOperationMetadata {
    
    public struct SeedNonceRevelation: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil) {
            self.balanceUpdates = balanceUpdates
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
        }
    }
}

// MARK: RPCOperationMetadata.DoubleEndorsementEvidence

extension RPCOperationMetadata {
    
    public struct DoubleEndorsementEvidence: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil) {
            self.balanceUpdates = balanceUpdates
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
        }
    }
}

// MARK: RPCOperationMetadata.DoublePreendorsementEvidence

extension RPCOperationMetadata {
    
    public struct DoublePreendorsementEvidence: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil) {
            self.balanceUpdates = balanceUpdates
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
        }
    }
}

// MARK: RPCOperationMetadata.DoubleBakingEvidence

extension RPCOperationMetadata {
    
    public struct DoubleBakingEvidence: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil) {
            self.balanceUpdates = balanceUpdates
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
        }
    }
}

// MARK: RPCOperationMetadata.ActivateAccount

extension RPCOperationMetadata {
    
    public struct ActivateAccount: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil) {
            self.balanceUpdates = balanceUpdates
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
        }
    }
}

// MARK: RPCOperationMetadata.Proposals

extension RPCOperationMetadata {
    
    public struct Proposals: Hashable, Codable {}
}

// MARK: RPCOperationMetadata.Ballot

extension RPCOperationMetadata {
    
    public struct Ballot: Hashable, Codable {}
}

// MARK: RPCOperationMetadata.Reveal

extension RPCOperationMetadata {
    
    public struct Reveal: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let operationResult: RPCOperationResult.Reveal
        public let internalOperationResults: [RPCInternalOperationResult]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, operationResult: RPCOperationResult.Reveal, internalOperationResults: [RPCInternalOperationResult]? = nil) {
            self.balanceUpdates = balanceUpdates
            self.operationResult = operationResult
            self.internalOperationResults = internalOperationResults
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case operationResult = "operation_result"
            case internalOperationResults = "internal_operation_results"
        }
    }
}

// MARK: RPCOperationMetadata.Transaction

extension RPCOperationMetadata {
    
    public struct Transaction: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let operationResult: RPCOperationResult.Transaction
        public let internalOperationResults: [RPCInternalOperationResult]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, operationResult: RPCOperationResult.Transaction, internalOperationResults: [RPCInternalOperationResult]? = nil) {
            self.balanceUpdates = balanceUpdates
            self.operationResult = operationResult
            self.internalOperationResults = internalOperationResults
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case operationResult = "operation_result"
            case internalOperationResults = "internal_operation_results"
        }
    }
}

// MARK: RPCOperationMetadata.Origination

extension RPCOperationMetadata {
    
    public struct Origination: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let operationResult: RPCOperationResult.Origination
        public let internalOperationResults: [RPCInternalOperationResult]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, operationResult: RPCOperationResult.Origination, internalOperationResults: [RPCInternalOperationResult]? = nil) {
            self.balanceUpdates = balanceUpdates
            self.operationResult = operationResult
            self.internalOperationResults = internalOperationResults
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case operationResult = "operation_result"
            case internalOperationResults = "internal_operation_results"
        }
    }
}

// MARK: RPCOperationMetadata.Delegation

extension RPCOperationMetadata {
    
    public struct Delegation: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let operationResult: RPCOperationResult.Delegation
        public let internalOperationResults: [RPCInternalOperationResult]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, operationResult: RPCOperationResult.Delegation, internalOperationResults: [RPCInternalOperationResult]? = nil) {
            self.balanceUpdates = balanceUpdates
            self.operationResult = operationResult
            self.internalOperationResults = internalOperationResults
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case operationResult = "operation_result"
            case internalOperationResults = "internal_operation_results"
        }
    }
}

// MARK: RPCOperationMetadata.SetDepositsLimit

extension RPCOperationMetadata {
    
    public struct SetDepositsLimit: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let operationResult: RPCOperationResult.SetDepositsLimit
        public let internalOperationResults: [RPCInternalOperationResult]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, operationResult: RPCOperationResult.SetDepositsLimit, internalOperationResults: [RPCInternalOperationResult]? = nil) {
            self.balanceUpdates = balanceUpdates
            self.operationResult = operationResult
            self.internalOperationResults = internalOperationResults
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case operationResult = "operation_result"
            case internalOperationResults = "internal_operation_results"
        }
    }
}

// MARK: RPCOperationMetadata.RegisterGlobalConstant

extension RPCOperationMetadata {
    
    public struct RegisterGlobalConstant: Hashable, Codable {
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let operationResult: RPCOperationResult.RegisterGlobalConstant
        public let internalOperationResults: [RPCInternalOperationResult]?
        
        public init(balanceUpdates: [RPCBalanceUpdate]? = nil, operationResult: RPCOperationResult.RegisterGlobalConstant, internalOperationResults: [RPCInternalOperationResult]? = nil) {
            self.balanceUpdates = balanceUpdates
            self.operationResult = operationResult
            self.internalOperationResults = internalOperationResults
        }
        
        enum CodingKeys: String, CodingKey {
            case balanceUpdates = "balance_updates"
            case operationResult = "operation_result"
            case internalOperationResults = "internal_operation_results"
        }
    }
}

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
