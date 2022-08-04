//
//  OperationResult.swift
//  
//
//  Created by Julia Samol on 18.07.22.
//

import TezosCore
import TezosMichelson

// MARK: RPCOperationResult

public enum RPCOperationResult {
    case reveal(Reveal)
    case transaction(Transaction)
    case origination(Origination)
    case delegation(Delegation)
    case setDepositsLimit(SetDepositsLimit)
    case registerGlobalConstant(RegisterGlobalConstant)
    
    public var storage: Micheline? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(let transaction):
            return transaction.storage
        case .origination(_):
            return nil
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(_):
            return nil
        }
    }
    
    public var balanceUpdates: [RPCBalanceUpdate]? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(let transaction):
            return transaction.balanceUpdates
        case .origination(let origination):
            return origination.balanceUpdates
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant.balanceUpdates
        }
    }
    
    public var originatedContracts: [Address]? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(let transaction):
            return transaction.originatedContracts
        case .origination(let origination):
            return origination.originatedContracts
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(_):
            return nil
        }
    }
    
    public var consumedGas: String? {
        switch self {
        case .reveal(let reveal):
            return reveal.consumedGas
        case .transaction(let transaction):
            return transaction.consumedGas
        case .origination(let origination):
            return origination.consumedGas
        case .delegation(let delegation):
            return delegation.consumedGas
        case .setDepositsLimit(let setDepositsLimit):
            return setDepositsLimit.consumedGas
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant.consumedGas
        }
    }
    
    public var consumedMilligas: String? {
        switch self {
        case .reveal(let reveal):
            return reveal.consumedMilligas
        case .transaction(let transaction):
            return transaction.consumedMilligas
        case .origination(let origination):
            return origination.consumedMilligas
        case .delegation(let delegation):
            return delegation.consumedMilligas
        case .setDepositsLimit(let setDepositsLimit):
            return setDepositsLimit.consumedMilligas
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant.consumedMilligas
        }
    }
    
    public var storageSize: String? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(let transaction):
            return transaction.storageSize
        case .origination(let origination):
            return origination.storageSize
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant.storageSize
        }
    }
    
    public var paidStorageSizeDiff: String? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(let transaction):
            return transaction.paidStorageSizeDiff
        case .origination(let origination):
            return origination.paidStorageSizeDiff
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(_):
            return nil
        }
    }
    
    public var allocatedDestinationContract: Bool? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(let transaction):
            return transaction.allocatedDestinationContract
        case .origination(_):
            return nil
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(_):
            return nil
        }
    }
    
    public var lazyStorageDiff: RPCLazyStorageDiff? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(let transaction):
            return transaction.lazyStorageDiff
        case .origination(let origination):
            return origination.lazyStorageDiff
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(_):
            return nil
        }
    }
    
    public var globalAddress: ScriptExprHash? {
        switch self {
        case .reveal(_):
            return nil
        case .transaction(_):
            return nil
        case .origination(_):
            return nil
        case .delegation(_):
            return nil
        case .setDepositsLimit(_):
            return nil
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant.globalAddress
        }
    }
    
    public var errors: [RPCError]? {
        switch self {
        case .reveal(let reveal):
            return reveal.errors
        case .transaction(let transaction):
            return transaction.errors
        case .origination(let origination):
            return origination.errors
        case .delegation(let delegation):
            return delegation.errors
        case .setDepositsLimit(let setDepositsLimit):
            return setDepositsLimit.errors
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant.errors
        }
    }
}

// MARK: RPCOperationResult.Reveal

extension RPCOperationResult {
    
    public enum Reveal: Hashable, Codable {
        case applied(Applied)
        case failed(Failed)
        case skipped(Skipped)
        case backtracked(Backtracked)
        
