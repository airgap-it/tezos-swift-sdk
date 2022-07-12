//
//  ActiveRPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import Foundation
import TezosCore

public protocol ActiveSimplifiedRPC {
    func getBlock(chainID: String, blockID: String, configuredWith configuration: GetBlockConfiguration) async throws
    
    func getBigMap(chainID: String, blockID: String, bigMapID: String, configuredWith configuration: GetBigMapConfiguration) async throws
    func getBigMapValue(chainID: String, blockID: String, bigMapID: String, key: ScriptExprHash, configuredWith configuration: GetBigMapValueConfiguration) async throws
    
    func getConstants(chainID: String, blockID: String, configuredWith configuration: GetConstantsConfiguration) async throws
    
    func getContractDetails(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetContractDetailsConfiguration) async throws
    func getBalance(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetBalanceConfiguration) async throws
    func getCounter(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetCounterConfiguration) async throws
    func getDelegate(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetDelegateConfiguration) async throws
    func getEntrypoints(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetEntrypointsConfiguration) async throws
    func getEntrypoint(chainID: String, blockID: String, contractID: Address, entrypoint: String, configuredWith configuration: GetEntrypointConfiguration) async throws
    func getManagerKey(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetManagerKeyConfiguration) async throws
    func getScript(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetScriptConfiguration) async throws
    func getSaplingStateDiff(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetSaplingStateDiffConfiguration) async throws
    func getStorage(chainID: String, blockID: String, contractID: Address, configuredWith configuration: GetStorageConfiguration) async throws
    
    func getDelegateDetails(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetContractDetailsConfiguration) async throws
    func getCurrentFrozenDeposits(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetCurrentFrozenDepositsConfiguration) async throws
    func isDeactivated(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: IsDeactivatedConfiguration) async throws
    func getDelegatedBalance(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetDelegatedBalanceConfiguration) async throws
    func getDelegatedContracts(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetDelegatedContractsConfiguration) async throws
    func getFrozenDeposits(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetFrozenDepositsConfiguration) async throws
    func getFrozenDepositsLimit(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetFrozenDepositsLimitConfiguration) async throws
    func getFullBalance(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetFullBalanceConfiguration) async throws
    func getGracePeriod(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetGracePeriodConfiguration) async throws
    func getParticipation(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetParticipationConfiguration) async throws
    func getStakingBalance(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetStakingBalanceConfiguration) async throws
    func getVotingPower(chainID: String, blockID: String, delegateID: KeyHash.Public, configuredWith configuration: GetVotingPowerConfiguration) async throws
    
    func getSaplingStateDiff(chainID: String, blockID: String, stateID: String, configuredWith configuration: GetSaplingStateDiffConfiguration) async throws
    
    func getBlockHeader(chainID: String, blockID: String, configuredWith configuration: GetBlockHeaderConfiguration) async throws
    
    func preapplyOperations(_ operations: [RPCApplicableOperation], chainID: String, blockID: String, configuredWith configuration: PreapplyOperationsConfiguration) async throws
    func runOperation(_ operation: RPCRunnableOperation, chainID: String, blockID: String, configuredWith configuration: RunOperationConfiguration) async throws
    
    func getOperations(chainID: String, blockID: String, configuredWith configuration: GetOperationsConfiguration) async throws
}

// MARK: Extensions

