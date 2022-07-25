//
//  BlockRPC.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore
import TezosMichelson
import TezosOperation

// MARK: ../<block_id>

public protocol Block {
    associatedtype ContextRPC: BlockContext
    associatedtype HeaderRPC: BlockHeader
    associatedtype HelpersRPC: BlockHelpers
    associatedtype OperationsRPC: BlockOperations
    
    func get(configuredWith configuration: BlockGetConfiguration) async throws -> RPCBlock
    
    var context: ContextRPC { get }
    var header: HeaderRPC { get }
    var helpers: HelpersRPC { get }
    var operations: OperationsRPC { get }
}

// MARK: ../<block_id>/context

public protocol BlockContext {
    associatedtype BigMapsRPC: BlockContextBigMaps
    associatedtype ConstantsRPC: BlockContextConstants
    associatedtype ContractsRPC: BlockContextContracts
    associatedtype DelegatesRPC: BlockContextDelegates
    associatedtype SaplingRPC: BlockContextSapling
    
    var bigMaps: BigMapsRPC { get }
    var constants: ConstantsRPC { get }
    var contracts: ContractsRPC { get }
    var delegates: DelegatesRPC { get }
    var sapling: SaplingRPC { get }
}

// MARK: ../<block_id>/context/big_maps

public protocol BlockContextBigMaps {
    associatedtype BigMapRPC: BlockContextBigMapsBigMap
    
    func callAsFunction(bigMapID: String) -> BigMapRPC
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>

public protocol BlockContextBigMapsBigMap {
    associatedtype ValueRPC: BlockContextBigMapsBigMapValue
    
    func get(configuredWith configuration: BlockContextBigMapsBigMapGetConfiguration) async throws -> [Micheline]
    
    func callAsFunction(scriptExpr: ScriptExprHash) -> ValueRPC
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>/value

public protocol BlockContextBigMapsBigMapValue {
    func get(configuredWith configuration: BlockContextBigMapsBigMapValueGetConfiguration) async throws -> Micheline?
}

// MARK: ../<block_id>/context/constants

public protocol BlockContextConstants {
    func get(configuredWith configuration: BlockContextConstantsGetConfiguration) async throws -> RPCConstants
}

// MARK: ../<block_id>/context/contracts

public protocol BlockContextContracts {
    associatedtype ContractRPC: BlockContextContractsContract
    
    func callAsFunction(contractID: Address) -> ContractRPC
}

// MARK: ../<block_id>/context/contracts/<contract_id>

public protocol BlockContextContractsContract {
    associatedtype BalanceRPC: BlockContextContractsContractBalance
    associatedtype CounterRPC: BlockContextContractsContractCounter
    associatedtype DelegateRPC: BlockContextContractsContractDelegate
    associatedtype EntrypointsRPC: BlockContextContractsContractEntrypoints
    associatedtype ManagerKeyRPC: BlockContextContractsContractManagerKey
    associatedtype ScriptRPC: BlockContextContractsContractScript
    associatedtype SingleSaplingGetDiffRPC: BlockContextContractsContractSingleSaplingGetDiff
    associatedtype StorageRPC: BlockContextContractsContractStorage
    
    func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws -> RPCContractDetails
    
    var balance: BalanceRPC { get }
    var counter: CounterRPC { get }
    var delegate: DelegateRPC { get }
    var entrypoints: EntrypointsRPC { get }
    var managerKey: ManagerKeyRPC { get }
    var script: ScriptRPC { get }
    var singleSaplingGetDiff: SingleSaplingGetDiffRPC { get }
    var storage: StorageRPC { get }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/balance

public protocol BlockContextContractsContractBalance {
    func get(configuredWith configuration: BlockContextContractsContractBalanceGetConfiguration) async throws -> String
}

// MARK: ../<block_id>/context/contracts/<contract_id>/counter

public protocol BlockContextContractsContractCounter {
    func get(configuredWith configuration: BlockContextContractsContractCounterGetConfiguration) async throws -> String?
}

// MARK: ../<block_id>/context/contracts/<contract_id>/delegate

public protocol BlockContextContractsContractDelegate {
    func get(configuredWith configuration: BlockContextContractsContractDelegateGetConfiguration) async throws -> Address.Implicit?
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints

public protocol BlockContextContractsContractEntrypoints {
    associatedtype EntrypointRPC: BlockContextContractsContractEntrypointsEntrypoint
    
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsGetConfiguration) async throws -> RPCContractEntrypoints
    