        public var consumedGas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedGas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedGas
            }
        }
        
        public var consumedMilligas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedMilligas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedMilligas
            }
        }
        
        public var errors: [RPCError]? {
            switch self {
            case .applied(_):
                return nil
            case .failed(let failed):
                return failed.errors
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.errors
            }
        }
        
        private enum Status: String, Codable {
            case applied
            case failed
            case skipped
            case backtracked
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let status = try container.decode(Status.self, forKey: .status)
            switch status {
            case .applied:
                self = .applied(try .init(from: decoder))
            case .failed:
                self = .failed(try .init(from: decoder))
            case .skipped:
                self = .skipped(try .init(from: decoder))
            case .backtracked:
                self = .backtracked(try .init(from: decoder))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .applied(let applied):
                try applied.encode(to: encoder)
            case .failed(let failed):
                try failed.encode(to: encoder)
            case .skipped(let skipped):
                try skipped.encode(to: encoder)
            case .backtracked(let backtracked):
                try backtracked.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}

extension RPCOperationResult.Reveal {
    
    public struct Applied: Hashable, Codable {
        private let status: Status
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.status = .applied
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

extension RPCOperationResult.Reveal {
    
    public struct Failed: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]
        
        public init(errors: [RPCError]) {
            self.status = .failed
            self.errors = errors
        }
    }
}

extension RPCOperationResult.Reveal {
    
    public struct Skipped: Hashable, Codable {
        private let status: Status
        
        public init() {
            self.status = .skipped
        }
    }
}

extension RPCOperationResult.Reveal {
    
    public struct Backtracked: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(errors: [RPCError]? = nil, consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.status = .applied
            self.errors = errors
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case errors
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCOperationResult.Transaction

extension RPCOperationResult {
    
    public enum Transaction: Hashable, Codable {
        case appliedToContract(AppliedToContract)
        case appliedToTxRollup(AppliedToTxRollup)
        case failed(Failed)
        case skipped(Skipped)
        case backtrackedToContract(BacktrackedToContract)
        case backtrackedToTxRollup(BacktrackedToTxRollup)
        
        public var storage: Micheline? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.storage
            case .appliedToTxRollup(_):
                return nil
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.storage
            case .backtrackedToTxRollup(_):
                return nil
            }
        }
        
        public var balanceUpdates: [RPCBalanceUpdate]? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.balanceUpdates
            case .appliedToTxRollup(let appliedToTxRollup):
                return appliedToTxRollup.balanceUpdates
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.balanceUpdates
            case .backtrackedToTxRollup(let backtrackedToTxRollup):
                return backtrackedToTxRollup.balanceUpdates
            }
        }
        
        public var originatedContracts: [Address]? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.originatedContracts
            case .appliedToTxRollup(_):
                return nil
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.originatedContracts
            case .backtrackedToTxRollup(_):
                return nil
            }
        }
        
        public var consumedGas: String? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.consumedGas
            case .appliedToTxRollup(let appliedToTxRollup):
                return appliedToTxRollup.consumedGas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.consumedGas
            case .backtrackedToTxRollup(let backtrackedToTxRollup):
                return backtrackedToTxRollup.consumedGas
            }
        }
        
        public var consumedMilligas: String? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.consumedMilligas
            case .appliedToTxRollup(let appliedToTxRollup):
                return appliedToTxRollup.consumedMilligas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.consumedMilligas
            case .backtrackedToTxRollup(let backtrackedToTxRollup):
                return backtrackedToTxRollup.consumedMilligas
            }
        }
        
        public var storageSize: String? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.storageSize
            case .appliedToTxRollup(_):
                return nil
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.storageSize
            case .backtrackedToTxRollup(_):
                return nil
            }
        }
        
        public var paidStorageSizeDiff: String? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.paidStorageSizeDiff
            case .appliedToTxRollup(let appliedToTxRollup):
                return appliedToTxRollup.paidStorageSizeDiff
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.paidStorageSizeDiff
            case .backtrackedToTxRollup(let backtrackedToTxRollup):
                return backtrackedToTxRollup.paidStorageSizeDiff
            }
        }
        
        public var allocatedDestinationContract: Bool? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.allocatedDestinationContract
            case .appliedToTxRollup(_):
                return nil
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.allocatedDestinationContract
            case .backtrackedToTxRollup(_):
                return nil
            }
        }
        
        public var lazyStorageDiff: RPCLazyStorageDiff? {
            switch self {
            case .appliedToContract(let appliedToContract):
                return appliedToContract.lazyStorageDiff
            case .appliedToTxRollup(_):
                return nil
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.lazyStorageDiff
            case .backtrackedToTxRollup(_):
                return nil
            }
        }
        
        public var ticketHash: ScriptExprHash? {
            switch self {
            case .appliedToContract(_):
                return nil
            case .appliedToTxRollup(let appliedToTxRollup):
                return appliedToTxRollup.ticketHash
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtrackedToContract(_):
                return nil
            case .backtrackedToTxRollup(let backtrackedToTxRollup):
                return backtrackedToTxRollup.ticketHash
            }
        }
        
        public var errors: [RPCError]? {
            switch self {
            case .appliedToContract(_):
                return nil
            case .appliedToTxRollup(_):
                return nil
            case .failed(let failed):
                return failed.errors
            case .skipped(_):
                return nil
            case .backtrackedToContract(let backtrackedToContract):
                return backtrackedToContract.errors
            case .backtrackedToTxRollup(let backtrackedToTxRollup):
                return backtrackedToTxRollup.errors
            }
        }
        
        private enum Status: String, Codable {
            case applied
            case failed
            case skipped
            case backtracked
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let status = try container.decode(Status.self, forKey: .status)
            switch status {
            case .applied:
                if let toContract = try? AppliedToContract(from: decoder) {
                    self = .appliedToContract(toContract)
                } else if let toTxRollup = try? AppliedToTxRollup(from: decoder) {
                    self = .appliedToTxRollup(toTxRollup)
                } else {
                    throw TezosError.invalidValue("Unknown Applied RPCOperationResult.Transaction.")
                }
            case .failed:
                self = .failed(try .init(from: decoder))
            case .skipped:
                self = .skipped(try .init(from: decoder))
            case .backtracked:
                if let toContract = try? BacktrackedToContract(from: decoder) {
                    self = .backtrackedToContract(toContract)
                } else if let toTxRollup = try? BacktrackedToTxRollup(from: decoder) {
                    self = .backtrackedToTxRollup(toTxRollup)
                } else {
                    throw TezosError.invalidValue("Unknown Backtracked RPCOperationResult.Transaction.")
                }
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .appliedToContract(let appliedToContract):
                try appliedToContract.encode(to: encoder)
            case .appliedToTxRollup(let appliedToTxRollup):
                try appliedToTxRollup.encode(to: encoder)
            case .failed(let failed):
                try failed.encode(to: encoder)
            case .skipped(let skipped):
                try skipped.encode(to: encoder)
            case .backtrackedToContract(let backtrackedToContract):
                try backtrackedToContract.encode(to: encoder)
            case .backtrackedToTxRollup(let backtrackedToTxRollup):
                try backtrackedToTxRollup.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}

extension RPCOperationResult.Transaction {
    
    public struct AppliedToContract: Hashable, Codable {
        private let status: Status
        public let storage: Micheline?
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let originatedContracts: [Address]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let storageSize: String?
        public let paidStorageSizeDiff: String?
        public let allocatedDestinationContract: Bool?
        public let lazyStorageDiff: RPCLazyStorageDiff?
        
        public init(
            storage: Micheline? = nil,
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            originatedContracts: [Address]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            storageSize: String? = nil,
            paidStorageSizeDiff: String? = nil,
            allocatedDestinationContract: Bool? = nil,
            lazyStorageDiff: RPCLazyStorageDiff? = nil
        ) {
            self.status = .applied
            self.storage = storage
            self.balanceUpdates = balanceUpdates
            self.originatedContracts = originatedContracts
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.storageSize = storageSize
            self.paidStorageSizeDiff = paidStorageSizeDiff
            self.allocatedDestinationContract = allocatedDestinationContract
            self.lazyStorageDiff = lazyStorageDiff
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case storage
            case balanceUpdates = "balance_updates"
            case originatedContracts = "originated_contracts"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case storageSize = "storage_size"
            case paidStorageSizeDiff = "paid_storage_size_diff"
            case allocatedDestinationContract = "allocated_destination_contract"
            case lazyStorageDiff = "lazy_storage_diff"
        }
    }
}

extension RPCOperationResult.Transaction {
    
    public struct AppliedToTxRollup: Hashable, Codable {
        private let status: Status
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let ticketHash: ScriptExprHash
        public let paidStorageSizeDiff: String
        
        public init(
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            ticketHash: ScriptExprHash,
            paidStorageSizeDiff: String
        ) {
            self.status = .applied
            self.balanceUpdates = balanceUpdates
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.ticketHash = ticketHash
            self.paidStorageSizeDiff = paidStorageSizeDiff
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case balanceUpdates = "balance_updates"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case ticketHash = "ticket_hash"
            case paidStorageSizeDiff = "paid_storage_size_diff"
        }
    }
}

extension RPCOperationResult.Transaction {
    
    public struct Failed: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]
        
        public init(errors: [RPCError]) {
            self.status = .failed
            self.errors = errors
        }
    }
}