public extension ActiveSimplifiedRPC {
    func getBlock(chainID: String, blockID: String) async throws {
        try await getBlock(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getBlock(chainID: ChainID, blockID: Int, configuredWith configuration: GetBlockConfiguration = .init()) async throws {
        try await getBlock(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getBlock(chainID: ChainID, blockID: BlockHash, configuredWith configuration: GetBlockConfiguration = .init()) async throws {
        try await getBlock(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func getBigMap(chainID: String, blockID: String, bigMapID: String) async throws {
        try await getBigMap(chainID: chainID, blockID: blockID, bigMapID: bigMapID, configuredWith: .init())
    }
    
    func getBigMap(chainID: ChainID, blockID: Int, bigMapID: String, configuredWith configuration: GetBigMapConfiguration = .init()) async throws {
        try await getBigMap(chainID: chainID.base58, blockID: .init(blockID), bigMapID: bigMapID, configuredWith: configuration)
    }
    
    func getBigMap(chainID: ChainID, blockID: BlockHash, bigMapID: String, configuredWith configuration: GetBigMapConfiguration = .init()) async throws {
        try await getBigMap(chainID: chainID.base58, blockID: blockID.base58, bigMapID: bigMapID, configuredWith: configuration)
    }
    
    func getBigMapValue(chainID: String, blockID: String, bigMapID: String, key: ScriptExprHash) async throws {
        try await getBigMapValue(chainID: chainID, blockID: blockID, bigMapID: bigMapID, key: key, configuredWith: .init())
    }
    
    func getBigMapValue(chainID: ChainID, blockID: Int, bigMapID: String, key: ScriptExprHash, configuredWith configuration: GetBigMapValueConfiguration = .init()) async throws {
        try await getBigMapValue(chainID: chainID.base58, blockID: .init(blockID), bigMapID: bigMapID, key: key, configuredWith: configuration)
    }
    
    func getBigMapValue(chainID: ChainID, blockID: BlockHash, bigMapID: String, key: ScriptExprHash, configuredWith configuration: GetBigMapValueConfiguration = .init()) async throws {
        try await getBigMapValue(chainID: chainID.base58, blockID: blockID.base58, bigMapID: bigMapID, key: key, configuredWith: configuration)
    }
    
    func getConstants(chainID: String, blockID: String) async throws {
        try await getConstants(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getConstants(chainID: ChainID, blockID: Int, configuredWith configuration: GetConstantsConfiguration = .init()) async throws {
        try await getConstants(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getConstants(chainID: ChainID, blockID: BlockHash, configuredWith configuration: GetConstantsConfiguration = .init()) async throws {
        try await getConstants(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func getContractDetails(chainID: String, blockID: String, contractID: Address) async throws {
        try await getContractDetails(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getContractDetails(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetContractDetailsConfiguration = .init()) async throws {
        try await getContractDetails(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getContractDetails(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetContractDetailsConfiguration = .init()) async throws {
        try await getContractDetails(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getBalance(chainID: String, blockID: String, contractID: Address) async throws {
        try await getBalance(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getBalance(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetBalanceConfiguration = .init()) async throws {
        try await getBalance(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getBalance(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetBalanceConfiguration = .init()) async throws {
        try await getBalance(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getCounter(chainID: String, blockID: String, contractID: Address) async throws {
        try await getCounter(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getCounter(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetCounterConfiguration = .init()) async throws {
        try await getCounter(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getCounter(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetCounterConfiguration = .init()) async throws {
        try await getCounter(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getDelegate(chainID: String, blockID: String, contractID: Address) async throws {
        try await getDelegate(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getDelegate(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetDelegateConfiguration = .init()) async throws {
        try await getDelegate(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getDelegate(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetDelegateConfiguration = .init()) async throws {
        try await getDelegate(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getEntrypoints(chainID: String, blockID: String, contractID: Address) async throws {
        try await getEntrypoints(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getEntrypoints(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetEntrypointsConfiguration = .init()) async throws {
        try await getEntrypoints(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getEntrypoints(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetEntrypointsConfiguration = .init()) async throws {
        try await getEntrypoints(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getEntrypoint(chainID: String, blockID: String, entrypoint: String, contractID: Address) async throws {
        try await getEntrypoint(chainID: chainID, blockID: blockID, contractID: contractID, entrypoint: entrypoint, configuredWith: .init())
    }
    
    func getEntrypoint(chainID: ChainID, blockID: Int, contractID: Address, entrypoint: String, configuredWith configuration: GetEntrypointConfiguration = .init()) async throws {
        try await getEntrypoint(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, entrypoint: entrypoint, configuredWith: configuration)
    }
    
    func getEntrypoint(chainID: ChainID, blockID: BlockHash, contractID: Address, entrypoint: String, configuredWith configuration: GetEntrypointConfiguration = .init()) async throws {
        try await getEntrypoint(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, entrypoint: entrypoint, configuredWith: configuration)
    }
    
    func getManagerKey(chainID: String, blockID: String, contractID: Address) async throws {
        try await getManagerKey(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getManagerKey(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetManagerKeyConfiguration = .init()) async throws {
        try await getManagerKey(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getManagerKey(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetManagerKeyConfiguration = .init()) async throws {
        try await getManagerKey(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getScript(chainID: String, blockID: String, contractID: Address) async throws {
        try await getScript(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getScript(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetScriptConfiguration = .init()) async throws {
        try await getScript(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getScript(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetScriptConfiguration = .init()) async throws {
        try await getScript(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(chainID: String, blockID: String, contractID: Address) async throws {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetSaplingStateDiffConfiguration = .init()) async throws {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetSaplingStateDiffConfiguration = .init()) async throws {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getStorage(chainID: String, blockID: String, contractID: Address) async throws {
        try await getStorage(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getStorage(chainID: ChainID, blockID: Int, contractID: Address, configuredWith configuration: GetStorageConfiguration = .init()) async throws {
        try await getStorage(chainID: chainID.base58, blockID: .init(blockID), contractID: contractID, configuredWith: configuration)
    }
    
    func getStorage(chainID: ChainID, blockID: BlockHash, contractID: Address, configuredWith configuration: GetStorageConfiguration = .init()) async throws {
        try await getStorage(chainID: chainID.base58, blockID: blockID.base58, contractID: contractID, configuredWith: configuration)
    }
    
    func getDelegateDetails(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getDelegateDetails(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegateDetails(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetContractDetailsConfiguration = .init()) async throws {
        try await getDelegateDetails(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegateDetails(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetContractDetailsConfiguration = .init()) async throws {
        try await getDelegateDetails(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getCurrentFrozenDeposits(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getCurrentFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getCurrentFrozenDeposits(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetCurrentFrozenDepositsConfiguration = .init()) async throws {
        try await getCurrentFrozenDeposits(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getCurrentFrozenDeposits(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetCurrentFrozenDepositsConfiguration = .init()) async throws {
        try await getCurrentFrozenDeposits(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func isDeactivated(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await isDeactivated(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func isDeactivated(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: IsDeactivatedConfiguration = .init()) async throws {
        try await isDeactivated(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func isDeactivated(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: IsDeactivatedConfiguration = .init()) async throws {
        try await isDeactivated(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedBalance(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getDelegatedBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedBalance(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetDelegatedBalanceConfiguration = .init()) async throws {
        try await getDelegatedBalance(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedBalance(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetDelegatedBalanceConfiguration = .init()) async throws {
        try await getDelegatedBalance(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedContracts(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getDelegatedContracts(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedContracts(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetDelegatedContractsConfiguration = .init()) async throws {
        try await getDelegatedContracts(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getDelegatedContracts(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetDelegatedContractsConfiguration = .init()) async throws {
        try await getDelegatedContracts(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDeposits(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDeposits(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetFrozenDepositsConfiguration = .init()) async throws {
        try await getFrozenDeposits(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDeposits(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetFrozenDepositsConfiguration = .init()) async throws {
        try await getFrozenDeposits(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDepositsLimit(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getFrozenDepositsLimit(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDepositsLimit(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetFrozenDepositsLimitConfiguration = .init()) async throws {
        try await getFrozenDepositsLimit(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFrozenDepositsLimit(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetFrozenDepositsLimitConfiguration = .init()) async throws {
        try await getFrozenDepositsLimit(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFullBalance(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getFullBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFullBalance(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetFullBalanceConfiguration = .init()) async throws {
        try await getFullBalance(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getFullBalance(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetFullBalanceConfiguration = .init()) async throws {
        try await getFullBalance(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getGracePeriod(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getGracePeriod(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getGracePeriod(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetGracePeriodConfiguration = .init()) async throws {
        try await getGracePeriod(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getGracePeriod(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetGracePeriodConfiguration = .init()) async throws {
        try await getGracePeriod(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getParticipation(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getParticipation(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getParticipation(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetParticipationConfiguration = .init()) async throws {
        try await getParticipation(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getParticipation(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetParticipationConfiguration = .init()) async throws {
        try await getParticipation(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getStakingBalance(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getStakingBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getStakingBalance(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetStakingBalanceConfiguration = .init()) async throws {
        try await getStakingBalance(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getStakingBalance(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetStakingBalanceConfiguration = .init()) async throws {
        try await getStakingBalance(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getVotingPower(chainID: String, blockID: String, delegateID: KeyHash.Public) async throws {
        try await getVotingPower(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getVotingPower(chainID: ChainID, blockID: Int, delegateID: KeyHash.Public, configuredWith configuration: GetVotingPowerConfiguration = .init()) async throws {
        try await getVotingPower(chainID: chainID.base58, blockID: .init(blockID), delegateID: delegateID, configuredWith: configuration)
    }
    
    func getVotingPower(chainID: ChainID, blockID: BlockHash, delegateID: KeyHash.Public, configuredWith configuration: GetVotingPowerConfiguration = .init()) async throws {
        try await getVotingPower(chainID: chainID.base58, blockID: blockID.base58, delegateID: delegateID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(chainID: String, blockID: String, stateID: String) async throws {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, stateID: stateID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(chainID: ChainID, blockID: Int, stateID: String, configuredWith configuration: GetSaplingStateDiffConfiguration = .init()) async throws {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: .init(blockID), stateID: stateID, configuredWith: configuration)
    }
    
    func getSaplingStateDiff(chainID: ChainID, blockID: BlockHash, stateID: String, configuredWith configuration: GetSaplingStateDiffConfiguration = .init()) async throws {
        try await getSaplingStateDiff(chainID: chainID.base58, blockID: blockID.base58, stateID: stateID, configuredWith: configuration)
    }
    
    func getBlockHeader(chainID: String, blockID: String) async throws {
        try await getBlockHeader(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getBlockHeader(chainID: ChainID, blockID: Int, configuredWith configuration: GetBlockHeaderConfiguration = .init()) async throws {
        try await getBlockHeader(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getBlockHeader(chainID: ChainID, blockID: BlockHash, configuredWith configuration: GetBlockHeaderConfiguration = .init()) async throws {
        try await getBlockHeader(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func preapplyOperations(_ operations: [RPCApplicableOperation], chainID: String, blockID: String) async throws {
        try await preapplyOperations(operations, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func preapplyOperations(_ operations: [RPCApplicableOperation], chainID: ChainID, blockID: Int, configuredWith configuration: PreapplyOperationsConfiguration = .init()) async throws {
        try await preapplyOperations(operations, chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func preapplyOperations(_ operations: [RPCApplicableOperation], chainID: ChainID, blockID: BlockHash, configuredWith configuration: PreapplyOperationsConfiguration = .init()) async throws {
        try await preapplyOperations(operations, chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func runOperation(_ operation: RPCRunnableOperation, chainID: String, blockID: String) async throws {
        try await runOperation(operation, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func runOperation(_ operation: RPCRunnableOperation, chainID: ChainID, blockID: Int, configuredWith configuration: RunOperationConfiguration = .init()) async throws {
        try await runOperation(operation, chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func runOperation(_ operation: RPCRunnableOperation, chainID: ChainID, blockID: BlockHash, configuredWith configuration: RunOperationConfiguration = .init()) async throws {
        try await runOperation(operation, chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
    
    func getOperations(chainID: String, blockID: String) async throws {
        try await getOperations(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getOperations(chainID: ChainID, blockID: Int, configuredWith configuration: GetOperationsConfiguration = .init()) async throws {
        try await getOperations(chainID: chainID.base58, blockID: .init(blockID), configuredWith: configuration)
    }
    
    func getOperations(chainID: ChainID, blockID: BlockHash, configuredWith configuration: GetOperationsConfiguration = .init()) async throws {
        try await getOperations(chainID: chainID.base58, blockID: blockID.base58, configuredWith: configuration)
    }
}

// MARK: Configuration

public struct GetBlockConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetBigMapConfiguration {
    let offset: UInt32?
    let length: UInt32?
    let headers: [HTTPHeader]
    
    public init(offset: UInt32? = nil, length: UInt32? = nil, headers: [HTTPHeader] = []) {
        self.offset = offset
        self.length = length
        self.headers = headers
    }
}

public struct GetBigMapValueConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetConstantsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetContractDetailsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetBalanceConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetCounterConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetDelegateConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetEntrypointsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetEntrypointConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetManagerKeyConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetScriptConfiguration {
    let unparsingMode: RPCScriptParsing
    let headers: [HTTPHeader]
    
    public init(unparsingMode: RPCScriptParsing = .readable, headers: [HTTPHeader] = []) {
        self.unparsingMode = unparsingMode
        self.headers = headers
    }
}

public struct GetSaplingStateDiffConfiguration {
    let commitmentOffset: UInt64?
    let nullifierOffset: UInt64?
    let headers: [HTTPHeader]
    
    public init(commitmentOffset: UInt64? = nil, nullifierOffset: UInt64? = nil, headers: [HTTPHeader] = []) {
        self.commitmentOffset = commitmentOffset
        self.nullifierOffset = nullifierOffset
        self.headers = headers
    }
}

public struct GetStorageConfiguration {
    let unparsingMode: RPCScriptParsing
    let headers: [HTTPHeader]
    
    public init(unparsingMode: RPCScriptParsing = .readable, headers: [HTTPHeader] = []) {
        self.unparsingMode = unparsingMode
        self.headers = headers
    }
}

public struct GetDelegateDetailsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetCurrentFrozenDepositsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct IsDeactivatedConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetDelegatedBalanceConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetDelegatedContractsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetFrozenDepositsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetFrozenDepositsLimitConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetFullBalanceConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetGracePeriodConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetParticipationConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetStakingBalanceConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetVotingPowerConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetBlockHeaderConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct PreapplyOperationsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct RunOperationConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}

public struct GetOperationsConfiguration {
    let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}
