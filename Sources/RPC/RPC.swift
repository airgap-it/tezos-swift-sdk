//
//  RPC.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import Foundation

import TezosCore
import TezosMichelson
import TezosOperation

public typealias TezosRPC = RPC<URLSessionHTTP>

public struct RPC<HTTPClient: HTTP>: ShellSimplifiedRPC, ActiveSimplifiedRPC, FeeEstimator {
    private let shell: ShellSimplifiedRPCClient<ChainsClient<HTTPClient>, InjectionClient<HTTPClient>>
    private let active: ActiveSimplifiedRPCClient<ChainsClient<HTTPClient>>
    
    public let chains: ChainsClient<HTTPClient>
    public let injection: InjectionClient<HTTPClient>
    
    private let feeEstimator: OperationFeeEstimator<ChainsClient<HTTPClient>>
    
    public static func create(nodeURL: URL) -> RPC<URLSessionHTTP> {
        let http = URLSessionHTTP()
        
        let chains = ChainsClient(parentURL: nodeURL, http: http)
        let injection = InjectionClient(parentURL: nodeURL, http: http)
        
        return .init(
            shell: ShellSimplifiedRPCClient(chains: chains, injection: injection),
            active: ActiveSimplifiedRPCClient(chains: chains),
            chains: chains,
            injection: injection,
            feeEstimator: OperationFeeEstimator(chains: chains)
        )
    }
    
    init(
        shell: ShellSimplifiedRPCClient<ChainsClient<HTTPClient>, InjectionClient<HTTPClient>>,
        active: ActiveSimplifiedRPCClient<ChainsClient<HTTPClient>>,
        chains: ChainsClient<HTTPClient>,
        injection: InjectionClient<HTTPClient>,
        feeEstimator: OperationFeeEstimator<ChainsClient<HTTPClient>>
    ) {
        self.shell = shell
        self.active = active
        self.chains = chains
        self.injection = injection
        self.feeEstimator = feeEstimator
    }
    
    // MARK: FeeEstimator
    
    public func minFee(chainID: RPCChainID, operation: TezosOperation, configuredWith configuration: MinFeeConfiguration) async throws -> TezosOperation {
        try await feeEstimator.minFee(chainID: chainID, operation: operation, configuredWith: configuration)
    }
    
    // MARK: Shell
    
    public func getBlocks(chainID: RPCChainID, configuredWith configuration: GetBlocksConfiguration) async throws -> [BlockHash] {
        try await shell.getBlocks(chainID: chainID, configuredWith: configuration)
    }
    
    public func getChainID(chainID: RPCChainID, configuredWith configuration: GetChainIDConfiguration) async throws -> ChainID {
        try await shell.getChainID(chainID: chainID, configuredWith: configuration)
    }
    
    public func isBootstrapped(
        chainID: RPCChainID,
        configuredWith configuration: IsBootstrappedConfiguration
    ) async throws -> RPCChainBootstrappedStatus {
        try await shell.isBootstrapped(chainID: chainID, configuredWith: configuration)
    }
    
    public func injectOperation(_ data: String, configuredWith configuration: InjectOperationConfiguration) async throws -> OperationHash {
        try await shell.injectOperation(data, configuredWith: configuration)
    }
    
    // MARK: Active
    
    public func getBlock(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetBlockConfiguration) async throws -> RPCBlock {
        try await active.getBlock(chainID: chainID, blockID: blockID, configuredWith: configuration)
    }
    
    public func getBigMap(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        bigMapID: String,
        configuredWith configuration: GetBigMapConfiguration
    ) async throws -> [Micheline] {
        try await active.getBigMap(chainID: chainID, blockID: blockID, bigMapID: bigMapID, configuredWith: configuration)
    }

    public func getBigMapValue(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        bigMapID: String,
        key: ScriptExprHash,
        configuredWith configuration: GetBigMapValueConfiguration
    ) async throws -> Micheline? {
        try await active.getBigMapValue(chainID: chainID, blockID: blockID, bigMapID: bigMapID, key: key, configuredWith: configuration)
    }
    
    public func getConstants(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: GetConstantsConfiguration
    ) async throws -> RPCConstants {
        try await active.getConstants(chainID: chainID, blockID: blockID, configuredWith: configuration)
    }
    