extension RPCOperationResult.Transaction {
    
    public struct Skipped: Hashable, Codable {
        private let status: Status
        
        public init() {
            self.status = .skipped
        }
    }
}

extension RPCOperationResult.Transaction {
    
    public struct BacktrackedToContract: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]?
        public let storage: Micheline?
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let originatedContracts: [Address]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let storageSize: String?
        public let paidStorageSizeDiff: String?
        public let allocatedDestinationContract: Bool?
        public let lazyStorageDiff: RPCLazyStorageDiff?
        
        public init(
            errors: [RPCError]? = nil,
            storage: Micheline? = nil,
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            originatedContracts: [Address]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            storageSize: String? = nil,
            paidStorageSizeDiff: String? = nil,
            allocatedDestinationContract: Bool? = nil,
            lazyStorageDiff: RPCLazyStorageDiff? = nil
        ) {
            self.status = .backtracked
            self.errors = errors
            self.storage = storage
            self.balanceUpdates = balanceUpdates
            self.originatedContracts = originatedContracts
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.storageSize = storageSize
            self.paidStorageSizeDiff = paidStorageSizeDiff
            self.allocatedDestinationContract = allocatedDestinationContract
            self.lazyStorageDiff = lazyStorageDiff
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case errors
            case storage
            case balanceUpdates = "balance_updates"
            case originatedContracts = "originated_contracts"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case storageSize = "storage_size"
            case paidStorageSizeDiff = "paid_storage_size_diff"
            case allocatedDestinationContract = "allocated_destination_contract"
            case lazyStorageDiff = "lazy_storage_diff"
        }
    }
}

