//
//  File.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import TezosCore

// MARK: RPCBalanceUpdate

public enum RPCBalanceUpdate: Hashable, Codable {
    case contract(Contract)
    case blockFees(BlockFees)
    case deposits(Deposits)
    case nonceRevelationRewards(NonceRevelationRewards)
    case doubleSigningEvidenceRewards(DoubleSigningEvidenceRewards)
    case endorsingRewards(EndorsingRewards)
    case bakingRewards(BakingRewards)
    case bakingBonuses(BakingBonuses)
    case storageFees(StorageFees)
    case doubleSigningPunishments(DoubleSigningPunishments)
    case lostEndorsingRewards(LostEndorsingRewards)
    case liquidityBakingSubsidies(LiquidityBakingSubsidies)
    case burned(Burned)
    case commitments(Commitments)
    case bootstrap(Bootstrap)
    case invoice(Invoice)
    case initialCommitments(InitialCommitments)
    case minted(Minted)
    case frozenBonds(FrozenBonds)
    case txRollupRejectionRewards(TxRollupRejectionRewards)
    case txRollupRejectionPunishments(TxRollupRejectionPunishments)
    
    public enum Origin: String, Codable {
        case block
        case migration
        case subsidy
        case simulation
    }
    
    private enum Kind: String, Codable {
        case contract
        case accumulator
        case freezer
        case minted
        case burned
        case commitment
    }
    
    private enum AccumlatorCategory: String, Codable {
        case blockFees = "block fees"
    }
    
    private enum FreezerCategory: String, Codable {
        case deposits
        case bonds
    }
    
    private enum MintedCategory: String, Codable {
        case nonceRevelationRewards = "nonce revelation rewards"
        case doubleSigningEvidenceRewards = "double signing evidence rewards"
        case endorsingRewards = "endorsing rewards"
        case bakingRewards = "baking rewards"
        case bakingBonuses = "baking bonuses"
        case subsidy
        case bootstrap
        case invoice
        case commitment
        case minted
        case txRollupRejectionRewards = "tx_rollup_rejection_rewards"
    }
    
    private enum BurnedCategory: String, Codable {
        case storageFees = "storage fees"
        case punishments
        case lostEndorsingRewards = "lost endorsing rewards"
        case burned
        case txRollupRejectionPunishments = "tx_rollup_rejection_punishments"
    }
    
