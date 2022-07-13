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
    func get(configuredWith configuration: BlockGetConfiguration) async throws -> GetBlockResponse
    
    var context: BlockContext { get }
    var header: BlockHeader { get }
    var helpers: BlockHelpers { get }
    var operations: BlockOperations { get }
}

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
    func get(configuredWith configuration: BlockContextBigMapsBigMapGetConfiguration) async throws -> GetBigMapResponse
    
    func callAsFunction(scriptExpr: ScriptExprHash) -> BlockContextBigMapsBigMapValue
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>/value

public protocol BlockContextBigMapsBigMapValue {
    func get(configuredWith configuration: BlockContextBigMapsBigMapValueGetConfiguration) async throws -> GetBigMapValueResponse
}

// MARK: ../<block_id>/context/constants

public protocol BlockContextConstants {
    func get(configuredWith configuration: BlockContextConstantsGetConfiguration) async throws -> GetConstantsResponse
}

// MARK: ../<block_id>/context/contracts

public protocol BlockContextContracts {
    func callAsFunction(contractID: Address) -> BlockContextContractsContract
}

// MARK: ../<block_id>/context/contracts/<contract_id>

public protocol BlockContextContractsContract {
    func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws -> GetContractDetailsResponse
    
    var balance: BlockContextContractsContractBalance { get }
    var counter: BlockContextContractsContractCounter { get }
    var delegate: BlockContextContractsContractDelegate { get }
    var entrypoints: BlockContextContractsContractEntrypoints { get }
    var managerKey: BlockContextContractsContractManagerKey { get }
    var script: BlockContextContractsContractScript { get }
    var singleSaplingGetDiff: BlockContextContractsContractSingleSaplingGetDiff { get }
    var storage: BlockContextContractsContractStorage { get }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/balance

public protocol BlockContextContractsContractBalance {
    func get(configuredWith configuration: BlockContextContractsContractBalanceGetConfiguration) async throws -> GetContractBalanceResponse
}

// MARK: ../<block_id>/context/contracts/<contract_id>/counter

public protocol BlockContextContractsContractCounter {
    func get(configuredWith configuration: BlockContextContractsContractCounterGetConfiguration) async throws -> GetContractCounterResponse
}

// MARK: ../<block_id>/context/contracts/<contract_id>/delegate

public protocol BlockContextContractsContractDelegate {
    func get(configuredWith configuration: BlockContextContractsContractDelegateGetConfiguration) async throws -> GetContractDelegateResponse
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints

public protocol BlockContextContractsContractEntrypoints {
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsGetConfiguration) async throws -> GetContractEntrypointsResponse
    