extension RPCOperationResult.Transaction {
    
    public struct BacktrackedToTxRollup: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]?
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let ticketHash: ScriptExprHash
        public let paidStorageSizeDiff: String
        
        public init(
            errors: [RPCError]? = nil,
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            ticketHash: ScriptExprHash,
            paidStorageSizeDiff: String
        ) {
            self.status = .backtracked
            self.errors = errors
            self.balanceUpdates = balanceUpdates
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.ticketHash = ticketHash
            self.paidStorageSizeDiff = paidStorageSizeDiff
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case errors
            case balanceUpdates = "balance_updates"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case ticketHash = "ticket_hash"
            case paidStorageSizeDiff = "paid_storage_size_diff"
        }
    }
}

// MARK: RPCOperationResult.Origination

extension RPCOperationResult {
    
    public enum Origination: Hashable, Codable {
        case applied(Applied)
        case failed(Failed)
        case skipped(Skipped)
        case backtracked(Backtracked)
        
        public var balanceUpdates: [RPCBalanceUpdate]? {
            switch self {
            case .applied(let applied):
                return applied.balanceUpdates
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.balanceUpdates
            }
        }
        
        public var originatedContracts: [Address]? {
            switch self {
            case .applied(let applied):
                return applied.originatedContracts
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.originatedContracts
            }
        }
        
