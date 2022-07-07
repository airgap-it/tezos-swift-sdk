//
//  OperationContent.swift
//  
//
//  Created by Julia Samol on 04.07.22.
//

import Foundation
import TezosCore
import TezosMichelson

extension TezosOperation {
    
    public enum Content: Hashable {
        public typealias `Protocol` = OperationContentProtocol
        public typealias Consensus = OperationConsensusContentProtocol
        public typealias Manager = OperationManagerContentProtocol
        
        case seedNonceRevelation(SeedNonceRevelation)
        case doubleEndorsementEvidence(DoubleEndorsementEvidence)
        case doubleBakingEvidence(DoubleBakingEvidence)
        case activateAccount(ActivateAccount)
        case proposals(Proposals)
        case ballot(Ballot)
        case doublePreendorsementEvidence(DoublePreendorsementEvidence)
        case failingNoop(FailingNoop)
        case preendorsement(Preendorsement)
        case endorsement(Endorsement)
        case reveal(Reveal)
        case transaction(Transaction)
        case origination(Origination)
        case delegation(Delegation)
        case registerGlobalConstant(RegisterGlobalConstant)
        case setDepositsLimit(SetDepositsLimit)
        
        enum Kind: CaseIterable, RawRepresentable {
            typealias RawValue = (ForgeableConsuming & `Protocol`).Type
            
            case seedNonceRevelation
            case doubleEndorsementEvidence
            case doubleBakingEvidence
            case activateAccount
            case proposals
            case ballot
            case doublePreendorsementEvidence
            case failingNoop
            case preendorsement
            case endorsement
            case reveal
            case transaction
            case origination
            case delegation
            case registerGlobalConstant
            case setDepositsLimit
            
            init?(rawValue: RawValue) {
                switch rawValue {
                case is SeedNonceRevelation.Type:
                    self = .seedNonceRevelation
                case is DoubleEndorsementEvidence.Type:
                    self = .doubleEndorsementEvidence
                case is DoubleBakingEvidence.Type:
                    self = .doubleBakingEvidence
                case is ActivateAccount.Type:
                    self = .activateAccount
                case is Proposals.Type:
                    self = .proposals
                case is Ballot.Type:
                    self = .ballot
                case is DoublePreendorsementEvidence.Type:
                    self = .doublePreendorsementEvidence
                case is FailingNoop.Type:
                    self = .failingNoop
                case is Preendorsement.Type:
                    self = .preendorsement
                case is Endorsement.Type:
                    self = .endorsement
                case is Reveal.Type:
                    self = .reveal
                case is Transaction.Type:
                    self = .transaction
                case is Origination.Type:
                    self = .origination
                case is Delegation.Type:
                    self = .delegation
                case is RegisterGlobalConstant.Type:
                    self = .registerGlobalConstant
                case is SetDepositsLimit.Type:
                    self = .setDepositsLimit
                default:
                    return nil
                }
            }
            
            var rawValue: RawValue {
                switch self {
                case .seedNonceRevelation:
                    return SeedNonceRevelation.self
                case .doubleEndorsementEvidence:
                    return DoubleEndorsementEvidence.self
                case .doubleBakingEvidence:
                    return DoubleBakingEvidence.self
                case .activateAccount:
                    return ActivateAccount.self
                case .proposals:
                    return Proposals.self
                case .ballot:
                    return Ballot.self
                case .doublePreendorsementEvidence:
                    return DoublePreendorsementEvidence.self
                case .failingNoop:
                    return FailingNoop.self
                case .preendorsement:
                    return Preendorsement.self
                case .endorsement:
                    return Endorsement.self
                case .reveal:
                    return Reveal.self
                case .transaction:
                    return Transaction.self
                case .origination:
                    return Origination.self
                case .delegation:
                    return Delegation.self
                case .registerGlobalConstant:
                    return RegisterGlobalConstant.self
                case .setDepositsLimit:
                    return SetDepositsLimit.self
                }
            }
        }
        
        // MARK: SeedNonceRevelation
        
        public struct SeedNonceRevelation: `Protocol`, Hashable {
            public static let tag: [UInt8] = [1]
            
            public let level: Int32
            public let nonce: HexString
            
            public init(level: Int32, nonce: HexString) {
                self.level = level
                self.nonce = nonce
            }
            
            public func asContent() -> TezosOperation.Content {
                .seedNonceRevelation(self)
            }
        }
        
        // MARK: DoubleEndorsementEvidence
        
        public struct DoubleEndorsementEvidence: `Protocol`, Hashable {
            public static let tag: [UInt8] = [2]
            
            public let op1: InlinedEndorsement
            public let op2: InlinedEndorsement
            
            public init(op1: InlinedEndorsement, op2: InlinedEndorsement) {
                self.op1 = op1
                self.op2 = op2
            }
            
            public func asContent() -> TezosOperation.Content {
                .doubleEndorsementEvidence(self)
            }
        }
        
        // MARK: DoubleBakingEvidence
        
        public struct DoubleBakingEvidence: `Protocol`, Hashable {
            public static let tag: [UInt8] = [3]
            
