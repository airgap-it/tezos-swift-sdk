//
//  ActiveRPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import Foundation
import TezosCore

public protocol ActiveSimplifiedRPC {
    func getBlock(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetBlockConfiguration) async throws -> GetBlockResponse
    
    func getBigMap(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration
    ) async throws -> GetBigMapResponse
    func getBigMapValue(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration
    ) async throws -> GetBigMapValueResponse
    
    func getConstants(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetConstantsConfiguration) async throws -> GetConstantsResponse
    
    func getContractDetails(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> GetContractDetailsResponse
    func getBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetBalanceConfiguration
    ) async throws -> GetContractBalanceResponse
    func getCounter(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetCounterConfiguration
    ) async throws -> GetContractCounterResponse
    func getDelegate(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetDelegateConfiguration
    ) async throws -> GetContractDelegateResponse
    func getEntrypoints(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetEntrypointsConfiguration
    ) async throws -> GetContractEntrypointsResponse
    func getEntrypoint(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration
    ) async throws -> GetContractEntrypointResponse
    func getManagerKey(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetManagerKeyConfiguration
    ) async throws -> GetContractManagerKeyResponse
    func getScript(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetScriptConfiguration
    ) async throws -> GetContractNormalizedScriptResponse
    func getSaplingStateDiff(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> GetContractSaplingStateDiffResponse
    func getStorage(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetStorageConfiguration
    ) async throws -> GetContractNormalizedStorageResponse
    
    func getDelegateDetails(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> GetDelegateDetailsResponse
    func getCurrentFrozenDeposits(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration
    ) async throws -> GetDelegateCurrentFrozenDepositsResponse
    func isDeactivated(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration
    ) async throws -> GetDelegateDeactivatedStatusResponse
    func getDelegatedBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration
    ) async throws -> GetDelegateDelegatedBalanceResponse
    func getDelegatedContracts(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration
    ) async throws -> GetDelegateDelegatedContractsResponse
    func getFrozenDeposits(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration
    ) async throws -> GetDelegateFrozenDepositsResponse
    func getFrozenDepositsLimit(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration
    ) async throws -> GetDelegateFrozenDepositsLimitResponse
    func getFullBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration
    ) async throws -> GetDelegateFullBalanceResponse
    func getGracePeriod(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration
    ) async throws -> GetDelegateGracePeriodResponse
    func getParticipation(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration
    ) async throws -> GetDelegateParticipationResponse
    func getStakingBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration
    ) async throws -> GetDelegateStakingBalanceResponse
    func getVotingPower(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration
    ) async throws -> GetDelegateVotingPowerResponse
    
    func getSaplingStateDiff(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        stateID: String,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> GetSaplingStateDiffResponse
    
    func getBlockHeader(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetBlockHeaderConfiguration) async throws -> GetBlockHeaderResponse
    
    func preapplyOperations(
        _ operations: [RPCApplicableOperation],
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: PreapplyOperationsConfiguration
    ) async throws -> PreapplyOperationsResponse
    func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: RunOperationConfiguration
    ) async throws -> RunOperationResponse
    
    func getOperations(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetOperationsConfiguration) async throws -> GetBlockOperationsResponse
}