        public var consumedGas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedGas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedGas
            }
        }
        
        public var consumedMilligas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedMilligas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedMilligas
            }
        }
        
        public var storageSize: String? {
            switch self {
            case .applied(let applied):
                return applied.storageSize
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.storageSize
            }
        }
        
        public var paidStorageSizeDiff: String? {
            switch self {
            case .applied(let applied):
                return applied.paidStorageSizeDiff
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.paidStorageSizeDiff
            }
        }
        
        public var lazyStorageDiff: RPCLazyStorageDiff? {
            switch self {
            case .applied(let applied):
                return applied.lazyStorageDiff
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.lazyStorageDiff
            }
        }
        
        public var errors: [RPCError]? {
            switch self {
            case .applied(_):
                return nil
            case .failed(let failed):
                return failed.errors
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.errors
            }
        }
        
        private enum Status: String, Codable {
            case applied
            case failed
            case skipped
            case backtracked
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let status = try container.decode(Status.self, forKey: .status)
            switch status {
            case .applied:
                self = .applied(try .init(from: decoder))
            case .failed:
                self = .failed(try .init(from: decoder))
            case .skipped:
                self = .skipped(try .init(from: decoder))
            case .backtracked:
                self = .backtracked(try .init(from: decoder))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .applied(let applied):
                try applied.encode(to: encoder)
            case .failed(let failed):
                try failed.encode(to: encoder)
            case .skipped(let skipped):
                try skipped.encode(to: encoder)
            case .backtracked(let backtracked):
                try backtracked.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}

extension RPCOperationResult.Origination {
    
    public struct Applied: Hashable, Codable {
        private let status: Status
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let originatedContracts: [Address]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let storageSize: String?
        public let paidStorageSizeDiff: String?
        public let lazyStorageDiff: RPCLazyStorageDiff?
        
        public init(
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            originatedContracts: [Address]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            storageSize: String? = nil,
            paidStorageSizeDiff: String? = nil,
            lazyStorageDiff: RPCLazyStorageDiff? = nil
        ) {
            self.status = .applied
            self.balanceUpdates = balanceUpdates
            self.originatedContracts = originatedContracts
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.storageSize = storageSize
            self.paidStorageSizeDiff = paidStorageSizeDiff
            self.lazyStorageDiff = lazyStorageDiff
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case balanceUpdates = "balance_updates"
            case originatedContracts = "originated_contracts"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case storageSize = "storage_size"
            case paidStorageSizeDiff = "paid_storage_size_diff"
            case lazyStorageDiff = "lazy_storage_diff"
        }
    }
}

extension RPCOperationResult.Origination {
    
    public struct Failed: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]
        
        public init(errors: [RPCError]) {
            self.status = .failed
            self.errors = errors
        }
    }
}

extension RPCOperationResult.Origination {
    
    public struct Skipped: Hashable, Codable {
        private let status: Status
        
        public init() {
            self.status = .skipped
        }
    }
}

extension RPCOperationResult.Origination {
    
    public struct Backtracked: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]?
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let originatedContracts: [Address]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let storageSize: String?
        public let paidStorageSizeDiff: String?
        public let lazyStorageDiff: RPCLazyStorageDiff?
        
        public init(
            errors: [RPCError]? = nil,
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            originatedContracts: [Address]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            storageSize: String? = nil,
            paidStorageSizeDiff: String? = nil,
            lazyStorageDiff: RPCLazyStorageDiff? = nil
        ) {
            self.status = .backtracked
            self.errors = errors
            self.balanceUpdates = balanceUpdates
            self.originatedContracts = originatedContracts
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.storageSize = storageSize
            self.paidStorageSizeDiff = paidStorageSizeDiff
            self.lazyStorageDiff = lazyStorageDiff
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case errors
            case balanceUpdates = "balance_updates"
            case originatedContracts = "originated_contracts"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case storageSize = "storage_size"
            case paidStorageSizeDiff = "paid_storage_size_diff"
            case lazyStorageDiff = "lazy_storage_diff"
        }
    }
}

// MARK: RPCOperationResult.Delegation

extension RPCOperationResult {
    