            public let bh1: BlockHeader
            public let bh2: BlockHeader
            
            public init(bh1: BlockHeader, bh2: BlockHeader) {
                self.bh1 = bh1
                self.bh2 = bh2
            }
            
            public func asContent() -> TezosOperation.Content {
                .doubleBakingEvidence(self)
            }
        }
        
        // MARK: ActivateAccount
        
        public struct ActivateAccount: `Protocol`, Hashable {
            public static let tag: [UInt8] = [4]
            
            public let pkh: Ed25519PublicKeyHash
            public let secret: HexString
            
            public init(pkh: Ed25519PublicKeyHash, secret: HexString) {
                self.pkh = pkh
                self.secret = secret
            }
            
            public func asContent() -> TezosOperation.Content {
                .activateAccount(self)
            }
        }
        
        // MARK: Proposals
        
        public struct Proposals: `Protocol`, Hashable {
            public static let tag: [UInt8] = [5]
            
            public let source: Address.Implicit
            public let period: Int32
            public let proposals: [ProtocolHash]
            
            public init(source: Address.Implicit, period: Int32, proposals: [ProtocolHash]) {
                self.source = source
                self.period = period
                self.proposals = proposals
            }
            
            public func asContent() -> TezosOperation.Content {
                .proposals(self)
            }
        }
        
        // MARK: Ballot
        
        public struct Ballot: `Protocol`, Hashable {
            public static let tag: [UInt8] = [6]
            
            public let source: Address.Implicit
            public let period: Int32
            public let proposal: ProtocolHash
            public let ballot: Kind
            
            public init(source: Address.Implicit, period: Int32, proposal: ProtocolHash, ballot: Kind) {
                self.source = source
                self.period = period
                self.proposal = proposal
                self.ballot = ballot
            }
            
            public enum Kind: BytesTag {
                case yay
                case nay
                case pass
                
                public var value: [UInt8] {
                    switch self {
                    case .yay:
                        return [0]
                    case .nay:
                        return [1]
                    case .pass:
                        return [2]
                    }
                }
            }
            
            public func asContent() -> TezosOperation.Content {
                .ballot(self)
            }
        }
                    
        // MARK: DoublePreendorsementEvidence
        
        public struct DoublePreendorsementEvidence: `Protocol`, Hashable {
            public static let tag: [UInt8] = [7]
            
            public let op1: InlinedPreendorsement
            public let op2: InlinedPreendorsement
            
            public init(op1: InlinedPreendorsement, op2: InlinedPreendorsement) {
                self.op1 = op1
                self.op2 = op2
            }
            
            public func asContent() -> TezosOperation.Content {
                .doublePreendorsementEvidence(self)
            }
        }
        
        // MARK: FailingNoop
        
        public struct FailingNoop: `Protocol`, Hashable {
            public static let tag: [UInt8] = [17]
            
            public let arbitrary: HexString
            
            public init(arbitrary: HexString) {
                self.arbitrary = arbitrary
            }
            
            public func asContent() -> TezosOperation.Content {
                .failingNoop(self)
            }
        }
        
        // MARK: Preendorsement
        
        public struct Preendorsement: `Protocol`, Consensus, Hashable {
            public static let tag: [UInt8] = [20]
            
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
                self.slot = slot
                self.level = level
                self.round = round
                self.blockPayloadHash = blockPayloadHash
            }
            
            public func asContent() -> TezosOperation.Content {
                .preendorsement(self)
            }
        }
                    
        // MARK: Endorsement
        
        public struct Endorsement: `Protocol`, Consensus, Hashable {
            public static let tag: [UInt8] = [21]
            
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
                self.slot = slot
                self.level = level
                self.round = round
                self.blockPayloadHash = blockPayloadHash
            }
            
