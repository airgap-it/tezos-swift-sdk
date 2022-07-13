//
//  BlockRPC.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

// MARK: ../<block_id>

public protocol Block {
    func get(configuredWith configuration: BlockGetConfiguration) async throws
    
    var context: BlockContext { get }
    var header: BlockHeader { get }
    var helpers: BlockHelpers { get }
    var operations: BlockOperations { get }
}

public extension Block {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context

public protocol BlockContext {
    var bigMaps: BlockContextBigMaps { get }
    var constants: BlockContextConstants { get }
    var contracts: BlockContextContracts { get }
    var delegates: BlockContextDelegates { get }
    var sapling: BlockContextSapling { get }
}

// MARK: ../<block_id>/context/big_maps

public protocol BlockContextBigMaps {
    func callAsFunction(bigMapID: String) -> BlockContextBigMapsBigMap
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>

public protocol BlockContextBigMapsBigMap {
    func get(configuredWith configuration: BlockContextBigMapsBigMapGetConfiguration) async throws
    
    func callAsFunction(scriptExpr: ScriptExprHash) -> BlockContextBigMapsBigMapValue
}

public extension BlockContextBigMapsBigMap {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public struct BlockContextBigMapsBigMapGetConfiguration: BaseConfiguration {
    public let offset: UInt32?
    public let length: UInt32?
    public let headers: [HTTPHeader]
    
    public init(offset: UInt32? = nil, length: UInt32? = nil, headers: [HTTPHeader] = []) {
        self.offset = offset
        self.length = length
        self.headers = headers
    }
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>/value

public protocol BlockContextBigMapsBigMapValue {
    func get(configuredWith configuration: BlockContextBigMapsBigMapValueGetConfiguration) async throws
}

public extension BlockContextBigMapsBigMapValue {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextBigMapsBigMapValueGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/constants

public protocol BlockContextConstants {
    func get(configuredWith configuration: BlockContextConstantsGetConfiguration) async throws
}

public extension BlockContextConstants {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextConstantsGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts

public protocol BlockContextContracts {
    func callAsFunction(address: Address) -> BlockContextContractsContract
}

// MARK: ../<block_id>/context/contracts/contract

public protocol BlockContextContractsContract {
    func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws
    
    var balance: BlockContextContractsContractBalance { get }
    var counter: BlockContextContractsContractCounter { get }
    var delegate: BlockContextContractsContractDelegate { get }
    var entrypoints: BlockContextContractsContractEntrypoints { get }
    var managerKey: BlockContextContractsContractManagerKey { get }
    var script: BlockContextContractsContractScript { get }
    var singleSaplingGetDiff: BlockContextContractsContractSingleSaplingGetDiff { get }
    var storage: BlockContextContractsContractStorage { get }
}

public extension BlockContextContractsContract {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/balance

public protocol BlockContextContractsContractBalance {
    func get(configuredWith configuration: BlockContextContractsContractBalanceGetConfiguration) async throws
}

public extension BlockContextContractsContractBalance {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractBalanceGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/counter

public protocol BlockContextContractsContractCounter {
    func get(configuredWith configuration: BlockContextContractsContractCounterGetConfiguration) async throws
}

public extension BlockContextContractsContractCounter {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractCounterGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/delegate

public protocol BlockContextContractsContractDelegate {
    func get(configuredWith configuration: BlockContextContractsContractDelegateGetConfiguration) async throws
}

public extension BlockContextContractsContractDelegate {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractDelegateGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/entrypoints

public protocol BlockContextContractsContractEntrypoints {
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsGetConfiguration) async throws
    