    public enum Delegation: Hashable, Codable {
        case applied(Applied)
        case failed(Failed)
        case skipped(Skipped)
        case backtracked(Backtracked)
        
        public var consumedGas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedGas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedGas
            }
        }
        
        public var consumedMilligas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedMilligas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedMilligas
            }
        }
        
        public var errors: [RPCError]? {
            switch self {
            case .applied(_):
                return nil
            case .failed(let failed):
                return failed.errors
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.errors
            }
        }
        
        private enum Status: String, Codable {
            case applied
            case failed
            case skipped
            case backtracked
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let status = try container.decode(Status.self, forKey: .status)
            switch status {
            case .applied:
                self = .applied(try .init(from: decoder))
            case .failed:
                self = .failed(try .init(from: decoder))
            case .skipped:
                self = .skipped(try .init(from: decoder))
            case .backtracked:
                self = .backtracked(try .init(from: decoder))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .applied(let applied):
                try applied.encode(to: encoder)
            case .failed(let failed):
                try failed.encode(to: encoder)
            case .skipped(let skipped):
                try skipped.encode(to: encoder)
            case .backtracked(let backtracked):
                try backtracked.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}

extension RPCOperationResult.Delegation {
    
    public struct Applied: Hashable, Codable {
        private let status: Status
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.status = .applied
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

extension RPCOperationResult.Delegation {
    
    public struct Failed: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]
        
        public init(errors: [RPCError]) {
            self.status = .failed
            self.errors = errors
        }
    }
}

extension RPCOperationResult.Delegation {
    
    public struct Skipped: Hashable, Codable {
        private let status: Status
        
        public init() {
            self.status = .skipped
        }
    }
}

extension RPCOperationResult.Delegation {
    
    public struct Backtracked: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(errors: [RPCError]? = nil, consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.status = .backtracked
            self.errors = errors
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case errors
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCOperationResult.SetDepositsLimit

extension RPCOperationResult {
    
    public enum SetDepositsLimit: Hashable, Codable {
        case applied(Applied)
        case failed(Failed)
        case skipped(Skipped)
        case backtracked(Backtracked)
        
        public var consumedGas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedGas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedGas
            }
        }
        
        public var consumedMilligas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedMilligas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedMilligas
            }
        }
        
        public var errors: [RPCError]? {
            switch self {
            case .applied(_):
                return nil
            case .failed(let failed):
                return failed.errors
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.errors
            }
        }
        
        private enum Status: String, Codable {
            case applied
            case failed
            case skipped
            case backtracked
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let status = try container.decode(Status.self, forKey: .status)
            switch status {
            case .applied:
                self = .applied(try .init(from: decoder))
            case .failed:
                self = .failed(try .init(from: decoder))
            case .skipped:
                self = .skipped(try .init(from: decoder))
            case .backtracked:
                self = .backtracked(try .init(from: decoder))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .applied(let applied):
                try applied.encode(to: encoder)
            case .failed(let failed):
                try failed.encode(to: encoder)
            case .skipped(let skipped):
                try skipped.encode(to: encoder)
            case .backtracked(let backtracked):
                try backtracked.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}

extension RPCOperationResult.SetDepositsLimit {
    
    public struct Applied: Hashable, Codable {
        private let status: Status
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.status = .applied
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

extension RPCOperationResult.SetDepositsLimit {
    
    public struct Failed: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]
        
        public init(errors: [RPCError]) {
            self.status = .failed
            self.errors = errors
        }
    }
}

extension RPCOperationResult.SetDepositsLimit {
    
    public struct Skipped: Hashable, Codable {
        private let status: Status
        
        public init() {
            self.status = .skipped
        }
    }
}

extension RPCOperationResult.SetDepositsLimit {
    
    public struct Backtracked: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        
        public init(errors: [RPCError]? = nil, consumedGas: String? = nil, consumedMilligas: String? = nil) {
            self.status = .backtracked
            self.errors = errors
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case errors
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
        }
    }
}

// MARK: RPCOperationResult.RegisterGlobalConstant

extension RPCOperationResult {
    
    public enum RegisterGlobalConstant: Hashable, Codable {
        case applied(Applied)
        case failed(Failed)
        case skipped(Skipped)
        case backtracked(Backtracked)
        
        public var balanceUpdates: [RPCBalanceUpdate]? {
            switch self {
            case .applied(let applied):
                return applied.balanceUpdates
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.balanceUpdates
            }
        }
        
        public var consumedGas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedGas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedGas
            }
        }
        
        public var consumedMilligas: String? {
            switch self {
            case .applied(let applied):
                return applied.consumedMilligas
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.consumedMilligas
            }
        }
        
        public var storageSize: String? {
            switch self {
            case .applied(let applied):
                return applied.storageSize
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.storageSize
            }
        }
        
        public var globalAddress: ScriptExprHash? {
            switch self {
            case .applied(let applied):
                return applied.globalAddress
            case .failed(_):
                return nil
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.globalAddress
            }
        }
        
        public var errors: [RPCError]? {
            switch self {
            case .applied(_):
                return nil
            case .failed(let failed):
                return failed.errors
            case .skipped(_):
                return nil
            case .backtracked(let backtracked):
                return backtracked.errors
            }
        }
        
        private enum Status: String, Codable {
            case applied
            case failed
            case skipped
            case backtracked
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let status = try container.decode(Status.self, forKey: .status)
            switch status {
            case .applied:
                self = .applied(try .init(from: decoder))
            case .failed:
                self = .failed(try .init(from: decoder))
            case .skipped:
                self = .skipped(try .init(from: decoder))
            case .backtracked:
                self = .backtracked(try .init(from: decoder))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .applied(let applied):
                try applied.encode(to: encoder)
            case .failed(let failed):
                try failed.encode(to: encoder)
            case .skipped(let skipped):
                try skipped.encode(to: encoder)
            case .backtracked(let backtracked):
                try backtracked.encode(to: encoder)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}

extension RPCOperationResult.RegisterGlobalConstant {
    
    public struct Applied: Hashable, Codable {
        private let status: Status
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let storageSize: String?
        public let globalAddress: ScriptExprHash
        
        public init(
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            storageSize: String? = nil,
            globalAddress: ScriptExprHash
        ) {
            self.status = .applied
            self.balanceUpdates = balanceUpdates
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.storageSize = storageSize
            self.globalAddress = globalAddress
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case balanceUpdates = "balance_updates"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case storageSize = "storage_size"
            case globalAddress = "global_address"
        }
    }
}

extension RPCOperationResult.RegisterGlobalConstant {
    
    public struct Failed: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]
        
        public init(errors: [RPCError]) {
            self.status = .failed
            self.errors = errors
        }
    }
}

