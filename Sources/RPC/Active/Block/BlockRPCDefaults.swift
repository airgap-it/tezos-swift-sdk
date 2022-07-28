//
//  BlockRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore
import TezosMichelson
import TezosOperation

// MARK: Block

public extension Block {
    func get() async throws -> RPCBlock {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextBigMapsBigMap

public extension BlockContextBigMapsBigMap {
    func get() async throws -> [Micheline] {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextBigMapsBigMapValue

public extension BlockContextBigMapsBigMapValue {
    func get() async throws -> Micheline? {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextConstants

public extension BlockContextConstants {
    func get() async throws -> RPCConstants {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContract

public extension BlockContextContractsContract {
    func get() async throws -> RPCContractDetails {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractBalance

public extension BlockContextContractsContractBalance {
    func get() async throws -> String {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractCounter

public extension BlockContextContractsContractCounter {
    func get() async throws -> String? {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractDelegate

public extension BlockContextContractsContractDelegate {
    func get() async throws -> Address.Implicit? {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractEntrypoints

public extension BlockContextContractsContractEntrypoints {
    func get() async throws -> RPCContractEntrypoints {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractEntrypointsEntrypoint

public extension BlockContextContractsContractEntrypointsEntrypoint {
    func get() async throws -> Micheline {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractManagerKey

public extension BlockContextContractsContractManagerKey {
    func get() async throws -> Key.Public? {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractScript

public extension BlockContextContractsContractScript {
    func get() async throws -> Script? {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractScriptNormalized

public extension BlockContextContractsContractScriptNormalized {
    func post(unparsingMode: RPCScriptParsing) async throws -> Script? {
        try await post(unparsingMode: unparsingMode, configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractSingleSaplingGetDiff

public extension BlockContextContractsContractSingleSaplingGetDiff {
    func get() async throws -> RPCSaplingStateDiff {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractStorage

public extension BlockContextContractsContractStorage {
    func get() async throws -> Micheline? {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextContractsContractStorageNormalized

public extension BlockContextContractsContractStorageNormalized {
    func post(unparsingMode: RPCScriptParsing) async throws -> Micheline? {
        try await post(unparsingMode: unparsingMode, configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesDelegate

public extension BlockContextDelegatesDelegate {
    func get() async throws -> RPCDelegateDetails {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesCurrentFrozenDeposits

public extension BlockContextDelegatesCurrentFrozenDeposits {
    func get() async throws -> String {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesDeactivated

public extension BlockContextDelegatesDeactivated {
    func get() async throws -> Bool {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesDelegatedBalance

public extension BlockContextDelegatesDelegatedBalance {
    func get() async throws -> String {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesDelegatedContracts

public extension BlockContextDelegatesDelegatedContracts {
    func get() async throws -> [Address] {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesFrozenDeposits

public extension BlockContextDelegatesFrozenDeposits {
    func get() async throws -> String {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesFrozenDeposistsLimit

public extension BlockContextDelegatesFrozenDeposistsLimit {
    func get() async throws -> String {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesFullBalance

public extension BlockContextDelegatesFullBalance {
    func get() async throws -> String {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesGracePeriod

public extension BlockContextDelegatesGracePeriod {
    func get() async throws -> Int32 {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesParticipation

public extension BlockContextDelegatesParticipation {
    func get() async throws -> RPCDelegateParticipation {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesStakingBalance

public extension BlockContextDelegatesStakingBalance {
    func get() async throws -> String {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextDelegatesVotingPower

public extension BlockContextDelegatesVotingPower {
    func get() async throws -> Int32 {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockContextSaplingStateGetDiff

public extension BlockContextSaplingStateGetDiff {
    func get() async throws -> RPCSaplingStateDiff {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockHeader

public extension BlockHeader {
    func get() async throws -> RPCFullBlockHeader {
        try await get(configuredWith: .init())
    }
}

// MARK: BlockHelpersPreapplyOperations

public extension BlockHelpersPreapplyOperations {
    func post(operations: [RPCApplicableOperation]) async throws -> RPCAppliedOperation {
        try await post(operations: operations, configuredWith: .init())
    }
}

// MARK: BlockHelpersScriptsRunOperation

public extension BlockHelpersScriptsRunOperation {
    func post(operation: RPCRunnableOperation) async throws -> [RPCOperation.Content] {
        try await post(operation: operation, configuredWith: .init())
    }
}

// MARK: BlockOperations

public extension BlockOperations {
    func get() async throws -> [[RPCOperation]] {
        try await get(configuredWith: .init())
    }
}
