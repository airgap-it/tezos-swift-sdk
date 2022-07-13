//
//  ActiveRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

public extension ActiveSimplifiedRPC {
    func getBlock(chainID: String, blockID: String) async throws -> GetBlockResponse {
        try await getBlock(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getBlock(chainID: ChainID, blockID: Int, configuredWith configuration: GetBlockConfiguration = .init()) async throws -> GetBlockResponse {
        try await getBlock(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getBlock(chainID: ChainID, blockID: BlockHash, configuredWith configuration: GetBlockConfiguration = .init()) async throws -> GetBlockResponse {
        try await getBlock(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func getBigMap(chainID: String, blockID: String, bigMapID: String) async throws -> GetBigMapResponse {
        try await getBigMap(chainID: chainID, blockID: blockID, bigMapID: bigMapID, configuredWith: .init())
    }
    
    func getBigMap(
        chainID: ChainID,
        blockID: Int,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration = .init()
    ) async throws -> GetBigMapResponse {
        try await getBigMap(chainID: chainID.base58, blockID: .init(blockID), bigMapID: bigMapID, configuredWith: configuration)
    }
    
    func getBigMap(
        chainID: ChainID,
        blockID: BlockHash,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration = .init()
    ) async throws -> GetBigMapResponse {
        try await getBigMap(chainID: chainID.base58, blockID: blockID.base58, bigMapID: bigMapID, configuredWith: configuration)
    }
    
    func getBigMapValue(chainID: String, blockID: String, bigMapID: String, key: ScriptExprHash) async throws -> GetBigMapValueResponse {
        try await getBigMapValue(chainID: chainID, blockID: blockID, bigMapID: bigMapID, key: key, configuredWith: .init())
    }
    
    func getBigMapValue(
        chainID: ChainID,
        blockID: Int,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration = .init()
    ) async throws -> GetBigMapValueResponse {
        try await getBigMapValue(chainID: chainID.base58, blockID: .init(blockID), bigMapID: bigMapID, key: key, configuredWith: configuration)
    }
    
    func getBigMapValue(
        chainID: ChainID,
        blockID: BlockHash,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration = .init()
    ) async throws -> GetBigMapValueResponse {
        try await getBigMapValue(chainID: chainID.base58, blockID: blockID.base58, bigMapID: bigMapID, key: key, configuredWith: configuration)
    }
    
    func getConstants(chainID: String, blockID: String) async throws -> GetConstantsResponse {
        try await getConstants(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getConstants(chainID: ChainID, blockID: Int, configuredWith configuration: GetConstantsConfiguration = .init()) async throws -> GetConstantsResponse {
        try await getConstants(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getConstants(
        chainID: ChainID,
        blockID: BlockHash,
        configuredWith configuration: GetConstantsConfiguration = .init()
    ) async throws -> GetConstantsResponse {
        try await getConstants(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func getContractDetails(chainID: String, blockID: String, contractID: Address) async throws -> GetContractDetailsResponse {
        try await getContractDetails(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getContractDetails(
        chainID: ChainID,
        blockID: Int,
        contractID: Address,
        configuredWith configuration: GetContractDetailsConfiguration = .init()
    ) async throws -> GetContractDetailsResponse {
        try await getContractDetails(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getContractDetails(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address,
        configuredWith configuration: GetContractDetailsConfiguration = .init()
    ) async throws -> GetContractDetailsResponse {
        try await getContractDetails(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getBalance(chainID: String, blockID: String, contractID: Address) async throws -> GetContractBalanceResponse {
        try await getBalance(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getBalance(
        chainID: ChainID,
        blockID: Int,
        contractID: Address, configuredWith
        configuration: GetBalanceConfiguration = .init()
    ) async throws -> GetContractBalanceResponse {
        try await getBalance(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getBalance(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address, configuredWith
        configuration: GetBalanceConfiguration = .init()
    ) async throws -> GetContractBalanceResponse {
        try await getBalance(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getCounter(chainID: String, blockID: String, contractID: Address) async throws -> GetContractCounterResponse {
        try await getCounter(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getCounter(
        chainID: ChainID,
        blockID: Int,
        contractID: Address, configuredWith
        configuration: GetCounterConfiguration = .init()
    ) async throws -> GetContractCounterResponse {
        try await getCounter(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getCounter(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address, configuredWith
        configuration: GetCounterConfiguration = .init()
    ) async throws -> GetContractCounterResponse {
        try await getCounter(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getDelegate(chainID: String, blockID: String, contractID: Address) async throws -> GetContractDelegateResponse {
        try await getDelegate(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getDelegate(
        chainID: ChainID,
        blockID: Int,
        contractID: Address, configuredWith
        configuration: GetDelegateConfiguration = .init()
    ) async throws -> GetContractDelegateResponse {
        try await getDelegate(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getDelegate(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address, configuredWith
        configuration: GetDelegateConfiguration = .init()
    ) async throws -> GetContractDelegateResponse {
        try await getDelegate(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getEntrypoints(chainID: String, blockID: String, contractID: Address) async throws -> GetContractEntrypointsResponse {
        try await getEntrypoints(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getEntrypoints(
        chainID: ChainID,
        blockID: Int,
        contractID: Address,
        configuredWith configuration: GetEntrypointsConfiguration = .init()
    ) async throws -> GetContractEntrypointsResponse {
        try await getEntrypoints(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getEntrypoints(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address,
        configuredWith configuration: GetEntrypointsConfiguration = .init()
    ) async throws -> GetContractEntrypointsResponse {
        try await getEntrypoints(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getEntrypoint(chainID: String, blockID: String, entrypoint: String, contractID: Address) async throws -> GetContractEntrypointResponse {
        try await getEntrypoint(chainID: chainID, blockID: blockID, contractID: contractID, entrypoint: entrypoint, configuredWith: .init())
    }
    
    func getEntrypoint(
        chainID: ChainID,
        blockID: Int,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration = .init()
    ) async throws -> GetContractEntrypointResponse {
        try await getEntrypoint(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, entrypoint: entrypoint, configuredWith: configuration)
    }
    
    func getEntrypoint(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration = .init()
    ) async throws -> GetContractEntrypointResponse {
        try await getEntrypoint(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, entrypoint: entrypoint, configuredWith: configuration)
    }
    
    func getManagerKey(chainID: String, blockID: String, contractID: Address) async throws -> GetContractManagerKeyResponse {
        try await getManagerKey(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getManagerKey(
        chainID: ChainID,
        blockID: Int,
        contractID: Address, configuredWith
        configuration: GetManagerKeyConfiguration = .init()
    ) async throws -> GetContractManagerKeyResponse {
        try await getManagerKey(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getManagerKey(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address, configuredWith
        configuration: GetManagerKeyConfiguration = .init()
    ) async throws -> GetContractManagerKeyResponse {
        try await getManagerKey(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getScript(chainID: String, blockID: String, contractID: Address) async throws -> GetContractNormalizedScriptResponse {
        try await getScript(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getScript(
        chainID: ChainID,
        blockID: Int,
        contractID: Address, configuredWith
        configuration: GetScriptConfiguration = .init()
    ) async throws -> GetContractNormalizedScriptResponse {
        try await getScript(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getScript(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address, configuredWith
        configuration: GetScriptConfiguration = .init()
    ) async throws -> GetContractNormalizedScriptResponse {
        try await getScript(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(chainID: String, blockID: String, contractID: Address) async throws -> GetContractSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(
        chainID: ChainID,
        blockID: Int,
        contractID: Address, configuredWith
        configuration: GetSaplingStateDiffConfiguration = .init()
    ) async throws -> GetContractSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address, configuredWith
        configuration: GetSaplingStateDiffConfiguration = .init()
    ) async throws -> GetContractSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getStorage(chainID: String, blockID: String, contractID: Address) async throws -> GetContractNormalizedStorageResponse {
        try await getStorage(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getStorage(
        chainID: ChainID,
        blockID: Int,
        contractID: Address, configuredWith
        configuration: GetStorageConfiguration = .init()
    ) async throws -> GetContractNormalizedStorageResponse {
        try await getStorage(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getStorage(
        chainID: ChainID,
        blockID: BlockHash,
        contractID: Address, configuredWith
        configuration: GetStorageConfiguration = .init()
    ) async throws -> GetContractNormalizedStorageResponse {
        try await getStorage(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getDelegateDetails(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateDetailsResponse {
        try await getDelegateDetails(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegateDetails(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration = .init()
    ) async throws -> GetDelegateDetailsResponse {
        try await getDelegateDetails(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegateDetails(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration = .init()
    ) async throws -> GetDelegateDetailsResponse {
        try await getDelegateDetails(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getCurrentFrozenDeposits(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateCurrentFrozenDepositsResponse {
        try await getCurrentFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getCurrentFrozenDeposits(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration = .init()
    ) async throws -> GetDelegateCurrentFrozenDepositsResponse {
        try await getCurrentFrozenDeposits(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getCurrentFrozenDeposits(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration = .init()
    ) async throws -> GetDelegateCurrentFrozenDepositsResponse {
        try await getCurrentFrozenDeposits(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func isDeactivated(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateDeactivatedStatusResponse {
        try await isDeactivated(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func isDeactivated(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration = .init()
    ) async throws -> GetDelegateDeactivatedStatusResponse {
        try await isDeactivated(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func isDeactivated(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration = .init()
    ) async throws -> GetDelegateDeactivatedStatusResponse {
        try await isDeactivated(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedBalance(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateDelegatedBalanceResponse {
        try await getDelegatedBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedBalance(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration = .init()
    ) async throws -> GetDelegateDelegatedBalanceResponse {
        try await getDelegatedBalance(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedBalance(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration = .init()
    ) async throws -> GetDelegateDelegatedBalanceResponse {
        try await getDelegatedBalance(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedContracts(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateDelegatedContractsResponse {
        try await getDelegatedContracts(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedContracts(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration = .init()
    ) async throws -> GetDelegateDelegatedContractsResponse {
        try await getDelegatedContracts(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedContracts(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration = .init()
    ) async throws -> GetDelegateDelegatedContractsResponse {
        try await getDelegatedContracts(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDeposits(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateFrozenDepositsResponse {
        try await getFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDeposits(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration = .init()
    ) async throws -> GetDelegateFrozenDepositsResponse {
        try await getFrozenDeposits(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDeposits(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration = .init()
    ) async throws -> GetDelegateFrozenDepositsResponse {
        try await getFrozenDeposits(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDepositsLimit(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateFrozenDepositsLimitResponse {
        try await getFrozenDepositsLimit(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDepositsLimit(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration = .init()
    ) async throws -> GetDelegateFrozenDepositsLimitResponse {
        try await getFrozenDepositsLimit(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDepositsLimit(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration = .init()
    ) async throws -> GetDelegateFrozenDepositsLimitResponse {
        try await getFrozenDepositsLimit(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFullBalance(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateFullBalanceResponse {
        try await getFullBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFullBalance(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration = .init()
    ) async throws -> GetDelegateFullBalanceResponse {
        try await getFullBalance(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFullBalance(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration = .init()
    ) async throws -> GetDelegateFullBalanceResponse {
        try await getFullBalance(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getGracePeriod(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateGracePeriodResponse {
        try await getGracePeriod(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getGracePeriod(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration = .init()
    ) async throws -> GetDelegateGracePeriodResponse {
        try await getGracePeriod(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getGracePeriod(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration = .init()
    ) async throws -> GetDelegateGracePeriodResponse {
        try await getGracePeriod(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getParticipation(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateParticipationResponse {
        try await getParticipation(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getParticipation(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration = .init()
    ) async throws -> GetDelegateParticipationResponse {
        try await getParticipation(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getParticipation(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration = .init()
    ) async throws -> GetDelegateParticipationResponse {
        try await getParticipation(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getStakingBalance(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateStakingBalanceResponse {
        try await getStakingBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getStakingBalance(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration = .init()
    ) async throws -> GetDelegateStakingBalanceResponse {
        try await getStakingBalance(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getStakingBalance(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration = .init()
    ) async throws -> GetDelegateStakingBalanceResponse {
        try await getStakingBalance(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getVotingPower(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws -> GetDelegateVotingPowerResponse {
        try await getVotingPower(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getVotingPower(
        chainID: ChainID,
        blockID: Int,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration = .init()
    ) async throws -> GetDelegateVotingPowerResponse {
        try await getVotingPower(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getVotingPower(
        chainID: ChainID,
        blockID: BlockHash,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration = .init()
    ) async throws -> GetDelegateVotingPowerResponse {
        try await getVotingPower(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(chainID: String, blockID: String, stateID: String) async throws -> GetSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, stateID: stateID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(
        chainID: ChainID,
        blockID: Int,
        stateID: String, configuredWith
        configuration: GetSaplingStateDiffConfiguration = .init()
    ) async throws -> GetSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: .init(blockID), stateID: stateID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(
        chainID: ChainID,
        blockID: BlockHash,
        stateID: String, configuredWith
        configuration: GetSaplingStateDiffConfiguration = .init()
    ) async throws -> GetSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: blockID.base58, stateID: stateID, configuredWith: configuration)
    }
    
    func getBlockHeader(chainID: String, blockID: String) async throws -> GetBlockHeaderResponse {
        try await getBlockHeader(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getBlockHeader(
        chainID: ChainID,
        blockID: Int,
        configuredWith configuration: GetBlockHeaderConfiguration = .init()
    ) async throws -> GetBlockHeaderResponse {
        try await getBlockHeader(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getBlockHeader(
        chainID: ChainID,
        blockID: BlockHash,
        configuredWith configuration: GetBlockHeaderConfiguration = .init()
    ) async throws -> GetBlockHeaderResponse {
        try await getBlockHeader(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func preapplyOperations(_ operations: [RPCApplicableOperation], chainID: String, blockID: String) async throws -> PreapplyOperationsResponse {
        try await preapplyOperations(operations, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func preapplyOperations(
        _ operations: [RPCApplicableOperation],
        chainID: ChainID,
        blockID: Int,
        configuredWith configuration: PreapplyOperationsConfiguration = .init()
    ) async throws -> PreapplyOperationsResponse {
        try await preapplyOperations(operations, chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func preapplyOperations(
        _ operations: [RPCApplicableOperation],
        chainID: ChainID,
        blockID: BlockHash,
        configuredWith configuration: PreapplyOperationsConfiguration = .init()
    ) async throws -> PreapplyOperationsResponse {
        try await preapplyOperations(operations, chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func runOperation(_ operation: RPCRunnableOperation, chainID: String, blockID: String) async throws -> RunOperationResponse {
        try await runOperation(operation, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: ChainID,
        blockID: Int,
        configuredWith configuration: RunOperationConfiguration = .init()
    ) async throws -> RunOperationResponse {
        try await runOperation(operation, chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: ChainID,
        blockID: BlockHash,
        configuredWith configuration: RunOperationConfiguration = .init()
    ) async throws -> RunOperationResponse {
        try await runOperation(operation, chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func getOperations(chainID: String, blockID: String) async throws -> GetBlockOperationsResponse {
        try await getOperations(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getOperations(chainID: ChainID, blockID: Int, configuredWith configuration: GetOperationsConfiguration = .init()) async throws -> GetBlockOperationsResponse {
        try await getOperations(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getOperations(chainID: ChainID, blockID: BlockHash, configuredWith configuration: GetOperationsConfiguration = .init()) async throws -> GetBlockOperationsResponse {
        try await getOperations(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
}