            public func asContent() -> TezosOperation.Content {
                .endorsement(self)
            }
        }
        
        // MARK: Reveal
        
        public struct Reveal: `Protocol`, Manager, Hashable {
            public static let tag: [UInt8] = [107]
            
            public let source: Address.Implicit
            public let fee: Mutez
            public let counter: TezosNat
            public let gasLimit: TezosNat
            public let storageLimit: TezosNat
            public let publicKey: Key.Public
            
            public init(
                source: Address.Implicit,
                fee: Mutez = try! .init(0),
                counter: TezosNat,
                gasLimit: TezosNat = .init(0),
                storageLimit: TezosNat = .init(0),
                publicKey: Key.Public
            ) {
                self.source = source
                self.fee = fee
                self.counter = counter
                self.gasLimit = gasLimit
                self.storageLimit = storageLimit
                self.publicKey = publicKey
            }
            
            public func asContent() -> TezosOperation.Content {
                .reveal(self)
            }
        }
        
        // MARK: Transaction
        
        public struct Transaction: `Protocol`, Manager, Hashable {
            public static let tag: [UInt8] = [108]
            
            public let source: Address.Implicit
            public let fee: Mutez
            public let counter: TezosNat
            public let gasLimit: TezosNat
            public let storageLimit: TezosNat
            public let amount: Mutez
            public let destination: Address
            public let parameters: Parameters?
            
            public init(
                source: Address.Implicit,
                fee: Mutez = try! .init(0),
                counter: TezosNat,
                gasLimit: TezosNat = .init(0),
                storageLimit: TezosNat = .init(0),
                amount: Mutez,
                destination: Address,
                parameters: Parameters? = nil
            ) {
                self.source = source
                self.fee = fee
                self.counter = counter
                self.gasLimit = gasLimit
                self.storageLimit = storageLimit
                self.amount = amount
                self.destination = destination
                self.parameters = parameters
            }
            
            public func asContent() -> TezosOperation.Content {
                .transaction(self)
            }
        }
        
        // MARK: Origination
        
        public struct Origination: `Protocol`, Manager, Hashable {
            public static let tag: [UInt8] = [109]
            
            public let source: Address.Implicit
            public let fee: Mutez
            public let counter: TezosNat
            public let gasLimit: TezosNat
            public let storageLimit: TezosNat
            public let balance: Mutez
            public let delegate: Address.Implicit?
            public let script: Script
            
            public init(
                source: Address.Implicit,
                fee: Mutez = try! .init(0),
                counter: TezosNat,
                gasLimit: TezosNat = .init(0),
                storageLimit: TezosNat = .init(0),
                balance: Mutez,
                delegate: Address.Implicit?,
                script: Script
            ) {
                self.source = source
                self.fee = fee
                self.counter = counter
                self.gasLimit = gasLimit
                self.storageLimit = storageLimit
                self.balance = balance
                self.delegate = delegate
                self.script = script
            }
            
            public func asContent() -> TezosOperation.Content {
                .origination(self)
            }
        }
        
        // MARK: Delegation
        
        public struct Delegation: `Protocol`, Manager, Hashable {
            public static let tag: [UInt8] = [110]
            
            public let source: Address.Implicit
            public let fee: Mutez
            public let counter: TezosNat
            public let gasLimit: TezosNat
            public let storageLimit: TezosNat
            public let delegate: Address.Implicit?
            
            public init(
                source: Address.Implicit,
                fee: Mutez = try! .init(0),
                counter: TezosNat,
                gasLimit: TezosNat = .init(0),
                storageLimit: TezosNat = .init(0),
                delegate: Address.Implicit? = nil
            ) {
                self.source = source
                self.fee = fee
                self.counter = counter
                self.gasLimit = gasLimit
                self.storageLimit = storageLimit
                self.delegate = delegate
            }
            
            public func asContent() -> TezosOperation.Content {
                .delegation(self)
            }
        }
        
        // MARK: RegisterGlobalConstant
        
        public struct RegisterGlobalConstant: `Protocol`, Manager, Hashable {
            public static let tag: [UInt8] = [111]
            
            public let source: Address.Implicit
            public let fee: Mutez
            public let counter: TezosNat
            public let gasLimit: TezosNat
            public let storageLimit: TezosNat
            public let value: Micheline
            
            public init(
                source: Address.Implicit,
                fee: Mutez = try! .init(0),
                counter: TezosNat,
                gasLimit: TezosNat = .init(0),
                storageLimit: TezosNat = .init(0),
                value: Micheline
            ) {
                self.source = source
                self.fee = fee
                self.counter = counter
                self.gasLimit = gasLimit
                self.storageLimit = storageLimit
                self.value = value
            }
            
            public func asContent() -> TezosOperation.Content {
                .registerGlobalConstant(self)
            }
        }
                    
        // MARK: SetDepositsLimit
        
        public struct SetDepositsLimit: `Protocol`, Manager, Hashable {
            public static let tag: [UInt8] = [112]
            
            public let source: Address.Implicit
            public let fee: Mutez
            public let counter: TezosNat
            public let gasLimit: TezosNat
            public let storageLimit: TezosNat
            public let limit: Mutez?
            
            public init(
                source: Address.Implicit,
                fee: Mutez = try! .init(0),
                counter: TezosNat,
                gasLimit: TezosNat = .init(0),
                storageLimit: TezosNat = .init(0),
                limit: Mutez? = nil
            ) {
                self.source = source
                self.fee = fee
                self.counter = counter
                self.gasLimit = gasLimit
                self.storageLimit = storageLimit
                self.limit = limit
            }
            
            public func asContent() -> TezosOperation.Content {
                .setDepositsLimit(self)
            }
        }
    }
}

// MARK: Protocol

public protocol OperationContentProtocol {
    static var tag: [UInt8] { get }
    
    func asContent() -> TezosOperation.Content
}

public protocol OperationConsensusContentProtocol {
    var slot: UInt16 { get }
    var level: Int32 { get }
    var round: Int32 { get }
    var blockPayloadHash: BlockPayloadHash { get }
}

public protocol OperationManagerContentProtocol {
    var source: Address.Implicit { get }
    var fee: Mutez { get }
    var counter: TezosNat { get }
    var gasLimit: TezosNat { get }
    var storageLimit: TezosNat { get }
}
