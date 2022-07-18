//
//  OperationContent.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation
import TezosCore
import TezosMichelson
import TezosOperation

// MARK: RPCOperation.Content

extension RPCOperation {
    
    public enum Content: Hashable, Codable {
        case endorsement(Endorsement)
        case preendorsement(Preendorsement)
        case seedNonceRevelation(SeedNonceRevelation)
        case doubleEndorsementEvidence(DoubleEndorsementEvidence)
        case doublePreendorsementEvidence(DoublePreendorsementEvidence)
        case doubleBakingEvidence(DoubleBakingEvidence)
        case activateAccount(ActivateAccount)
        case proposals(Proposals)
        case ballot(Ballot)
        case reveal(Reveal)
        case transaction(Transaction)
        case origination(Origination)
        case delegation(Delegation)
        case setDepositsLimit(SetDepositsLimit)
        case failingNoop(FailingNoop)
        case registerGlobalConstant(RegisterGlobalConstant)
        
        private enum Kind: String, Codable {
            case endorsement
            case preendorsement
            case seedNonceRevelation = "seed_nonce_revelation"
            case doubleEndorsementEvidence = "double_endorsement_evidence"
            case doublePreendorsementEvidence = "double_preendorsement_evidence"
            case doubleBakingEvidence = "double_baking_evidence"
            case activateAccount = "activate_account"
            case proposals
            case ballot
            case reveal
            case transaction
            case origination
            case delegation
            case setDepositsLimit = "set_deposits_limit"
            case failingNoop = "failing_noop"
            case registerGlobalConstant = "register_global_constant"
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let kind = try container.decode(Kind.self, forKey: .kind)
            switch kind {
            case .endorsement:
                self = .endorsement(try .init(from: decoder))
            case .preendorsement:
                self = .preendorsement(try .init(from: decoder))
            case .seedNonceRevelation:
                self = .seedNonceRevelation(try .init(from: decoder))
            case .doubleEndorsementEvidence:
                self = .doubleEndorsementEvidence(try .init(from: decoder))
            case .doublePreendorsementEvidence:
                self = .doublePreendorsementEvidence(try .init(from: decoder))
            case .doubleBakingEvidence:
                self = .doubleBakingEvidence(try .init(from: decoder))
            case .activateAccount:
                self = .activateAccount(try .init(from: decoder))
            case .proposals:
                self = .proposals(try .init(from: decoder))
            case .ballot:
                self = .ballot(try .init(from: decoder))
            case .reveal:
                self = .reveal(try .init(from: decoder))
            case .transaction:
                self = .transaction(try .init(from: decoder))
            case .origination:
                self = .origination(try .init(from: decoder))
            case .delegation:
                self = .delegation(try .init(from: decoder))
            case .setDepositsLimit:
                self = .setDepositsLimit(try .init(from: decoder))
            case .failingNoop:
                self = .failingNoop(try .init(from: decoder))
            case .registerGlobalConstant:
                self = .registerGlobalConstant(try .init(from: decoder))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .endorsement(let endorsement):
                try endorsement.encode(to: encoder)
            case .preendorsement(let preendorsement):
                try preendorsement.encode(to: encoder)
            case .seedNonceRevelation(let seedNonceRevelation):
                try seedNonceRevelation.encode(to: encoder)
            case .doubleEndorsementEvidence(let doubleEndorsementEvidence):
                try doubleEndorsementEvidence.encode(to: encoder)
            case .doublePreendorsementEvidence(let doublePreendorsementEvidence):
                try doublePreendorsementEvidence.encode(to: encoder)
            case .doubleBakingEvidence(let doubleBakingEvidence):
                try doubleBakingEvidence.encode(to: encoder)
            case .activateAccount(let activateAccount):
                try activateAccount.encode(to: encoder)
            case .proposals(let proposals):
                try proposals.encode(to: encoder)
            case .ballot(let ballot):
                try ballot.encode(to: encoder)
            case .reveal(let reveal):
                try reveal.encode(to: encoder)
            case .transaction(let transaction):
                try transaction.encode(to: encoder)
            case .origination(let origination):
                try origination.encode(to: encoder)
            case .delegation(let delegation):
                try delegation.encode(to: encoder)
            case .setDepositsLimit(let setDepositsLimit):
                try setDepositsLimit.encode(to: encoder)
            case .failingNoop(let failingNoop):
                try failingNoop.encode(to: encoder)
            case .registerGlobalConstant(let registerGlobalConstant):
                try registerGlobalConstant.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
        }
    }
}

// MARK: RPCOperation.Content.Endorsement

extension RPCOperation.Content {
    
    public struct Endorsement: Hashable, Codable {
        private let kind: Kind
        public let slot: UInt16
        public let level: Int32
        public let round: Int32
        public let blockPayloadHash: BlockPayloadHash
        
