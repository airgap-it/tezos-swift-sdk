//
//  ActiveRPCClient.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore
import TezosMichelson
import TezosOperation

public struct ActiveSimplifiedRPCClient<ChainsRPC: Chains>: ActiveSimplifiedRPC {
    private let chains: ChainsRPC
    
    init(chains: ChainsRPC) {
        self.chains = chains
    }
    
    public func getBlock(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        configuredWith configuration: GetBlockConfiguration
    ) async throws -> RPCBlock {
        try await chains(chainID: chainID).blocks(blockID: blockID).get(configuredWith: configuration)
    }
    
    public func getBigMap(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration
    ) async throws -> [Micheline] {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.bigMaps(bigMapID: bigMapID).get(configuredWith: configuration)
    }
    public func getBigMapValue(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration
    ) async throws -> Micheline? {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.bigMaps(bigMapID: bigMapID)(scriptExpr: key).get(configuredWith: configuration)
    }
    
    public func getConstants(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        configuredWith configuration: GetConstantsConfiguration
    ) async throws -> RPCConstants {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.constants.get(configuredWith: configuration)
    }
    
    public func getContractDetails(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetContractDetailsConfiguration) async
    throws -> RPCContractDetails {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).get(configuredWith: configuration)
    }
    public func getBalance(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetBalanceConfiguration) async
    throws -> String {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).balance.get(configuredWith: configuration)
    }
    public func getCounter(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetCounterConfiguration) async
    throws -> String? {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).counter.get(configuredWith: configuration)
    }
    public func getDelegate(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetDelegateConfiguration) async
    throws -> Address.Implicit? {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).delegate.get(configuredWith: configuration)
    }
    public func getEntrypoints(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetEntrypointsConfiguration) async
    throws -> RPCContractEntrypoints {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).entrypoints.get(configuredWith: configuration)
    }
    public func getEntrypoint(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration
    ) async throws -> Micheline {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context
            .contracts(contractID: contractID)
            .entrypoints(string: entrypoint)
            .get(configuredWith: configuration)
    }
    public func getManagerKey(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetManagerKeyConfiguration) async
    throws -> Key.Public? {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.contracts(contractID: contractID).managerKey.get(configuredWith: configuration)
    }
    public func getScript(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetScriptConfiguration) async
    throws -> Script? {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context.contracts(contractID: contractID)
            .script
            .normalized
            .post(unparsingMode: configuration.unparsingMode, configuredWith: .init(headers: configuration.headers))
    }
    public func getSaplingStateDiff(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetSaplingStateDiffConfiguration) async
    throws -> RPCSaplingStateDiff {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context
            .contracts(contractID: contractID)
            .singleSaplingGetDiff
            .get(configuredWith: configuration)
    }
    public func getStorage(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        contractID: Address, configuredWith
        configuration: GetStorageConfiguration) async
    throws -> Micheline? {
        try await chains(chainID: chainID)
            .blocks(blockID: blockID)
            .context
            .contracts(contractID: contractID)
            .storage
            .normalized
            .post(unparsingMode: configuration.unparsingMode, configuredWith: .init(headers: configuration.headers))
    }
    
    public func getDelegateDetails(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> RPCDelegateDetails {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).get(configuredWith: configuration)
    }
    public func getCurrentFrozenDeposits(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration
    ) async throws -> String {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).frozenDeposits.get(configuredWith: configuration)
    }
    public func isDeactivated(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration
    ) async throws -> Bool {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).deactivated.get(configuredWith: configuration)
    }
    public func getDelegatedBalance(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration
    ) async throws -> String {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).delegatedBalance.get(configuredWith: configuration)
    }
    public func getDelegatedContracts(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration
    ) async throws -> [Address] {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).delegatedContracts.get(configuredWith: configuration)
    }
    public func getFrozenDeposits(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration
    ) async throws -> String {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).frozenDeposits.get(configuredWith: configuration)
    }
    public func getFrozenDepositsLimit(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration
    ) async throws -> String {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).frozenDeposits.get(configuredWith: configuration)
    }
    public func getFullBalance(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration
    ) async throws -> String {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).fullBalance.get(configuredWith: configuration)
    }
    public func getGracePeriod(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration
    ) async throws -> Int32 {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).gracePeriod.get(configuredWith: configuration)
    }
    public func getParticipation(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration
    ) async throws -> RPCDelegateParticipation {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).participation.get(configuredWith: configuration)
    }
    public func getStakingBalance(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration
    ) async throws -> String {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).stakingBalance.get(configuredWith: configuration)
    }
    public func getVotingPower(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration
    ) async throws -> Int32 {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.delegates(pkh: delegateID).votingPower.get(configuredWith: configuration)
    }
    
    public func getSaplingStateDiff(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        stateID: String,
        configuredWith configuration: GetSaplingStateDiffConfiguration) async
    throws -> RPCSaplingStateDiff {
        try await chains(chainID: chainID).blocks(blockID: blockID).context.sapling(stateID: stateID).getDiff.get(configuredWith: configuration)
    }
    
    public func getBlockHeader(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        configuredWith configuration: GetBlockHeaderConfiguration
    ) async throws -> RPCFullBlockHeader {
        try await chains(chainID: chainID).blocks(blockID: blockID).header.get(configuredWith: configuration)
    }
    
    public func preapplyOperations(
        _ operations: [RPCApplicableOperation],
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        configuredWith configuration: PreapplyOperationsConfiguration
    ) async throws -> RPCAppliedOperation {
        try await chains(chainID: chainID).blocks(blockID: blockID).helpers.preapply.operations.post(operations: operations, configuredWith: configuration)
    }
    public func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        configuredWith configuration: RunOperationConfiguration
    ) async throws -> [RPCOperation.Content] {
        try await chains(chainID: chainID).blocks(blockID: blockID).helpers.scripts.runOperation.post(operation: operation, configuredWith: configuration)
    }
    
    public func getOperations(
        chainID: RPCChainID = .main,
        blockID: RPCBlockID = .head,
        configuredWith configuration: GetOperationsConfiguration
    ) async throws -> [[RPCOperation]] {
        try await chains(chainID: chainID).blocks(blockID: blockID).operations.get(configuredWith: configuration)
    }
}
