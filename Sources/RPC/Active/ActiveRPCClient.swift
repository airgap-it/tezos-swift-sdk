//
//  ActiveRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

struct ActiveSimplifiedRPCClient: ActiveSimplifiedRPC {
    private let chains: Chains
    
    func getBlock(chainID: String, blockID: String, configuredWith configuration: GetBlockConfiguration) async throws -> GetBlockResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).get(configuredWith: configuration)
    }
    
    func getBigMap(
        chainID: String,
        blockID: String,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration
    ) async throws -> GetBigMapResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.bigMaps(bigMapID: bigMapID).get(configuredWith: configuration)
    }
    func getBigMapValue(
        chainID: String,
        blockID: String,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration
    ) async throws -> GetBigMapValueResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.bigMaps(bigMapID: bigMapID)(scriptExpr: key).get(configuredWith: configuration)
    }
    
    func getConstants(chainID: String, blockID: String, configuredWith configuration: GetConstantsConfiguration) async throws -> GetConstantsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.constants.get(configuredWith: configuration)
    }
    
    func getContractDetails(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetContractDetailsConfiguration) async
    throws -> GetContractDetailsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).get(configuredWith: configuration)
    }
    func getBalance(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetBalanceConfiguration) async
    throws -> GetContractBalanceResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).balance.get(configuredWith: configuration)
    }
    func getCounter(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetCounterConfiguration) async
    throws -> GetContractCounterResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).counter.get(configuredWith: configuration)
    }
    func getDelegate(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetDelegateConfiguration) async
    throws -> GetContractDelegateResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).delegate.get(configuredWith: configuration)
    }
    func getEntrypoints(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetEntrypointsConfiguration) async
    throws -> GetContractEntrypointsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).entrypoints.get(configuredWith: configuration)
    }
    func getEntrypoint(
        chainID: String,
        blockID: String,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration
    ) async throws -> GetContractEntrypointResponse {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context
            .contracts(contractID: contractID)
            .entrypoints(string: entrypoint)
            .get(configuredWith: configuration)
    }
    func getManagerKey(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetManagerKeyConfiguration) async
    throws -> GetContractManagerKeyResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).managerKey.get(configuredWith: configuration)
    }
    func getScript(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetScriptConfiguration) async
    throws -> GetContractNormalizedScriptResponse {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context.contracts(contractID: contractID)
            .script
            .normalized
            .post(unparsingMode: configuration.unparsingMode, configuredWith: .init(headers: configuration.headers))
    }
    func getSaplingStateDiff(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetSaplingStateDiffConfiguration) async
    throws -> GetContractSaplingStateDiffResponse {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context
            .contracts(contractID: contractID)
            .singleSaplingGetDiff
            .get(configuredWith: configuration)
    }
    func getStorage(
        chainID: String,
        blockID: String,
        contractID: Address, configuredWith
        configuration: GetStorageConfiguration) async
    throws -> GetContractNormalizedStorageResponse {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context
            .contracts(contractID: contractID)
            .storage
            .normalized
            .post(unparsingMode: configuration.unparsingMode, configuredWith: .init(headers: configuration.headers))
    }
    
    func getDelegateDetails(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> GetDelegateDetailsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).get(configuredWith: configuration)
    }
    func getCurrentFrozenDeposits(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration
    ) async throws -> GetDelegateCurrentFrozenDepositsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).frozenDeposits.get(configuredWith: configuration)
    }
    func isDeactivated(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration
    ) async throws -> GetDelegateDeactivatedStatusResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).deactivated.get(configuredWith: configuration)
    }
    func getDelegatedBalance(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration
    ) async throws -> GetDelegateDelegatedBalanceResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).delegatedBalance.get(configuredWith: configuration)
    }
    func getDelegatedContracts(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration
    ) async throws -> GetDelegateDelegatedContractsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).delegatedContracts.get(configuredWith: configuration)
    }
    func getFrozenDeposits(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration
    ) async throws -> GetDelegateFrozenDepositsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).frozenDeposits.get(configuredWith: configuration)
    }
    func getFrozenDepositsLimit(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration
    ) async throws -> GetDelegateFrozenDepositsLimitResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).frozenDeposits.get(configuredWith: configuration)
    }
    func getFullBalance(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration
    ) async throws -> GetDelegateFullBalanceResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).fullBalance.get(configuredWith: configuration)
    }
    func getGracePeriod(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration
    ) async throws -> GetDelegateGracePeriodResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).gracePeriod.get(configuredWith: configuration)
    }
    func getParticipation(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration
    ) async throws -> GetDelegateParticipationResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).participation.get(configuredWith: configuration)
    }
    func getStakingBalance(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration
    ) async throws -> GetDelegateStakingBalanceResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).stakingBalance.get(configuredWith: configuration)
    }
    func getVotingPower(
        chainID: String,
        blockID: String,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration
    ) async throws -> GetDelegateVotingPowerResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).votingPower.get(configuredWith: configuration)
    }
    
    func getSaplingStateDiff(
        chainID: String,
        blockID: String,
        stateID: String, configuredWith
        configuration: GetSaplingStateDiffConfiguration) async
    throws -> GetSaplingStateDiffResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.sapling(stateID: stateID).getDiff.get(configuredWith: configuration)
    }
    
    func getBlockHeader(chainID: String, blockID: String, configuredWith configuration: GetBlockHeaderConfiguration) async throws -> GetBlockHeaderResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).header.get(configuredWith: configuration)
    }
    
    func preapplyOperations(
        _ operations: [RPCApplicableOperation]
        , chainID: String,
        blockID: String,
        configuredWith configuration: PreapplyOperationsConfiguration
    ) async throws -> PreapplyOperationsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).helpers.preapply.operations.post(operations: operations, configuredWith: configuration)
    }
    func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: String,
        blockID: String,
        configuredWith configuration: RunOperationConfiguration
    ) async throws -> RunOperationResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).helpers.scripts.runOperation.post(operation: operation, configuredWith: configuration)
    }
    
    func getOperations(chainID: String, blockID: String, configuredWith configuration: GetOperationsConfiguration) async throws -> GetBlockOperationsResponse {
        try await chains(chainID: chainID).blocks(blockID: blockID).operations.get(configuredWith: configuration)
    }
}