    private enum CommitmentCategory: String, Codable {
        case commitment
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .contract:
            self = .contract(try .init(from: decoder))
        case .accumulator:
            let category = try container.decode(AccumlatorCategory.self, forKey: .category)
            switch category {
            case .blockFees:
                self = .blockFees(try .init(from: decoder))
            }
        case .freezer:
            let category = try container.decode(FreezerCategory.self, forKey: .category)
            switch category {
            case .deposits:
                self = .deposits(try .init(from: decoder))
            case .bonds:
                self = .frozenBonds(try .init(from: decoder))
            }
        case .minted:
            let category = try container.decode(MintedCategory.self, forKey: .category)
            switch category {
            case .nonceRevelationRewards:
                self = .nonceRevelationRewards(try .init(from: decoder))
            case .doubleSigningEvidenceRewards:
                self = .doubleSigningEvidenceRewards(try .init(from: decoder))
            case .endorsingRewards:
                self = .endorsingRewards(try .init(from: decoder))
            case .bakingRewards:
                self = .bakingRewards(try .init(from: decoder))
            case .bakingBonuses:
                self = .bakingBonuses(try .init(from: decoder))
            case .subsidy:
                self = .liquidityBakingSubsidies(try .init(from: decoder))
            case .bootstrap:
                self = .bootstrap(try .init(from: decoder))
            case .invoice:
                self = .invoice(try .init(from: decoder))
            case .commitment:
                self = .initialCommitments(try .init(from: decoder))
            case .minted:
                self = .minted(try .init(from: decoder))
            case .txRollupRejectionRewards:
                self = .txRollupRejectionRewards(try .init(from: decoder))
            }
        case .burned:
            let category = try container.decode(BurnedCategory.self, forKey: .category)
            switch category {
            case .storageFees:
                self = .storageFees(try .init(from: decoder))
            case .punishments:
                self = .doubleSigningPunishments(try .init(from: decoder))
            case .lostEndorsingRewards:
                self = .lostEndorsingRewards(try .init(from: decoder))
            case .burned:
                self = .burned(try .init(from: decoder))
            case .txRollupRejectionPunishments:
                self = .txRollupRejectionPunishments(try .init(from: decoder))
            }
        case .commitment:
            let category = try container.decode(CommitmentCategory.self, forKey: .category)
            switch category {
            case .commitment:
                self = .commitments(try .init(from: decoder))
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .contract(let contract):
            try contract.encode(to: encoder)
        case .blockFees(let blockFees):
            try blockFees.encode(to: encoder)
        case .deposits(let deposits):
            try deposits.encode(to: encoder)
        case .nonceRevelationRewards(let nonceRevelationRewards):
            try nonceRevelationRewards.encode(to: encoder)
        case .doubleSigningEvidenceRewards(let doubleSigningEvidenceRewards):
            try doubleSigningEvidenceRewards.encode(to: encoder)
        case .endorsingRewards(let endorsingRewards):
            try endorsingRewards.encode(to: encoder)
        case .bakingRewards(let bakingRewards):
            try bakingRewards.encode(to: encoder)
        case .bakingBonuses(let bakingBonuses):
            try bakingBonuses.encode(to: encoder)
        case .storageFees(let storageFees):
            try storageFees.encode(to: encoder)
        case .doubleSigningPunishments(let doubleSigningPunishments):
            try doubleSigningPunishments.encode(to: encoder)
        case .lostEndorsingRewards(let lostEndorsingRewards):
            try lostEndorsingRewards.encode(to: encoder)
        case .liquidityBakingSubsidies(let liquidityBakingSubsidies):
            try liquidityBakingSubsidies.encode(to: encoder)
        case .burned(let burned):
            try burned.encode(to: encoder)
        case .commitments(let commitments):
            try commitments.encode(to: encoder)
        case .bootstrap(let bootstrap):
            try bootstrap.encode(to: encoder)
        case .invoice(let invoice):
            try invoice.encode(to: encoder)
        case .initialCommitments(let initialCommitments):
            try initialCommitments.encode(to: encoder)
        case .minted(let minted):
            try minted.encode(to: encoder)
        case .frozenBonds(let frozenBonds):
            try frozenBonds.encode(to: encoder)
        case .txRollupRejectionRewards(let txRollupRejectionRewards):
            try txRollupRejectionRewards.encode(to: encoder)
        case .txRollupRejectionPunishments(let txRollupRejectionPunishments):
            try txRollupRejectionPunishments.encode(to: encoder)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case kind
        case category
    }
}

extension RPCBalanceUpdate {
    public var change: String {
        switch self {
        case .contract(let contract):
            return contract.change
        case .blockFees(let blockFees):
            return blockFees.change
        case .deposits(let deposits):
            return deposits.change
        case .nonceRevelationRewards(let nonceRevelationRewards):
            return nonceRevelationRewards.change
        case .doubleSigningEvidenceRewards(let doubleSigningEvidenceRewards):
            return doubleSigningEvidenceRewards.change
        case .endorsingRewards(let endorsingRewards):
            return endorsingRewards.change
        case .bakingRewards(let bakingRewards):
            return bakingRewards.change
        case .bakingBonuses(let bakingBonuses):
            return bakingBonuses.change
        case .storageFees(let storageFees):
            return storageFees.change
        case .doubleSigningPunishments(let doubleSigningPunishments):
            return doubleSigningPunishments.change
        case .lostEndorsingRewards(let lostEndorsingRewards):
            return lostEndorsingRewards.change
        case .liquidityBakingSubsidies(let liquidityBakingSubsidies):
            return liquidityBakingSubsidies.change
        case .burned(let burned):
            return burned.change
        case .commitments(let commitments):
            return commitments.change
        case .bootstrap(let bootstrap):
            return bootstrap.change
        case .invoice(let invoice):
            return invoice.change
        case .initialCommitments(let initialCommitments):
            return initialCommitments.change
        case .minted(let minted):
            return minted.change
        case .frozenBonds(let frozenBonds):
            return frozenBonds.change
        case .txRollupRejectionRewards(let txRollupRejectionRewards):
            return txRollupRejectionRewards.change
        case .txRollupRejectionPunishments(let txRollupRejectionPunishments):
            return txRollupRejectionPunishments.change
        }
    }
    
