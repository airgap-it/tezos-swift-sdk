//
//  ActiveRPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import TezosCore
import TezosMichelson
import TezosOperation

public protocol ActiveSimplifiedRPC {
    func getBlock(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetBlockConfiguration) async throws -> RPCBlock
    
    func getBigMap(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration
    ) async throws -> [Micheline]
    func getBigMapValue(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration
    ) async throws -> Micheline?
    
    func getConstants(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetConstantsConfiguration) async throws -> RPCConstants
    
    func getContractDetails(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> RPCContractDetails
    func getBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetBalanceConfiguration
    ) async throws -> String
    func getCounter(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetCounterConfiguration
    ) async throws -> String?
    func getDelegate(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetDelegateConfiguration
    ) async throws -> Address.Implicit?
    func getEntrypoints(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetEntrypointsConfiguration
    ) async throws -> RPCContractEntrypoints
    func getEntrypoint(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration
    ) async throws -> Micheline
    func getManagerKey(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetManagerKeyConfiguration
    ) async throws -> Key.Public?
    func getScript(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetScriptConfiguration
    ) async throws -> Script?
    func getSaplingStateDiff(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> RPCSaplingStateDiff
    func getStorage(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetStorageConfiguration
    ) async throws -> Micheline?
    
    func getDelegateDetails(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> RPCDelegateDetails
    func getCurrentFrozenDeposits(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration
    ) async throws -> String
    func isDeactivated(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration
    ) async throws -> Bool
    func getDelegatedBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration
    ) async throws -> String
    func getDelegatedContracts(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration
    ) async throws -> [Address]
    func getFrozenDeposits(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration
    ) async throws -> String
    func getFrozenDepositsLimit(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration
    ) async throws -> String
    func getFullBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration
    ) async throws -> String
    func getGracePeriod(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration
    ) async throws -> Int32
    func getParticipation(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration
    ) async throws -> RPCDelegateParticipation
    func getStakingBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration
    ) async throws -> String
    func getVotingPower(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration
    ) async throws -> Int32
    
    func getSaplingStateDiff(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        stateID: String,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> RPCSaplingStateDiff
    
    func getBlockHeader(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetBlockHeaderConfiguration) async throws -> RPCFullBlockHeader
    
    func preapplyOperations(
        _ operations: [RPCApplicableOperation],
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: PreapplyOperationsConfiguration
    ) async throws -> RPCAppliedOperation
    func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: RunOperationConfiguration
    ) async throws -> [RPCOperation.Content]
    
    func getOperations(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: GetOperationsConfiguration
    ) async throws -> [[RPCOperation]]
}
