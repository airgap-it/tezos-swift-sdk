//
//  File.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore
import TezosMichelson
import TezosOperation

// MARK: ../<block_id>

public class BlockClient<HTTPClient: HTTP>: Block {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, blockID: RPCBlockID, http: HTTPClient) {
        self.baseURL = /* ../<block_id> */ parentURL.appendingPathComponent(blockID.rawValue)
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockGetConfiguration) async throws -> RPCBlock {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    public lazy var context: BlockContextClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var header: BlockHeaderClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var helpers: BlockHelpersClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var operations: BlockOperationsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context

public class BlockContextClient<HTTPClient: HTTP>: BlockContext {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context */ parentURL.appendingPathComponent("context")
        self.http = http
    }
    
    public lazy var bigMaps: BlockContextBigMapsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var constants: BlockContextConstantsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var contracts: BlockContextContractsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var delegates: BlockContextDelegatesClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var sapling: BlockContextSaplingClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/big_maps

public struct BlockContextBigMapsClient<HTTPClient: HTTP>: BlockContextBigMaps {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/big_maps */ parentURL.appendingPathComponent("big_maps")
        self.http = http
    }
    
    public func callAsFunction(bigMapID: String) -> BlockContextBigMapsBigMapClient<HTTPClient> {
        .init(parentURL: baseURL, bigMapID: bigMapID, http: http)
    }
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>

public struct BlockContextBigMapsBigMapClient<HTTPClient: HTTP>: BlockContextBigMapsBigMap {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, bigMapID: String, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/big_maps/<big_map_id> */ parentURL.appendingPathComponent(bigMapID)
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextBigMapsBigMapGetConfiguration) async throws -> [Micheline] {
        var parameters = [HTTPParameter]()
        if let offset = configuration.offset {
            parameters.append(("offset", String(offset)))
        }
        if let length = configuration.length {
            parameters.append(("length", String(length)))
        }
        
        return try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: parameters)
    }
    
    public func callAsFunction(scriptExpr: ScriptExprHash) -> BlockContextBigMapsBigMapValueClient<HTTPClient> {
        .init(parentURL: baseURL, scriptExpr: scriptExpr, http: http)
    }
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>/value