        public init(
            slot: UInt16,
            level: Int32,
            round: Int32,
            blockPayloadHash: BlockPayloadHash
        ) {
            self.kind = .endorsement
            self.slot = slot
            self.level = level
            self.round = round
            self.blockPayloadHash = blockPayloadHash
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case slot
            case level
            case round
            case blockPayloadHash = "block_payload_hash"
        }
    }
}

// MARK: RPCOperation.Content.Preendorsement

extension RPCOperation.Content {
    
    public struct Preendorsement: Hashable, Codable {
        private let kind: Kind
        public let slot: UInt16
        public let level: Int32
        public let round: Int32
        public let blockPayloadHash: BlockPayloadHash
        
        public init(
            slot: UInt16,
            level: Int32,
            round: Int32,
            blockPayloadHash: BlockPayloadHash
        ) {
            self.kind = .preendorsement
            self.slot = slot
            self.level = level
            self.round = round
            self.blockPayloadHash = blockPayloadHash
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case slot
            case level
            case round
            case blockPayloadHash = "block_payload_hash"
        }
    }
}

// MARK: RPCOperation.Content.SeedNonceRevelation

extension RPCOperation.Content {
    
    public struct SeedNonceRevelation: Hashable, Codable {
        private let kind: Kind
        public let level: Int32
        public let nonce: String
        
        public init(level: Int32, nonce: String) {
            self.kind = .seedNonceRevelation
            self.level = level
            self.nonce = nonce
        }
    }
}

// MARK: RPCOperation.Content.DoubleEndorsementEvidence

extension RPCOperation.Content {
    
    public struct DoubleEndorsementEvidence: Hashable, Codable {
        private let kind: Kind
        public let op1: InlinedEndorsement
        public let op2: InlinedEndorsement
        
        public init(op1: InlinedEndorsement, op2: InlinedEndorsement) {
            self.kind = .doubleEndorsementEvidence
            self.op1 = op1
            self.op2 = op2
        }
    }
    
    public struct InlinedEndorsement: Hashable, Codable {
        public let branch: BlockHash
        public let operations: Endorsement
        public let signature: Signature
        
        public init(branch: BlockHash, operations: Endorsement, signature: Signature) {
            self.branch = branch
            self.operations = operations
            self.signature = signature
        }
    }
}

// MARK: RPCOperation.Content.DoublePreendorsementEvidence

extension RPCOperation.Content {
    
    public struct DoublePreendorsementEvidence: Hashable, Codable {
        private let kind: Kind
        public let op1: InlinedPreendorsement
        public let op2: InlinedPreendorsement
        
        public init(op1: InlinedPreendorsement, op2: InlinedPreendorsement) {
            self.kind = .doublePreendorsementEvidence
            self.op1 = op1
            self.op2 = op2
        }
    }
    
    public struct InlinedPreendorsement: Hashable, Codable {
        public let branch: BlockHash
        public let operations: Preendorsement
        public let signature: Signature
        
        public init(branch: BlockHash, operations: Preendorsement, signature: Signature) {
            self.branch = branch
            self.operations = operations
            self.signature = signature
        }
    }
}

// MARK: RPCOperation.Content.DoubleBakingEvidence

extension RPCOperation.Content {
    
    public struct DoubleBakingEvidence: Hashable, Codable {
        private let kind: Kind
        public let bh1: RPCBlockHeader
        public let bh2: RPCBlockHeader
        
        public init(bh1: RPCBlockHeader, bh2: RPCBlockHeader) {
            self.kind = .doubleBakingEvidence
            self.bh1 = bh1
            self.bh2 = bh2
        }
    }
}

// MARK: RPCOperation.Content.ActivateAccount

extension RPCOperation.Content {
    
    public struct ActivateAccount: Hashable, Codable {
        private let kind: Kind
        public let pkh: Ed25519PublicKeyHash
        public let secret: String
        
        public init(pkh: Ed25519PublicKeyHash, secret: String) {
            self.kind = .activateAccount
            self.pkh = pkh
            self.secret = secret
        }
    }
}

// MARK: RPCOperation.Content.Proposals

extension RPCOperation.Content {
    
    public struct Proposals: Hashable, Codable {
        private let kind: Kind
        public let source: Address.Implicit
        public let period: Int32
        public let proposals: [ProtocolHash]
        
        public init(source: Address.Implicit, period: Int32, proposals: [ProtocolHash]) {
            self.kind = .proposals
            self.source = source
            self.period = period
            self.proposals = proposals
        }
    }
}

// MARK: RPCOperation.Content.Ballot

extension RPCOperation.Content {
    
    public struct Ballot: Hashable, Codable {
        private let kind: RPCOperation.Content.Kind
        public let source: Address.Implicit
        public let period: Int32
        public let proposal: ProtocolHash
        public let ballot: Kind
        
        public init(source: Address.Implicit, period: Int32, proposal: ProtocolHash, ballot: Kind) {
            self.kind = .ballot
            self.source = source
            self.period = period
            self.proposal = proposal
            self.ballot = ballot
        }
        
        public enum Kind: String, Codable {
            case nay
            case yay
            case pass
        }
    }
}

// MARK: RPCOperation.Content.Reveal

extension RPCOperation.Content {
    