    func callAsFunction(string: String) -> EntrypointRPC
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints/<string>

public protocol BlockContextContractsContractEntrypointsEntrypoint {
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsEntrypointGetConfiguration) async throws -> Micheline
}

// MARK: ../<block_id>/context/contracts/<contract_id>/manager_key

public protocol BlockContextContractsContractManagerKey {
    func get(configuredWith configuration: BlockContextContractsContractManagerKeyGetConfiguration) async throws -> Key.Public?
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script

public protocol BlockContextContractsContractScript {
    associatedtype NormalizedRPC: BlockContextContractsContractScriptNormalized
    
    func get(configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws -> Script?
    
    var normalized: NormalizedRPC { get }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script/normalized

public protocol BlockContextContractsContractScriptNormalized {
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws -> Script?
}

// MARK: ../<block_id>/context/contracts/<contract_id>/single_sapling_get_diff

public protocol BlockContextContractsContractSingleSaplingGetDiff {
    func get(configuredWith configuration: BlockContextContractsContractSingleSaplingGetDiffGetConfiguration) async throws -> RPCSaplingStateDiff
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage

public protocol BlockContextContractsContractStorage {
    associatedtype NormalizedRPC: BlockContextContractsContractStorageNormalized
    
    func get(configuredWith configuration: BlockContextContractsContractStorageNormalizedPostConfiguration) async throws -> Micheline?
    
    var normalized: NormalizedRPC { get }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage/normalized

public protocol BlockContextContractsContractStorageNormalized {
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractStorageGetConfiguration) async throws -> Micheline?
}

// MARK: ../<block_id>/context/delegates

public protocol BlockContextDelegates {
    associatedtype DelegateRPC: BlockContextDelegatesDelegate
    
    func callAsFunction(pkh: KeyHash.Public) -> DelegateRPC
}

// MARK: ../<block_id>/context/delegates/<pkh>

public protocol BlockContextDelegatesDelegate {
    associatedtype CurrentFrozenDepositsRPC: BlockContextDelegatesCurrentFrozenDeposits
    associatedtype DeactivatedRPC: BlockContextDelegatesDeactivated
    associatedtype DelegatedBalanceRPC: BlockContextDelegatesDelegatedBalance
    associatedtype DelegatedContractsRPC: BlockContextDelegatesDelegatedContracts
    associatedtype FrozenDepositsRPC: BlockContextDelegatesFrozenDeposits
    associatedtype FrozenDeposistsLimitRPC: BlockContextDelegatesFrozenDeposistsLimit
    associatedtype FullBalanceRPC: BlockContextDelegatesFullBalance
    associatedtype GracePeriodRPC: BlockContextDelegatesGracePeriod
    associatedtype ParticipationRPC: BlockContextDelegatesParticipation
    associatedtype StakingBalanceRPC: BlockContextDelegatesStakingBalance
    associatedtype VotingPowerRPC: BlockContextDelegatesVotingPower
    
    func get(configuredWith configuration: BlockContextDelegatesDelegateGetConfiguration) async throws -> RPCDelegateDetails
    
    var currentFrozenDeposits: CurrentFrozenDepositsRPC { get }
    var deactivated: DeactivatedRPC { get }
    var delegatedBalance: DelegatedBalanceRPC { get }
    var delegatedContracts: DelegatedContractsRPC { get }
    var frozenDeposits: FrozenDepositsRPC { get }
    var frozenDepositsLimit: FrozenDeposistsLimitRPC { get }
    var fullBalance: FullBalanceRPC { get }
    var gracePeriod: GracePeriodRPC { get }
    var participation: ParticipationRPC { get }
    var stakingBalance: StakingBalanceRPC { get }
    var votingPower: VotingPowerRPC { get }
}

// MARK: ../<block_id>/context/delegates/current_frozen_deposits

public protocol BlockContextDelegatesCurrentFrozenDeposits {
    func get(configuredWith configuration: BlockContextDelegatesCurrentFrozenDepositsGetConfiguration) async throws -> String
}

// MARK: ../<block_id>/context/delegates/deactivated

public protocol BlockContextDelegatesDeactivated {
    func get(configuredWith configuration: BlockContextDelegatesDeactivatedGetConfiguration) async throws -> Bool
}

// MARK: ../<block_id>/context/delegates/delegated_balance

public protocol BlockContextDelegatesDelegatedBalance {
    func get(configuredWith configuration: BlockContextDelegatesDelegatedBalanceGetConfiguration) async throws -> String
}

// MARK: ../<block_id>/context/delegates/delegated_contracts

public protocol BlockContextDelegatesDelegatedContracts {
    func get(configuredWith configuration: BlockContextDelegatesDelegatedContractsGetConfiguration) async throws -> [Address]
}

// MARK: ../<block_id>/context/delegates/frozen_deposits

public protocol BlockContextDelegatesFrozenDeposits {
    func get(configuredWith configuration: BlockContextDelegatesFrozenDepositsGetConfiguration) async throws -> String
}

// MARK: ../<block_id>/context/delegates/frozen_deposits_limit

public protocol BlockContextDelegatesFrozenDeposistsLimit {
    func get(configuredWith configuration: BlockContextDelegatesFrozenDeposistsLimitGetConfiguration) async throws -> String
}

// MARK: ../<block_id>/context/delegates/full_balance

public protocol BlockContextDelegatesFullBalance {
    func get(configuredWith configuration: BlockContextDelegatesFullBalanceGetConfiguration) async throws -> String
}

// MARK: ../<block_id>/context/delegates/grace_period

public protocol BlockContextDelegatesGracePeriod {
    func get(configuredWith configuration: BlockContextDelegatesGracePeriodGetConfiguration) async throws -> Int32
}

// MARK: ../<block_id>/context/delegates/participation

public protocol BlockContextDelegatesParticipation {
    func get(configuredWith configuration: BlockContextDelegatesParticipationGetConfiguration) async throws -> RPCDelegateParticipation
}

// MARK: ../<block_id>/context/delegates/staking_balance

public protocol BlockContextDelegatesStakingBalance {
    func get(configuredWith configuration: BlockContextDelegatesStakingBalanceGetConfiguration) async throws -> String
}

// MARK: ../<block_id>/context/delegates/voting_power

public protocol BlockContextDelegatesVotingPower {
    func get(configuredWith configuration: BlockContextDelegatesVotingPowerGetConfiguration) async throws -> Int32
}

// MARK: ../<block_id>/context/sapling

public protocol BlockContextSapling {
    associatedtype SaplingStateRPC: BlockContextSaplingState
    
    func callAsFunction(stateID: String) -> SaplingStateRPC
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>

public protocol BlockContextSaplingState {
    associatedtype GetDiffRPC: BlockContextSaplingStateGetDiff
    
    var getDiff: GetDiffRPC { get }
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>/get_diff

public protocol BlockContextSaplingStateGetDiff {
    func get(configuredWith configuration: BlockContextSaplingStateGetDiffGetConfiguration) async throws -> RPCSaplingStateDiff
}

// MARK: ../<block_id>/header

public protocol BlockHeader {
    func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws -> RPCFullBlockHeader
}

// MARK: ../<block_id>/helpers

public protocol BlockHelpers {
    associatedtype PreapplyRPC: BlockHelpersPreapply
    associatedtype ScriptsRPC: BlockHelpersScripts
    
    var preapply: PreapplyRPC { get }
    var scripts: ScriptsRPC { get }
}

// MARK: ../<block_id>/helpers/preapply

public protocol BlockHelpersPreapply {
    associatedtype OperationsRPC: BlockHelpersPreapplyOperations
    
    var operations: OperationsRPC { get }
}
// MARK: ../<block_id>/helpers/preapply/operations

public protocol BlockHelpersPreapplyOperations {
    func post(operations: [RPCApplicableOperation], configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration) async throws -> RPCAppliedOperation
}

// MARK: ../<block_id>/helpers/scripts

public protocol BlockHelpersScripts {
    associatedtype RunOperationRPC: BlockHelpersScriptsRunOperation
    
    var runOperation: RunOperationRPC { get }
}

// MARK: ../<block_id>/helpers/scripts/run_operation

public protocol BlockHelpersScriptsRunOperation {
    func post(operation: RPCRunnableOperation, configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration) async throws -> [RPCOperation.Content]
}

// MARK: ../<block_id>/operations

public protocol BlockOperations {
    func get(configuredWith configuration: BlockOperationsGetConfiguration) async throws -> [[RPCOperation]]
}