    func callAsFunction(string: String) -> BlockContextContractsContractEntrypointsEntrypoint
}

public extension BlockContextContractsContractEntrypoints {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractEntrypointsGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/entrypoints/<string>

public protocol BlockContextContractsContractEntrypointsEntrypoint {
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsEntrypointGetConfiguration) async throws
}

public extension BlockContextContractsContractEntrypointsEntrypoint {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractEntrypointsEntrypointGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/manager_key

public protocol BlockContextContractsContractManagerKey {
    func get(configuredWith configuration: BlockContextContractsContractManagerKeyGetConfiguration) async throws
}

public extension BlockContextContractsContractManagerKey {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractManagerKeyGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/script

public protocol BlockContextContractsContractScript {
    func get(configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws
    
    var normalized: BlockContextContractsContractScriptNormalized { get }
}

public extension BlockContextContractsContractScript {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractScriptGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/script/normalized

public protocol BlockContextContractsContractScriptNormalized {
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws
}

public extension BlockContextContractsContractScriptNormalized {
    func post(unparsingMode: RPCScriptParsing) async throws {
        try await post(unparsingMode: unparsingMode, configuredWith: .init())
    }
}

public typealias BlockContextContractsContractScriptNormalizedPostConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/single_sapling_get_diff

public protocol BlockContextContractsContractSingleSaplingGetDiff {
    func get(configuredWith configuration: BlockContextContractsContractSingleSaplingGetDiffGetConfiguration) async throws
}

public extension BlockContextContractsContractSingleSaplingGetDiff {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractSingleSaplingGetDiffGetConfiguration = BlockContextSaplingStateGetDiffGetConfiguration

// MARK: ../<block_id>/context/contracts/contract/storage

public protocol BlockContextContractsContractStorage {
    func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws
}

public extension BlockContextContractsContractStorage {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextContractsContractStorageGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/contracts/contract/storage/normalized

public protocol BlockContextContractsContractStorageNormalized {
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractStorageGetConfiguration) async throws
}

public extension BlockContextContractsContractStorageNormalized {
    func post(unparsingMode: RPCScriptParsing) async throws {
        try await post(unparsingMode: unparsingMode, configuredWith: .init())
    }
}

public typealias BlockContextContractsContractStorageNormalizedPostConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates

public protocol BlockContextDelegates {
    func callAsFunction(pkh: KeyHash.Public) -> BlockContextDelegatesDelegate
}

// MARK: ../<block_id>/context/delegates/<pkh>

public protocol BlockContextDelegatesDelegate {
    func get(configuredWith configuration: BlockContextDelegatesDelegateGetConfiguration) async throws
    
    var currentFrozenDeposits: BlockContextDelegatesCurrentFrozenDeposits { get }
    var deactivated: BlockContextDelegatesDeactivated { get }
    var delegatedBalance: BlockContextDelegatesDelegatedBalance { get }
    var delegatedContracts: BlockContextDelegatesDelegatedContracts { get }
    var frozenDeposits: BlockContextDelegatesCurrentFrozenDeposits { get }
    var frozenDepositsLimit: BlockContextDelegatesFrozenDeposistsLimit { get }
    var fullBalance: BlockContextDelegatesFullBalance { get }
    var gracePeriod: BlockContextDelegatesGracePeriod { get }
    var participation: BlockContextDelegatesParticipation { get }
    var stakingBalance: BlockContextDelegatesStakingBalance { get }
    var votingPower: BlockContextDelegatesVotingPower { get }
}

public extension BlockContextDelegatesDelegate {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesDelegateGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/current_frozen_deposits

public protocol BlockContextDelegatesCurrentFrozenDeposits {
    func get(configuredWith configuration: BlockContextDelegatesCurrentFrozenDepositsGetConfiguration) async throws
}

public extension BlockContextDelegatesCurrentFrozenDeposits {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesCurrentFrozenDepositsGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/deactivated

public protocol BlockContextDelegatesDeactivated {
    func get(configuredWith configuration: BlockContextDelegatesDeactivatedGetConfiguration) async throws
}

public extension BlockContextDelegatesDeactivated {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesDeactivatedGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/delegated_balance

public protocol BlockContextDelegatesDelegatedBalance {
    func get(configuredWith configuration: BlockContextDelegatesDelegatedBalanceGetConfiguration) async throws
}

public extension BlockContextDelegatesDelegatedBalance {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesDelegatedBalanceGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/delegated_contracts

public protocol BlockContextDelegatesDelegatedContracts {
    func get(configuredWith configuration: BlockContextDelegatesDelegatedContractsGetConfiguration) async throws
}

public extension BlockContextDelegatesDelegatedContracts {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesDelegatedContractsGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/frozen_deposits

public protocol BlockContextDelegatesFrozenDeposits {
    func get(configuredWith configuration: BlockContextDelegatesFrozenDepositsGetConfiguration) async throws
}

public extension BlockContextDelegatesFrozenDeposits {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesFrozenDepositsGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/frozen_deposits_limit

public protocol BlockContextDelegatesFrozenDeposistsLimit {
    func get(configuredWith configuration: BlockContextDelegatesFrozenDeposistsLimitGetConfiguration) async throws
}

public extension BlockContextDelegatesFrozenDeposistsLimit {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesFrozenDeposistsLimitGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/full_balance

public protocol BlockContextDelegatesFullBalance {
    func get(configuredWith configuration: BlockContextDelegatesFullBalanceGetConfiguration) async throws
}

public extension BlockContextDelegatesFullBalance {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesFullBalanceGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/grace_period

public protocol BlockContextDelegatesGracePeriod {
    func get(configuredWith configuration: BlockContextDelegatesGracePeriodGetConfiguration) async throws
}

public extension BlockContextDelegatesGracePeriod {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesGracePeriodGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/participation

public protocol BlockContextDelegatesParticipation {
    func get(configuredWith configuration: BlockContextDelegatesParticipationGetConfiguration) async throws
}

public extension BlockContextDelegatesParticipation {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesParticipationGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/staking_balance

public protocol BlockContextDelegatesStakingBalance {
    func get(configuredWith configuration: BlockContextDelegatesStakingBalanceGetConfiguration) async throws
}

public extension BlockContextDelegatesStakingBalance {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesStakingBalanceGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/delegates/voting_power

public protocol BlockContextDelegatesVotingPower {
    func get(configuredWith configuration: BlockContextDelegatesVotingPowerGetConfiguration) async throws
}

public extension BlockContextDelegatesVotingPower {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockContextDelegatesVotingPowerGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/context/sapling

public protocol BlockContextSapling {
    func callAsFunction(stateID: String) -> BlockContextSaplingState
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>

public protocol BlockContextSaplingState {
    var getDiff: BlockContextSaplingStateGetDiff { get }
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>/get_diff

public protocol BlockContextSaplingStateGetDiff {
    func get(configuredWith configuration: BlockContextSaplingStateGetDiffGetConfiguration) async throws
}

public extension BlockContextSaplingStateGetDiff {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public struct BlockContextSaplingStateGetDiffGetConfiguration: BaseConfiguration {
    public let commitmentOffset: UInt64?
    public let nullifierOffset: UInt64?
    public let headers: [HTTPHeader]
    
