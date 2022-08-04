//
//  ActiveRPCDefaults.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import TezosCore
import TezosMichelson
import TezosOperation

public extension ActiveSimplifiedRPC {
    func getBlock(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> RPCBlock {
        try await getBlock(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getBigMap(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, bigMapID: String) async throws -> [Micheline] {
        try await getBigMap(chainID: chainID, blockID: blockID, bigMapID: bigMapID, configuredWith: .init())
    }
    
    func getBigMapValue(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, bigMapID: String, key: ScriptExprHash) async throws -> Micheline? {
        try await getBigMapValue(chainID: chainID, blockID: blockID, bigMapID: bigMapID, key: key, configuredWith: .init())
    }
    
    func getConstants(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> RPCConstants {
        try await getConstants(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getContractDetails(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> RPCContractDetails {
        try await getContractDetails(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> String {
        try await getBalance(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getCounter(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> String? {
        try await getCounter(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getDelegate(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> Address.Implicit? {
        try await getDelegate(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getEntrypoints(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> RPCContractEntrypoints {
        try await getEntrypoints(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getEntrypoint(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, entrypoint: String, contractID: Address) async throws -> Micheline {
        try await getEntrypoint(chainID: chainID, blockID: blockID, contractID: contractID, entrypoint: entrypoint, configuredWith: .init())
    }
    
    func getManagerKey(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> Key.Public? {
        try await getManagerKey(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getScript(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> Script? {
        try await getScript(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> RPCSaplingStateDiff {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getStorage(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, contractID: Address) async throws -> Micheline? {
        try await getStorage(chainID: chainID, blockID: blockID, contractID: contractID, configuredWith: .init())
    }
    
    func getDelegateDetails(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> RPCDelegateDetails {
        try await getDelegateDetails(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getCurrentFrozenDeposits(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> String {
        try await getCurrentFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func isDeactivated(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> Bool {
        try await isDeactivated(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> String {
        try await getDelegatedBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getDelegatedContracts(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> [Address] {
        try await getDelegatedContracts(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDeposits(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> String {
        try await getFrozenDeposits(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFrozenDepositsLimit(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> String {
        try await getFrozenDepositsLimit(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getFullBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> String {
        try await getFullBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getGracePeriod(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> Int32 {
        try await getGracePeriod(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getParticipation(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> RPCDelegateParticipation {
        try await getParticipation(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getStakingBalance(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> String {
        try await getStakingBalance(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getVotingPower(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, delegateID: KeyHash.Public) async throws -> Int32 {
        try await getVotingPower(chainID: chainID, blockID: blockID, delegateID: delegateID, configuredWith: .init())
    }
    
    func getSaplingStateDiff(chainID: RPCChainID = .main, blockID: RPCBlockID = .head, stateID: String) async throws -> RPCSaplingStateDiff {
        try await getSaplingStateDiff(chainID: chainID, blockID: blockID, stateID: stateID, configuredWith: .init())
    }
    
    func getBlockHeader(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> RPCFullBlockHeader {
        try await getBlockHeader(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func preapplyOperations(_ operations: [RPCApplicableOperation], chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> RPCAppliedOperation {
        try await preapplyOperations(operations, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func runOperation(_ operation: RPCRunnableOperation, chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> [RPCOperation.Content] {
        try await runOperation(operation, chainID: chainID, blockID: blockID, configuredWith: .init())
    }
    
    func getOperations(chainID: RPCChainID = .main, blockID: RPCBlockID = .head) async throws -> [[RPCOperation]] {
        try await getOperations(chainID: chainID, blockID: blockID, configuredWith: .init())
    }
}