    public var origin: Origin {
        switch self {
        case .contract(let contract):
            return contract.origin
        case .blockFees(let blockFees):
            return blockFees.origin
        case .deposits(let deposits):
            return deposits.origin
        case .nonceRevelationRewards(let nonceRevelationRewards):
            return nonceRevelationRewards.origin
        case .doubleSigningEvidenceRewards(let doubleSigningEvidenceRewards):
            return doubleSigningEvidenceRewards.origin
        case .endorsingRewards(let endorsingRewards):
            return endorsingRewards.origin
        case .bakingRewards(let bakingRewards):
            return bakingRewards.origin
        case .bakingBonuses(let bakingBonuses):
            return bakingBonuses.origin
        case .storageFees(let storageFees):
            return storageFees.origin
        case .doubleSigningPunishments(let doubleSigningPunishments):
            return doubleSigningPunishments.origin
        case .lostEndorsingRewards(let lostEndorsingRewards):
            return lostEndorsingRewards.origin
        case .liquidityBakingSubsidies(let liquidityBakingSubsidies):
            return liquidityBakingSubsidies.origin
        case .burned(let burned):
            return burned.origin
        case .commitments(let commitments):
            return commitments.origin
        case .bootstrap(let bootstrap):
            return bootstrap.origin
        case .invoice(let invoice):
            return invoice.origin
        case .initialCommitments(let initialCommitments):
            return initialCommitments.origin
        case .minted(let minted):
            return minted.origin
        case .frozenBonds(let frozenBonds):
            return frozenBonds.origin
        case .txRollupRejectionRewards(let txRollupRejectionRewards):
            return txRollupRejectionRewards.origin
        case .txRollupRejectionPunishments(let txRollupRejectionPunishments):
            return txRollupRejectionPunishments.origin
        }
    }
    
    public var contract: Address? {
        switch self {
        case .contract(let contract):
            return contract.contract
        case .blockFees(_):
            return nil
        case .deposits(_):
            return nil
        case .nonceRevelationRewards(_):
            return nil
        case .doubleSigningEvidenceRewards(_):
            return nil
        case .endorsingRewards(_):
            return nil
        case .bakingRewards(_):
            return nil
        case .bakingBonuses(_):
            return nil
        case .storageFees(_):
            return nil
        case .doubleSigningPunishments(_):
            return nil
        case .lostEndorsingRewards(_):
            return nil
        case .liquidityBakingSubsidies(_):
            return nil
        case .burned(_):
            return nil
        case .commitments(_):
            return nil
        case .bootstrap(_):
            return nil
        case .invoice(_):
            return nil
        case .initialCommitments(_):
            return nil
        case .minted(_):
            return nil
        case .frozenBonds(let frozenBonds):
            return frozenBonds.contract
        case .txRollupRejectionRewards(_):
            return nil
        case .txRollupRejectionPunishments(_):
            return nil
        }
    }
    
    public var delegate: KeyHash.Public? {
        switch self {
        case .contract(_):
            return nil
        case .blockFees(_):
            return nil
        case .deposits(let deposits):
            return deposits.delegate
        case .nonceRevelationRewards(_):
            return nil
        case .doubleSigningEvidenceRewards(_):
            return nil
        case .endorsingRewards(_):
            return nil
        case .bakingRewards(_):
            return nil
        case .bakingBonuses(_):
            return nil
        case .storageFees(_):
            return nil
        case .doubleSigningPunishments(_):
            return nil
        case .lostEndorsingRewards(let lostEndorsingRewards):
            return lostEndorsingRewards.delegate
        case .liquidityBakingSubsidies(_):
            return nil
        case .burned(_):
            return nil
        case .commitments(_):
            return nil
        case .bootstrap(_):
            return nil
        case .invoice(_):
            return nil
        case .initialCommitments(_):
            return nil
        case .minted(_):
            return nil
        case .frozenBonds(_):
            return nil
        case .txRollupRejectionRewards(_):
            return nil
        case .txRollupRejectionPunishments(_):
            return nil
        }
    }
    
    public var participation: Bool? {
        switch self {
        case .contract(_):
            return nil
        case .blockFees(_):
            return nil
        case .deposits(_):
            return nil
        case .nonceRevelationRewards(_):
            return nil
        case .doubleSigningEvidenceRewards(_):
            return nil
        case .endorsingRewards(_):
            return nil
        case .bakingRewards(_):
            return nil
        case .bakingBonuses(_):
            return nil
        case .storageFees(_):
            return nil
        case .doubleSigningPunishments(_):
            return nil
        case .lostEndorsingRewards(let lostEndorsingRewards):
            return lostEndorsingRewards.participation
        case .liquidityBakingSubsidies(_):
            return nil
        case .burned(_):
            return nil
        case .commitments(_):
            return nil
        case .bootstrap(_):
            return nil
        case .invoice(_):
            return nil
        case .initialCommitments(_):
            return nil
        case .minted(_):
            return nil
        case .frozenBonds(_):
            return nil
        case .txRollupRejectionRewards(_):
            return nil
        case .txRollupRejectionPunishments(_):
            return nil
        }
    }
    
