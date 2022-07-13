//
//  ActiveRPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import Foundation
import TezosCore

public protocol ActiveSimplifiedRPC {
    func getBlock(chainID: String, blockID: String, configuredWith configuration: GetBlockConfiguration) async throws -> GetBlockResponse
    
    func getBigMap(
        chainID: String,
        blockID: String,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration
    ) async throws -> GetBigMapResponse
    func getBigMapValue(
        chainID: String,
        blockID: String,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration
    ) async throws -> GetBigMapValueResponse
    
    func getConstants(chainID: String, blockID: String, configuredWith configuration: GetConstantsConfiguration) async throws -> GetConstantsResponse
    
    func getContractDetails(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> GetContractDetailsResponse
    func getBalance(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetBalanceConfiguration
    ) async throws -> GetContractBalanceResponse
    func getCounter(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetCounterConfiguration
    ) async throws -> GetContractCounterResponse
    func getDelegate(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetDelegateConfiguration
    ) async throws -> GetContractDelegateResponse
    func getEntrypoints(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetEntrypointsConfiguration
    ) async throws -> GetContractEntrypointsResponse
    func getEntrypoint(
        chainID: String,
        blockID: String,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration
    ) async throws -> GetContractEntrypointResponse
    func getManagerKey(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetManagerKeyConfiguration
    ) async throws -> GetContractManagerKeyResponse
    func getScript(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetScriptConfiguration
    ) async throws -> GetContractNormalizedScriptResponse
    func getSaplingStateDiff(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> GetContractSaplingStateDiffResponse
    func getStorage(
        chainID: String,
        blockID: String,
        contractID: Address,
        configuredWith configuration: GetStorageConfiguration
    ) async throws -> GetContractNormalizedStorageResponse
    
    func getDelegateDetails(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> GetDelegateDetailsResponse
    func getCurrentFrozenDeposits(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration
    ) async throws -> GetDelegateCurrentFrozenDepositsResponse
    func isDeactivated(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration
    ) async throws -> GetDelegateDeactivatedStatusResponse
    func getDelegatedBalance(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration
    ) async throws -> GetDelegateDelegatedBalanceResponse
    func getDelegatedContracts(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration
    ) async throws -> GetDelegateDelegatedContractsResponse
    func getFrozenDeposits(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration
    ) async throws -> GetDelegateFrozenDepositsResponse
    func getFrozenDepositsLimit(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration
    ) async throws -> GetDelegateFrozenDepositsLimitResponse
    func getFullBalance(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration
    ) async throws -> GetDelegateFullBalanceResponse
    func getGracePeriod(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration
    ) async throws -> GetDelegateGracePeriodResponse
    func getParticipation(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration
    ) async throws -> GetDelegateParticipationResponse
    func getStakingBalance(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration
    ) async throws -> GetDelegateStakingBalanceResponse
    func getVotingPower(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration
    ) async throws -> GetDelegateVotingPowerResponse
    
    func getSaplingStateDiff(
        chainID: String,
        blockID: String,
        stateID: String,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> GetSaplingStateDiffResponse
    
    func getBlockHeader(chainID: String, blockID: String, configuredWith configuration: GetBlockHeaderConfiguration) async throws -> GetBlockHeaderResponse
    
    func preapplyOperations(
        _ operations: [RPCApplicableOperation],
        chainID: String,
        blockID: String,
        configuredWith configuration: PreapplyOperationsConfiguration
    ) async throws -> PreapplyOperationsResponse
    func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: String,
        blockID: String,
        configuredWith configuration: RunOperationConfiguration
    ) async throws -> RunOperationResponse
    
    func getOperations(chainID: String, blockID: String, configuredWith configuration: GetOperationsConfiguration) async throws -> GetBlockOperationsResponse
}