    public init(commitmentOffset: UInt64? = nil, nullifierOffset: UInt64? = nil, headers: [HTTPHeader] = []) {
        self.commitmentOffset = commitmentOffset
        self.nullifierOffset = nullifierOffset
        self.headers = headers
    }
}

// MARK: ../<block_id>/header

public protocol BlockHeader {
    func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws
}

public extension BlockHeader {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockHeaderGetConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/helpers

public protocol BlockHelpers {
    var preapply: BlockHelpersPreapply { get }
    var scripts: BlockHelpersScripts { get }
}

// MARK: ../<block_id>/helpers/preapply

public protocol BlockHelpersPreapply {
    var operations: BlockHelpersPreapplyOperations { get }
}

// MARK: ../<block_id>/helpers/preapply/operations

public protocol BlockHelpersPreapplyOperations {
    func post(operations: [RPCApplicableOperation], configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration) async throws
}

public extension BlockHelpersPreapplyOperations {
    func post(operations: [RPCApplicableOperation]) async throws {
        try await post(operations: operations, configuredWith: .init())
    }
}

public typealias BlockHelpersPreapplyOperationsPostConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/helpers/scripts

public protocol BlockHelpersScripts {
    var runOperation: BlockHelpersScriptsRunOperation { get }
}

// MARK: ../<block_id>/helpers/scripts/run_operation

public protocol BlockHelpersScriptsRunOperation {
    func post(operation: RPCRunnableOperation, configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration) async throws
}

public extension BlockHelpersScriptsRunOperation {
    func post(operation: RPCRunnableOperation) async throws {
        try await post(operation: operation, configuredWith: .init())
    }
}

public typealias BlockHelpersScriptsRunOperationPostConfiguration = HeadersOnlyConfiguration

// MARK: ../<block_id>/operations

public protocol BlockOperations {
    func get(configuredWith configuration: BlockOperationsGetConfiguration) async throws
}

public extension BlockOperations {
    func get() async throws {
        try await get(configuredWith: .init())
    }
}

public typealias BlockOperationsGetConfiguration = HeadersOnlyConfiguration
