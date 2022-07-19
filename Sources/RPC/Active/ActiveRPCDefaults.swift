//
//  ActiveRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

public extension ActiveSimplifiedRPC {
    func getBlock(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> GetBlockResponse {
        try await getBlock(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getBigMap(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, bigMapID: String) async throws -> GetBigMapResponse {
        try await getBigMap(chainID: chainID, blockID: blockID, bigMapID: bigMapID, configuredWith: .init())
    }
    
    func getBigMapValue(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, bigMapID: String, key: ScriptExprHash) async throws -> GetBigMapValueResponse {
        try await getBigMapValue(chainID: chainID, blockID: blockID, bigMapID: bigMapID, key: key, configuredWith: .init())
    }
    
    func getConstants(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> GetConstantsResponse {
        try await getConstants(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getContractDetails(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractDetailsResponse {
        try await getContractDetails(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractBalanceResponse {
        try await getBalance(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getCounter(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractCounterResponse {
        try await getCounter(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getDelegate(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractDelegateResponse {
        try await getDelegate(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getEntrypoints(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractEntrypointsResponse {
        try await getEntrypoints(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getEntrypoint(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, entrypoint: String, contractID: Address) async throws -> GetContractEntrypointResponse {
        try await getEntrypoint(chainID: chainID, blockID: blockID, contractID: contractID, entrypoint: entrypoint, configuredWith: .init())
    }
    
    func getManagerKey(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractManagerKeyResponse {
        try await getManagerKey(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getScript(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractNormalizedScriptResponse {
        try await getScript(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getStorage(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> GetContractNormalizedStorageResponse {
        try await getStorage(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getDelegateDetails(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateDetailsResponse {
        try await getDelegateDetails(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getCurrentFrozenDeposits(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateCurrentFrozenDepositsResponse {
        try await getCurrentFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func isDeactivated(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateDeactivatedStatusResponse {
        try await isDeactivated(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateDelegatedBalanceResponse {
        try await getDelegatedBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedContracts(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateDelegatedContractsResponse {
        try await getDelegatedContracts(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDeposits(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateFrozenDepositsResponse {
        try await getFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDepositsLimit(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateFrozenDepositsLimitResponse {
        try await getFrozenDepositsLimit(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFullBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateFullBalanceResponse {
        try await getFullBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getGracePeriod(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateGracePeriodResponse {
        try await getGracePeriod(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getParticipation(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateParticipationResponse {
        try await getParticipation(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getStakingBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateStakingBalanceResponse {
        try await getStakingBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getVotingPower(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> GetDelegateVotingPowerResponse {
        try await getVotingPower(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, stateID: String) async throws -> GetSaplingStateDiffResponse {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, stateID: stateID, configuredWith: .init())
    }
    
    func getBlockHeader(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> GetBlockHeaderResponse {
        try await getBlockHeader(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func preapplyOperations(_ operations: [RPCApplicableOperation], chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> PreapplyOperationsResponse {
        try await preapplyOperations(operations, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func runOperation(_ operation: RPCRunnableOperation, chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> RunOperationResponse {
        try await runOperation(operation, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getOperations(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> GetBlockOperationsResponse {
        try await getOperations(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
}