    public var revelation: Bool? {
        switch self {
        case .contract(_):
            return nil
        case .blockFees(_):
            return nil
        case .deposits(_):
            return nil
        case .nonceRevelationRewards(_):
            return nil
        case .doubleSigningEvidenceRewards(_):
            return nil
        case .endorsingRewards(_):
            return nil
        case .bakingRewards(_):
            return nil
        case .bakingBonuses(_):
            return nil
        case .storageFees(_):
            return nil
        case .doubleSigningPunishments(_):
            return nil
        case .lostEndorsingRewards(let lostEndorsingRewards):
            return lostEndorsingRewards.revelation
        case .liquidityBakingSubsidies(_):
            return nil
        case .burned(_):
            return nil
        case .commitments(_):
            return nil
        case .bootstrap(_):
            return nil
        case .invoice(_):
            return nil
        case .initialCommitments(_):
            return nil
        case .minted(_):
            return nil
        case .frozenBonds(_):
            return nil
        case .txRollupRejectionRewards(_):
            return nil
        case .txRollupRejectionPunishments(_):
            return nil
        }
    }
    
    public var committer: BlindedKeyHash.Public? {
        switch self {
        case .contract(_):
            return nil
        case .blockFees(_):
            return nil
        case .deposits(_):
            return nil
        case .nonceRevelationRewards(_):
            return nil
        case .doubleSigningEvidenceRewards(_):
            return nil
        case .endorsingRewards(_):
            return nil
        case .bakingRewards(_):
            return nil
        case .bakingBonuses(_):
            return nil
        case .storageFees(_):
            return nil
        case .doubleSigningPunishments(_):
            return nil
        case .lostEndorsingRewards(_):
            return nil
        case .liquidityBakingSubsidies(_):
            return nil
        case .burned(_):
            return nil
        case .commitments(let commitments):
            return commitments.committer
        case .bootstrap(_):
            return nil
        case .invoice(_):
            return nil
        case .initialCommitments(_):
            return nil
        case .minted(_):
            return nil
        case .frozenBonds(_):
            return nil
        case .txRollupRejectionRewards(_):
            return nil
        case .txRollupRejectionPunishments(_):
            return nil
        }
    }
    
    public var bondID: TxRollupBondID? {
        switch self {
        case .contract(_):
            return nil
        case .blockFees(_):
            return nil
        case .deposits(_):
            return nil
        case .nonceRevelationRewards(_):
            return nil
        case .doubleSigningEvidenceRewards(_):
            return nil
        case .endorsingRewards(_):
            return nil
        case .bakingRewards(_):
            return nil
        case .bakingBonuses(_):
            return nil
        case .storageFees(_):
            return nil
        case .doubleSigningPunishments(_):
            return nil
        case .lostEndorsingRewards(_):
            return nil
        case .liquidityBakingSubsidies(_):
            return nil
        case .burned(_):
            return nil
        case .commitments(_):
            return nil
        case .bootstrap(_):
            return nil
        case .invoice(_):
            return nil
        case .initialCommitments(_):
            return nil
        case .minted(_):
            return nil
        case .frozenBonds(let frozenBonds):
            return frozenBonds.bondID
        case .txRollupRejectionRewards(_):
            return nil
        case .txRollupRejectionPunishments(_):
            return nil
        }
    }
}

// MARK: RPCBalanceUpdate.Contract

extension RPCBalanceUpdate {
    
    public struct Contract: Hashable, Codable {
        private let kind: Kind
        public let contract: Address
        public let change: String
        public let origin: Origin
        