    public func getContractDetails(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> RPCContractDetails {
        try await active.getContractDetails(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }

    public func getBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetBalanceConfiguration
    ) async throws -> String {
        try await active.getBalance(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }

    public func getCounter(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetCounterConfiguration
    ) async throws -> String? {
        try await active.getCounter(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }

    public func getDelegate(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetDelegateConfiguration
    ) async throws -> Address.Implicit? {
        try await active.getDelegate(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }
    public func getEntrypoints(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetEntrypointsConfiguration
    ) async throws -> RPCContractEntrypoints {
        try await active.getEntrypoints(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }

    public func getEntrypoint(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        entrypoint: String,
        configuredWith configuration: GetEntrypointConfiguration
    ) async throws -> Micheline {
        try await active.getEntrypoint(chainID: chainID, blockID: blockID, contractID: contractID, entrypoint: entrypoint, configuredWith: configuration)
    }

    public func getManagerKey(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetManagerKeyConfiguration
    ) async throws -> Key.Public? {
        try await active.getManagerKey(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }

    public func getScript(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetScriptConfiguration
    ) async throws -> Script? {
        try await active.getScript(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }

    public func getSaplingStateDiff(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> RPCSaplingStateDiff {
        try await active.getSaplingStateDiff(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }

    public func getStorage(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        contractID: Address,
        configuredWith configuration: GetStorageConfiguration
    ) async throws -> Micheline? {
        try await active.getStorage(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: configuration)
    }
    
    public func getDelegateDetails(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetContractDetailsConfiguration
    ) async throws -> RPCDelegateDetails {
        try await active.getDelegateDetails(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }
    public func getCurrentFrozenDeposits(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetCurrentFrozenDepositsConfiguration
    ) async throws -> String {
        try await active.getCurrentFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func isDeactivated(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: IsDeactivatedConfiguration
    ) async throws -> Bool {
        try await active.isDeactivated(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getDelegatedBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedBalanceConfiguration
    ) async throws -> String {
        try await active.getDelegatedBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getDelegatedContracts(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetDelegatedContractsConfiguration
    ) async throws -> [Address] {
        try await active.getDelegatedContracts(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getFrozenDeposits(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsConfiguration
    ) async throws -> String {
        try await active.getFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getFrozenDepositsLimit(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFrozenDepositsLimitConfiguration
    ) async throws -> String {
        try await active.getFrozenDepositsLimit(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getFullBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetFullBalanceConfiguration
    ) async throws -> String {
        try await active.getFullBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getGracePeriod(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetGracePeriodConfiguration
    ) async throws -> Int32 {
        try await active.getGracePeriod(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getParticipation(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetParticipationConfiguration
    ) async throws -> RPCDelegateParticipation {
        try await active.getParticipation(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getStakingBalance(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetStakingBalanceConfiguration
    ) async throws -> String {
        try await active.getStakingBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }

    public func getVotingPower(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        delegateID: KeyHash.Public,
        configuredWith configuration: GetVotingPowerConfiguration
    ) async throws -> Int32 {
        try await active.getVotingPower(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: configuration)
    }
    
    public func getSaplingStateDiff(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        stateID: String,
        configuredWith configuration: GetSaplingStateDiffConfiguration
    ) async throws -> RPCSaplingStateDiff {
        try await active.getSaplingStateDiff(chainID: chainID, blockID: blockID, stateID: stateID, configuredWith: configuration)
    }
    
    public func getBlockHeader(chainID: RPCChainID, blockID: RPCBlockID, configuredWith configuration: GetBlockHeaderConfiguration) async throws -> RPCFullBlockHeader {
        try await active.getBlockHeader(chainID: chainID, blockID: blockID, configuredWith: configuration)
    }
    
    public func preapplyOperations(
        _ operations: [RPCApplicableOperation],
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: PreapplyOperationsConfiguration
    ) async throws -> RPCAppliedOperation {
        try await active.preapplyOperations(operations, chainID: chainID, blockID: blockID, configuredWith: configuration)
    }

    public func runOperation(
        _ operation: RPCRunnableOperation,
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: RunOperationConfiguration
    ) async throws -> [RPCOperation.Content] {
        try await active.runOperation(operation, chainID: chainID, blockID: blockID, configuredWith: configuration)
    }
    
    public func getOperations(
        chainID: RPCChainID,
        blockID: RPCBlockID,
        configuredWith configuration: GetOperationsConfiguration
    ) async throws -> [[RPCOperation]] {
        try await active.getOperations(chainID: chainID, blockID: blockID, configuredWith: configuration)
    }
}