    func callAsFunction(string: String) -> BlockContextContractsContractEntrypointsEntrypoint
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints/<string>

public protocol BlockContextContractsContractEntrypointsEntrypoint {
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsEntrypointGetConfiguration) async throws -> GetContractEntrypointResponse
}

// MARK: ../<block_id>/context/contracts/<contract_id>/manager_key

public protocol BlockContextContractsContractManagerKey {
    func get(configuredWith configuration: BlockContextContractsContractManagerKeyGetConfiguration) async throws -> GetContractManagerKeyResponse
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script

public protocol BlockContextContractsContractScript {
    func get(configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws -> GetContractScriptResponse
    
    var normalized: BlockContextContractsContractScriptNormalized { get }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script/normalized

public protocol BlockContextContractsContractScriptNormalized {
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws -> GetContractNormalizedScriptResponse
}

// MARK: ../<block_id>/context/contracts/<contract_id>/single_sapling_get_diff

public protocol BlockContextContractsContractSingleSaplingGetDiff {
    func get(configuredWith configuration: BlockContextContractsContractSingleSaplingGetDiffGetConfiguration) async throws -> GetContractSaplingStateDiffResponse
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage

public protocol BlockContextContractsContractStorage {
    func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws -> GetContractStorageResponse
    
    var normalized: BlockContextContractsContractStorageNormalized { get }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage/normalized

public protocol BlockContextContractsContractStorageNormalized {
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractStorageGetConfiguration) async throws -> GetContractNormalizedStorageResponse
}

// MARK: ../<block_id>/context/delegates

public protocol BlockContextDelegates {
    func callAsFunction(pkh: KeyHash.Public) -> BlockContextDelegatesDelegate
}

// MARK: ../<block_id>/context/delegates/<pkh>

public protocol BlockContextDelegatesDelegate {
    func get(configuredWith configuration: BlockContextDelegatesDelegateGetConfiguration) async throws -> GetDelegateDetailsResponse
    
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

// MARK: ../<block_id>/context/delegates/current_frozen_deposits

public protocol BlockContextDelegatesCurrentFrozenDeposits {
    func get(configuredWith configuration: BlockContextDelegatesCurrentFrozenDepositsGetConfiguration) async throws -> GetDelegateCurrentFrozenDepositsResponse
}

// MARK: ../<block_id>/context/delegates/deactivated

public protocol BlockContextDelegatesDeactivated {
    func get(configuredWith configuration: BlockContextDelegatesDeactivatedGetConfiguration) async throws -> GetDelegateDeactivatedStatusResponse
}

// MARK: ../<block_id>/context/delegates/delegated_balance

public protocol BlockContextDelegatesDelegatedBalance {
    func get(configuredWith configuration: BlockContextDelegatesDelegatedBalanceGetConfiguration) async throws -> GetDelegateDelegatedBalanceResponse
}

// MARK: ../<block_id>/context/delegates/delegated_contracts

public protocol BlockContextDelegatesDelegatedContracts {
    func get(configuredWith configuration: BlockContextDelegatesDelegatedContractsGetConfiguration) async throws -> GetDelegateDelegatedContractsResponse
}

// MARK: ../<block_id>/context/delegates/frozen_deposits

public protocol BlockContextDelegatesFrozenDeposits {
    func get(configuredWith configuration: BlockContextDelegatesFrozenDepositsGetConfiguration) async throws -> GetDelegateFrozenDepositsResponse
}

// MARK: ../<block_id>/context/delegates/frozen_deposits_limit

public protocol BlockContextDelegatesFrozenDeposistsLimit {
    func get(configuredWith configuration: BlockContextDelegatesFrozenDeposistsLimitGetConfiguration) async throws -> GetDelegateFrozenDepositsLimitResponse
}

// MARK: ../<block_id>/context/delegates/full_balance

public protocol BlockContextDelegatesFullBalance {
    func get(configuredWith configuration: BlockContextDelegatesFullBalanceGetConfiguration) async throws -> GetDelegateFullBalanceResponse
}

// MARK: ../<block_id>/context/delegates/grace_period

public protocol BlockContextDelegatesGracePeriod {
    func get(configuredWith configuration: BlockContextDelegatesGracePeriodGetConfiguration) async throws -> GetDelegateGracePeriodResponse
}

// MARK: ../<block_id>/context/delegates/participation

public protocol BlockContextDelegatesParticipation {
    func get(configuredWith configuration: BlockContextDelegatesParticipationGetConfiguration) async throws -> GetDelegateParticipationResponse
}

// MARK: ../<block_id>/context/delegates/staking_balance

public protocol BlockContextDelegatesStakingBalance {
    func get(configuredWith configuration: BlockContextDelegatesStakingBalanceGetConfiguration) async throws -> GetDelegateStakingBalanceResponse
}

// MARK: ../<block_id>/context/delegates/voting_power

public protocol BlockContextDelegatesVotingPower {
    func get(configuredWith configuration: BlockContextDelegatesVotingPowerGetConfiguration) async throws -> GetDelegateVotingPowerResponse
}

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
    func get(configuredWith configuration: BlockContextSaplingStateGetDiffGetConfiguration) async throws -> GetSaplingStateDiffResponse
}

// MARK: ../<block_id>/header

public protocol BlockHeader {
    func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws -> GetBlockHeaderResponse
}

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
    func post(operations: [RPCApplicableOperation], configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration) async throws -> PreapplyOperationsResponse
}

// MARK: ../<block_id>/helpers/scripts

public protocol BlockHelpersScripts {
    var runOperation: BlockHelpersScriptsRunOperation { get }
}

// MARK: ../<block_id>/helpers/scripts/run_operation

public protocol BlockHelpersScriptsRunOperation {
    func post(operation: RPCRunnableOperation, configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration) async throws -> RunOperationResponse
}

// MARK: ../<block_id>/operations

public protocol BlockOperations {
    func get(configuredWith configuration: BlockOperationsGetConfiguration) async throws -> GetBlockOperationsResponse
}