public struct BlockContextBigMapsBigMapValueClient<HTTPClient: HTTP>: BlockContextBigMapsBigMapValue {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, scriptExpr: ScriptExprHash, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/big_map_id>/value */ parentURL.appendingPathComponent(scriptExpr.base58)
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextBigMapsBigMapValueGetConfiguration) async throws -> Micheline? {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/constants

public struct BlockContextConstantsClient<HTTPClient: HTTP>: BlockContextConstants {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/constants */ parentURL.appendingPathComponent("constants")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextConstantsGetConfiguration) async throws -> RPCConstants {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts

public struct BlockContextContractsClient<HTTPClient: HTTP>: BlockContextContracts {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts */ parentURL.appendingPathComponent("contracts")
        self.http = http
    }
    
    public func callAsFunction(contractID: Address) -> BlockContextContractsContractClient<HTTPClient> {
        .init(parentURL: baseURL, address: contractID, http: http)
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>

public class BlockContextContractsContractClient<HTTPClient: HTTP>: BlockContextContractsContract {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, address: Address, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id> */ parentURL.appendingPathComponent(address.base58)
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws -> RPCContractDetails {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    public lazy var balance: BlockContextContractsContractBalanceClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var counter: BlockContextContractsContractCounterClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var delegate: BlockContextContractsContractDelegateClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var entrypoints: BlockContextContractsContractEntrypointsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var managerKey: BlockContextContractsContractManagerKeyClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var script: BlockContextContractsContractScriptClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var singleSaplingGetDiff: BlockContextContractsContractSingleSaplingGetDiffClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var storage: BlockContextContractsContractStorageClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/contracts/<contract_id>/balance

public struct BlockContextContractsContractBalanceClient<HTTPClient: HTTP>: BlockContextContractsContractBalance {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/balance */ parentURL.appendingPathComponent("balance")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractBalanceGetConfiguration) async throws -> String {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/counter

public struct BlockContextContractsContractCounterClient<HTTPClient: HTTP>: BlockContextContractsContractCounter {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/counter */ parentURL.appendingPathComponent("counter")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractCounterGetConfiguration) async throws -> String? {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/delegate

public struct BlockContextContractsContractDelegateClient<HTTPClient: HTTP>: BlockContextContractsContractDelegate {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/delegate */ parentURL.appendingPathComponent("delegate")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractDelegateGetConfiguration) async throws -> Address.Implicit? {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints

public struct BlockContextContractsContractEntrypointsClient<HTTPClient: HTTP>: BlockContextContractsContractEntrypoints {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/entrypoints */ parentURL.appendingPathComponent("entrypoints")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractEntrypointsGetConfiguration) async throws -> RPCContractEntrypoints {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    public func callAsFunction(string: String) -> BlockContextContractsContractEntrypointsEntrypointClient<HTTPClient> {
        .init(parentURL: baseURL, string: string, http: http)
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints/<string>

public struct BlockContextContractsContractEntrypointsEntrypointClient<HTTPClient: HTTP>: BlockContextContractsContractEntrypointsEntrypoint {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, string: String, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/entrypoints>/<string> */ parentURL.appendingPathComponent("string")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractEntrypointsEntrypointGetConfiguration) async throws -> Micheline {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/manager_key

public struct BlockContextContractsContractManagerKeyClient<HTTPClient: HTTP>: BlockContextContractsContractManagerKey {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/manager_key */ parentURL.appendingPathComponent("manager_key")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractManagerKeyGetConfiguration) async throws -> Key.Public? {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script

public class BlockContextContractsContractScriptClient<HTTPClient: HTTP>: BlockContextContractsContractScript {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/script */ parentURL.appendingPathComponent("script")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws -> Script? {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    public lazy var normalized: BlockContextContractsContractScriptNormalizedClient = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script/normalized

public struct BlockContextContractsContractScriptNormalizedClient<HTTPClient: HTTP>: BlockContextContractsContractScriptNormalized {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/script/normalized */ parentURL.appendingPathComponent("normalized")
        self.http = http
    }
    
    public func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractScriptNormalizedPostConfiguration) async throws -> Script? {
        try await http.post(
            baseURL: baseURL,
            endpoint: "/",
            headers: configuration.headers,
            parameters: [],
            request: GetContractNormalizedScriptRequest(unparsingMode: unparsingMode)
        )
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/single_sapling_get_diff

public struct BlockContextContractsContractSingleSaplingGetDiffClient<HTTPClient: HTTP>: BlockContextContractsContractSingleSaplingGetDiff {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/single_sapling_get_diff */ parentURL.appendingPathComponent("single_sapling_get_diff")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractSingleSaplingGetDiffGetConfiguration) async throws -> RPCSaplingStateDiff {
        var parameters = [HTTPParameter]()
        if let commitmentOffset = configuration.commitmentOffset {
            parameters.append(("offset_commitment", String(commitmentOffset)))
        }
        if let nullifierOffset = configuration.nullifierOffset {
            parameters.append(("offset_nullifier", String(nullifierOffset)))
        }
        
        return try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: parameters)
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage

public class BlockContextContractsContractStorageClient<HTTPClient: HTTP>: BlockContextContractsContractStorage {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/storage */ parentURL.appendingPathComponent("storage")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextContractsContractStorageGetConfiguration) async throws -> Micheline? {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    public lazy var normalized: BlockContextContractsContractStorageNormalizedClient = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage/normalized

public struct BlockContextContractsContractStorageNormalizedClient<HTTPClient: HTTP>: BlockContextContractsContractStorageNormalized {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/storage/normalized */ parentURL.appendingPathComponent("normalized")
        self.http = http
    }
    
    public func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractStorageNormalizedPostConfiguration) async throws -> Micheline? {
        try await http.post(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [], request: GetContractNormalizedStorageRequest(unparsingMode: unparsingMode))
    }
}

// MARK: ../<block_id>/context/delegates

public struct BlockContextDelegatesClient<HTTPClient: HTTP>: BlockContextDelegates {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates */ parentURL.appendingPathComponent("delegates")
        self.http = http
    }
    
    public func callAsFunction(pkh: KeyHash.Public) -> BlockContextDelegatesDelegateClient<HTTPClient> {
        .init(parentURL: baseURL, pkh: pkh, http: http)
    }
}

// MARK: ../<block_id>/context/delegates/<pkh>

public class BlockContextDelegatesDelegateClient<HTTPClient: HTTP>: BlockContextDelegatesDelegate {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, pkh: KeyHash.Public, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/<pkh> */ parentURL.appendingPathComponent(pkh.base58)
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesDelegateGetConfiguration) async throws -> RPCDelegateDetails {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    public lazy var currentFrozenDeposits: BlockContextDelegatesCurrentFrozenDepositsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var deactivated: BlockContextDelegatesDeactivatedClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var delegatedBalance: BlockContextDelegatesDelegatedBalanceClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var delegatedContracts: BlockContextDelegatesDelegatedContractsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var frozenDeposits: BlockContextDelegatesFrozenDepositsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var frozenDepositsLimit: BlockContextDelegatesFrozenDeposistsLimitClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var fullBalance: BlockContextDelegatesFullBalanceClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var gracePeriod: BlockContextDelegatesGracePeriodClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var participation: BlockContextDelegatesParticipationClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var stakingBalance: BlockContextDelegatesStakingBalanceClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var votingPower: BlockContextDelegatesVotingPowerClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/delegates/current_frozen_deposits

public struct BlockContextDelegatesCurrentFrozenDepositsClient<HTTPClient: HTTP>: BlockContextDelegatesCurrentFrozenDeposits {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/current_frozen_deposits */ parentURL.appendingPathComponent("current_frozen_deposits")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesCurrentFrozenDepositsGetConfiguration) async throws -> String {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/deactivated

public struct BlockContextDelegatesDeactivatedClient<HTTPClient: HTTP>: BlockContextDelegatesDeactivated {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/deactivated */ parentURL.appendingPathComponent("deactivated")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesDeactivatedGetConfiguration) async throws -> Bool {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/delegated_balance

public struct BlockContextDelegatesDelegatedBalanceClient<HTTPClient: HTTP>: BlockContextDelegatesDelegatedBalance {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/delegated_balance */ parentURL.appendingPathComponent("delegated_balance")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesDelegatedBalanceGetConfiguration) async throws -> String {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/delegated_contracts

public struct BlockContextDelegatesDelegatedContractsClient<HTTPClient: HTTP>: BlockContextDelegatesDelegatedContracts {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/delegated_contracts */ parentURL.appendingPathComponent("delegated_contracts")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesDelegatedContractsGetConfiguration) async throws -> [Address] {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/frozen_deposits

public struct BlockContextDelegatesFrozenDepositsClient<HTTPClient: HTTP>: BlockContextDelegatesFrozenDeposits {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/frozen_deposits */ parentURL.appendingPathComponent("frozen_deposits")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesFrozenDepositsGetConfiguration) async throws -> String {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/frozen_deposits_limit

public struct BlockContextDelegatesFrozenDeposistsLimitClient<HTTPClient: HTTP>: BlockContextDelegatesFrozenDeposistsLimit {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/frozen_deposits_limit */ parentURL.appendingPathComponent("frozen_deposits_limit")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesFrozenDeposistsLimitGetConfiguration) async throws -> String {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/full_balance

public struct BlockContextDelegatesFullBalanceClient<HTTPClient: HTTP>: BlockContextDelegatesFullBalance {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/full_balance */ parentURL.appendingPathComponent("full_balance")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesFullBalanceGetConfiguration) async throws -> String {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/grace_period

public struct BlockContextDelegatesGracePeriodClient<HTTPClient: HTTP>: BlockContextDelegatesGracePeriod {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/grace_period */ parentURL.appendingPathComponent("grace_period")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesGracePeriodGetConfiguration) async throws -> Int32 {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/participation

public struct BlockContextDelegatesParticipationClient<HTTPClient: HTTP>: BlockContextDelegatesParticipation {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/participation */ parentURL.appendingPathComponent("participation")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesParticipationGetConfiguration) async throws -> RPCDelegateParticipation {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/staking_balance

public struct BlockContextDelegatesStakingBalanceClient<HTTPClient: HTTP>: BlockContextDelegatesStakingBalance {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/staking_balance */ parentURL.appendingPathComponent("staking_balance")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesStakingBalanceGetConfiguration) async throws -> String {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/voting_power

public struct BlockContextDelegatesVotingPowerClient<HTTPClient: HTTP>: BlockContextDelegatesVotingPower {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/delegates/voting_power */ parentURL.appendingPathComponent("voting_power")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextDelegatesVotingPowerGetConfiguration) async throws -> Int32 {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/sapling

public struct BlockContextSaplingClient<HTTPClient: HTTP>: BlockContextSapling {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/sapling */ parentURL.appendingPathComponent("sapling")
        self.http = http
    }
    
    public func callAsFunction(stateID: String) -> BlockContextSaplingStateClient<HTTPClient> {
        .init(parentURL: baseURL, stateID: stateID, http: http)
    }
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>

public class BlockContextSaplingStateClient<HTTPClient: HTTP>: BlockContextSaplingState {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, stateID: String, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/sapling/<sapling_state_id> */ parentURL.appendingPathComponent(stateID)
        self.http = http
    }
    
    public lazy var getDiff: BlockContextSaplingStateGetDiffClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>/get_diff

public struct BlockContextSaplingStateGetDiffClient<HTTPClient: HTTP>: BlockContextSaplingStateGetDiff {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/context/sapling/<sapling_state_id>/get_diff */ parentURL.appendingPathComponent("get_diff")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockContextSaplingStateGetDiffGetConfiguration) async throws -> RPCSaplingStateDiff {
        var parameters = [HTTPParameter]()
        if let commitmentOffset = configuration.commitmentOffset {
            parameters.append(("offset_commitment", String(commitmentOffset)))
        }
        if let nullifierOffset = configuration.nullifierOffset {
            parameters.append(("offset_nullifier", String(nullifierOffset)))
        }
        
        return try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: parameters)
    }
}

// MARK: ../<block_id>/header

public struct BlockHeaderClient<HTTPClient: HTTP>: BlockHeader {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/header */ parentURL.appendingPathComponent("header")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws -> RPCFullBlockHeader {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/helpers

public class BlockHelpersClient<HTTPClient: HTTP>: BlockHelpers {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/helpers */ parentURL.appendingPathComponent("helpers")
        self.http = http
    }
    
    public lazy var preapply: BlockHelpersPreapplyClient<HTTPClient> = .init(parentURL: baseURL, http: http)
    public lazy var scripts: BlockHelpersScriptsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/helpers/preapply

public class BlockHelpersPreapplyClient<HTTPClient: HTTP>: BlockHelpersPreapply {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/helpers/prepply */ parentURL.appendingPathComponent("preapply")
        self.http = http
    }
    
    public lazy var operations: BlockHelpersPreapplyOperationsClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/helpers/preapply/operations

public struct BlockHelpersPreapplyOperationsClient<HTTPClient: HTTP>: BlockHelpersPreapplyOperations {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/helpers/prepply/operations */ parentURL.appendingPathComponent("operations")
        self.http = http
    }
    
    public func post(
        operations: [RPCApplicableOperation],
        configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration
    ) async throws -> RPCAppliedOperation {
        try await http.post(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [], request: operations)
    }
}

// MARK: ../<block_id>/helpers/scripts

public class BlockHelpersScriptsClient<HTTPClient: HTTP>: BlockHelpersScripts {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/helpers/scripts */ parentURL.appendingPathComponent("scripts")
        self.http = http
    }
    
    public lazy var runOperation: BlockHelpersScriptsRunOperationClient<HTTPClient> = .init(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/helpers/scripts/run_operation

public struct BlockHelpersScriptsRunOperationClient<HTTPClient: HTTP>: BlockHelpersScriptsRunOperation {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/helpers/scripts/run_operation */ parentURL.appendingPathComponent("run_operation")
        self.http = http
    }
    
    public func post(
        operation: RPCRunnableOperation,
        configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration
    ) async throws -> [RPCOperation.Content] {
        try await http.post(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [], request: operation)
    }
}

// MARK: ../<block_id>/operations

public struct BlockOperationsClient<HTTPClient: HTTP>: BlockOperations {
    let baseURL: URL
    let http: HTTPClient

    init(parentURL: URL, http: HTTPClient) {
        self.baseURL = /* ../<block_id>/operations */ parentURL.appendingPathComponent("operations")
        self.http = http
    }
    
    public func get(configuredWith configuration: BlockOperationsGetConfiguration) async throws -> [[RPCOperation]] {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}