    public struct Reveal: Hashable, Codable {
        private let kind: Kind
        public let source: Address.Implicit
        public let fee: Mutez
        public let counter: String
        public let gasLimit: String
        public let storageLimit: String
        public let publicKey: Key.Public
        
        public init(
            source: Address.Implicit,
            fee: Mutez,
            counter: String,
            gasLimit: String,
            storageLimit: String,
            publicKey: Key.Public
        ) {
            self.kind = .reveal
            self.source = source
            self.fee = fee
            self.counter = counter
            self.gasLimit = gasLimit
            self.storageLimit = storageLimit
            self.publicKey = publicKey
        }
    }
}

// MARK: RPCOperation.Content.Transaction

extension RPCOperation.Content {
    
    public struct Transaction: Hashable, Codable {
        private let kind: Kind
        public let source: Address.Implicit
        public let fee: Mutez
        public let counter: String
        public let gasLimit: String
        public let storageLimit: String
        public let amount: Mutez
        public let destination: Address
        public let parameters: Parameters?
        
        public init(
            source: Address.Implicit,
            fee: Mutez,
            counter: String,
            gasLimit: String,
            storageLimit: String,
            amount: Mutez,
            destination: Address,
            parameters: Parameters? = nil
        ) {
            self.kind = .transaction
            self.source = source
            self.fee = fee
            self.counter = counter
            self.gasLimit = gasLimit
            self.storageLimit = storageLimit
            self.amount = amount
            self.destination = destination
            self.parameters = parameters
        }
    }
}

// MARK: RPCOperation.Content.Origination

extension RPCOperation.Content {
    
    public struct Origination: Hashable, Codable {
        private let kind: Kind
        public let source: Address.Implicit
        public let fee: Mutez
        public let counter: String
        public let gasLimit: String
        public let storageLimit: String
        public let balance: Mutez
        public let delegate: Address.Implicit?
        public let script: Script
        
        public init(
            source: Address.Implicit,
            fee: Mutez,
            counter: String,
            gasLimit: String,
            storageLimit: String,
            balance: Mutez,
            delegate: Address.Implicit?,
            script: Script
        ) {
            self.kind = .origination
            self.source = source
            self.fee = fee
            self.counter = counter
            self.gasLimit = gasLimit
            self.storageLimit = storageLimit
            self.balance = balance
            self.delegate = delegate
            self.script = script
        }
    }
}

// MARK: RPCOperation.Content.Delegation

extension RPCOperation.Content {
    
    public struct Delegation: Hashable, Codable {
        private let kind: Kind
        public let source: Address.Implicit
        public let fee: Mutez
        public let counter: String
        public let gasLimit: String
        public let storageLimit: String
        public let delegate: Address.Implicit?
        
        public init(
            source: Address.Implicit,
            fee: Mutez,
            counter: String,
            gasLimit: String,
            storageLimit: String,
            delegate: Address.Implicit? = nil
        ) {
            self.kind = .delegation
            self.source = source
            self.fee = fee
            self.counter = counter
            self.gasLimit = gasLimit
            self.storageLimit = storageLimit
            self.delegate = delegate
        }
    }
}
            
// MARK: RPCOperation.Content.SetDepositsLimit

extension RPCOperation.Content {
    
    public struct SetDepositsLimit: Hashable, Codable {
        private let kind: Kind
        public let source: Address.Implicit
        public let fee: Mutez
        public let counter: String
        public let gasLimit: String
        public let storageLimit: String
        public let limit: Mutez?
        
        public init(
            source: Address.Implicit,
            fee: Mutez,
            counter: String,
            gasLimit: String,
            storageLimit: String,
            limit: Mutez? = nil
        ) {
            self.kind = .setDepositsLimit
            self.source = source
            self.fee = fee
            self.counter = counter
            self.gasLimit = gasLimit
            self.storageLimit = storageLimit
            self.limit = limit
        }
    }
}

// MARK: RPCOperation.Content.FailingNoop

extension RPCOperation.Content {
    
    public struct FailingNoop: Hashable, Codable {
        private let kind: Kind
        public let arbitrary: String
        
        public init(arbitrary: String) {
            self.kind = .failingNoop
            self.arbitrary = arbitrary
        }
    }
}

// MARK: RPCOperation.Content.RegisterGlobalConstant

extension RPCOperation.Content {
    
    public struct RegisterGlobalConstant: Hashable, Codable {
        private let kind: Kind
        public let source: Address.Implicit
        public let fee: Mutez
        public let counter: String
        public let gasLimit: String
        public let storageLimit: String
        public let value: Micheline
        
        public init(
            source: Address.Implicit,
            fee: Mutez,
            counter: String,
            gasLimit: String,
            storageLimit: String,
            value: Micheline
        ) {
            self.kind = .registerGlobalConstant
            self.source = source
            self.fee = fee
            self.counter = counter
            self.gasLimit = gasLimit
            self.storageLimit = storageLimit
            self.value = value
        }
    }
}