        public init(contract: Address, change: String, origin: Origin) {
            self.kind = .contract
            self.contract = contract
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.BlockFees

extension RPCBalanceUpdate {
    
    public struct BlockFees: Hashable, Codable {
        private let kind: Kind
        private let category: AccumlatorCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .accumulator
            self.category = .blockFees
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.Deposits

extension RPCBalanceUpdate {
    
    public struct Deposits: Hashable, Codable {
        private let kind: Kind
        private let category: FreezerCategory
        public let delegate: KeyHash.Public
        public let change: String
        public let origin: Origin
        
        public init(delegate: KeyHash.Public, change: String, origin: Origin) {
            self.kind = .freezer
            self.category = .deposits
            self.delegate = delegate
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.NonceRevelationRewards

extension RPCBalanceUpdate {
    
    public struct NonceRevelationRewards: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .nonceRevelationRewards
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.DoubleSigningEvidenceRewards

extension RPCBalanceUpdate {
    
    public struct DoubleSigningEvidenceRewards: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .doubleSigningEvidenceRewards
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.EndorsingRewards

extension RPCBalanceUpdate {
    
    public struct EndorsingRewards: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .endorsingRewards
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.BakingRewards

extension RPCBalanceUpdate {
    
    public struct BakingRewards: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .bakingRewards
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.BakingBonuses

extension RPCBalanceUpdate {
    
    public struct BakingBonuses: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .bakingBonuses
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.StorageFees

extension RPCBalanceUpdate {
    
    public struct StorageFees: Hashable, Codable {
        private let kind: Kind
        private let category: BurnedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .burned
            self.category = .storageFees
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.DoubleSigningPunishments

extension RPCBalanceUpdate {
    
    public struct DoubleSigningPunishments: Hashable, Codable {
        private let kind: Kind
        private let category: BurnedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .burned
            self.category = .punishments
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.LostEndorsingRewards

extension RPCBalanceUpdate {
    
    public struct LostEndorsingRewards: Hashable, Codable {
        private let kind: Kind
        private let category: BurnedCategory
        public let delegate: KeyHash.Public
        public let participation: Bool
        public let revelation: Bool
        public let change: String
        public let origin: Origin
        
        public init(delegate: KeyHash.Public, participation: Bool, revelation: Bool, change: String, origin: Origin) {
            self.kind = .burned
            self.category = .lostEndorsingRewards
            self.delegate = delegate
            self.participation = participation
            self.revelation = revelation
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.LiquidityBakingSubsidies

extension RPCBalanceUpdate {
    
    public struct LiquidityBakingSubsidies: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .subsidy
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.Burned

extension RPCBalanceUpdate {
    
    public struct Burned: Hashable, Codable {
        private let kind: Kind
        private let category: BurnedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .burned
            self.category = .burned
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.Commitments

extension RPCBalanceUpdate {
    
    public struct Commitments: Hashable, Codable {
        private let kind: Kind
        private let category: CommitmentCategory
        public let committer: BlindedKeyHash.Public
        public let change: String
        public let origin: Origin
        
        public init(committer: BlindedKeyHash.Public, change: String, origin: Origin) {
            self.kind = .commitment
            self.category = .commitment
            self.committer = committer
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.Bootstrap

extension RPCBalanceUpdate {
    
    public struct Bootstrap: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .bootstrap
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.Invoice

extension RPCBalanceUpdate {
    
    public struct Invoice: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .invoice
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.InitialCommitments

extension RPCBalanceUpdate {
    
    public struct InitialCommitments: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .commitment
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.Minted

extension RPCBalanceUpdate {
    
    public struct Minted: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .minted
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.FrozenBonds

extension RPCBalanceUpdate {
    
    public struct FrozenBonds: Hashable, Codable {
        private let kind: Kind
        private let category: FreezerCategory
        public let contract: Address
        public let bondID: TxRollupBondID
        public let change: String
        public let origin: Origin
        
        public init(contract: Address, bondID: TxRollupBondID, change: String, origin: Origin) {
            self.kind = .freezer
            self.category = .bonds
            self.contract = contract
            self.bondID = bondID
            self.change = change
            self.origin = origin
        }
        
        enum CodingKeys: String, CodingKey {
            case kind
            case category
            case contract
            case bondID = "bond_id"
            case change
            case origin
        }
    }
}

// MARK: RPCBalanceUpdate.TxRollupRejectionRewards

extension RPCBalanceUpdate {
    
    public struct TxRollupRejectionRewards: Hashable, Codable {
        private let kind: Kind
        private let category: MintedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .minted
            self.category = .txRollupRejectionRewards
            self.change = change
            self.origin = origin
        }
    }
}

// MARK: RPCBalanceUpdate.TxRollupRejectionPunishments

extension RPCBalanceUpdate {
    
    public struct TxRollupRejectionPunishments: Hashable, Codable {
        private let kind: Kind
        private let category: BurnedCategory
        public let change: String
        public let origin: Origin
        
        public init(change: String, origin: Origin) {
            self.kind = .burned
            self.category = .txRollupRejectionPunishments
            self.change = change
            self.origin = origin
        }
    }
}