extension RPCOperationResult.RegisterGlobalConstant {
    
    public struct Skipped: Hashable, Codable {
        private let status: Status
        
        public init() {
            self.status = .skipped
        }
    }
}

extension RPCOperationResult.RegisterGlobalConstant {
    
    public struct Backtracked: Hashable, Codable {
        private let status: Status
        public let errors: [RPCError]?
        public let balanceUpdates: [RPCBalanceUpdate]?
        public let consumedGas: String?
        public let consumedMilligas: String?
        public let storageSize: String?
        public let globalAddress: ScriptExprHash
        
        public init(
            errors: [RPCError]? = nil,
            balanceUpdates: [RPCBalanceUpdate]? = nil,
            consumedGas: String? = nil,
            consumedMilligas: String? = nil,
            storageSize: String? = nil,
            globalAddress: ScriptExprHash
        ) {
            self.status = .backtracked
            self.errors = errors
            self.balanceUpdates = balanceUpdates
            self.consumedGas = consumedGas
            self.consumedMilligas = consumedMilligas
            self.storageSize = storageSize
            self.globalAddress = globalAddress
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case errors
            case balanceUpdates = "balance_updates"
            case consumedGas = "consumed_gas"
            case consumedMilligas = "consumed_milligas"
            case storageSize = "storage_size"
            case globalAddress = "global_address"
        }
    }
}
