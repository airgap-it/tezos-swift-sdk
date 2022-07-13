//
//  File.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

// MARK: ../<block_id>

class BlockClient: Block {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, blockID: String, http: HTTP) {
        self.baseURL = /* ../<block_id> */ parentURL.appendingPathComponent(blockID)
        self.http = http
    }
    
    func get(configuredWith configuration: BlockGetConfiguration) async throws -> GetBlockResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    lazy var context: BlockContext = BlockContextClient(parentURL: baseURL, http: http)
    lazy var header: BlockHeader = BlockHeaderClient(parentURL: baseURL, http: http)
    lazy var helpers: BlockHelpers = BlockHelpersClient(parentURL: baseURL, http: http)
    lazy var operations: BlockOperations = BlockOperationsClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context

class BlockContextClient: BlockContext {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context */ parentURL.appendingPathComponent("context")
        self.http = http
    }
    
    lazy var bigMaps: BlockContextBigMaps = BlockContextBigMapsClient(parentURL: baseURL, http: http)
    lazy var constants: BlockContextConstants = BlockContextConstantsClient(parentURL: baseURL, http: http)
    lazy var contracts: BlockContextContracts = BlockContextContractsClient(parentURL: baseURL, http: http)
    lazy var delegates: BlockContextDelegates = BlockContextDelegatesClient(parentURL: baseURL, http: http)
    lazy var sapling: BlockContextSapling = BlockContextSaplingClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/big_maps

struct BlockContextBigMapsClient: BlockContextBigMaps {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/big_maps */ parentURL.appendingPathComponent("big_maps")
        self.http = http
    }
    
    func callAsFunction(bigMapID: String) -> BlockContextBigMapsBigMap {
        BlockContextBigMapsBigMapClient(parentURL: baseURL, bigMapID: bigMapID, http: http)
    }
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>

struct BlockContextBigMapsBigMapClient: BlockContextBigMapsBigMap {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, bigMapID: String, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/big_maps/<big_map_id> */ parentURL.appendingPathComponent(bigMapID)
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextBigMapsBigMapGetConfiguration) async throws -> GetBigMapResponse {
        var parameters = [HTTPParameter]()
        if let offset = configuration.offset {
            parameters.append(("offset", String(offset)))
        }
        if let length = configuration.length {
            parameters.append(("length", String(length)))
        }
        
        return try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: parameters)
    }
    
    func callAsFunction(scriptExpr: ScriptExprHash) -> BlockContextBigMapsBigMapValue {
        BlockContextBigMapsBigMapValueClient(parentURL: baseURL, scriptExpr: scriptExpr, http: http)
    }
}

// MARK: ../<block_id>/context/big_maps/<big_map_id>/value

struct BlockContextBigMapsBigMapValueClient: BlockContextBigMapsBigMapValue {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, scriptExpr: ScriptExprHash, http: HTTP) {
        self.baseURL = /* ../<block_id>/big_map_id>/value */ parentURL.appendingPathComponent(scriptExpr.base58)
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextBigMapsBigMapValueGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/constants

struct BlockContextConstantsClient: BlockContextConstants {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/constants */ parentURL.appendingPathComponent("constants")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextConstantsGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts

struct BlockContextContractsClient: BlockContextContracts {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts */ parentURL.appendingPathComponent("contracts")
        self.http = http
    }
    
    func callAsFunction(contractID: Address) -> BlockContextContractsContract {
        BlockContextContractsContractClient(parentURL: baseURL, address: contractID, http: http)
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>

class BlockContextContractsContractClient: BlockContextContractsContract {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, address: Address, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id> */ parentURL.appendingPathComponent(address.base58)
        self.http = http
    }
    
    func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    lazy var balance: BlockContextContractsContractBalance = BlockContextContractsContractBalanceClient(parentURL: baseURL, http: http)
    lazy var counter: BlockContextContractsContractCounter = BlockContextContractsContractCounterClient(parentURL: baseURL, http: http)
    lazy var delegate: BlockContextContractsContractDelegate = BlockContextContractsContractDelegateClient(parentURL: baseURL, http: http)
    lazy var entrypoints: BlockContextContractsContractEntrypoints = BlockContextContractsContractEntrypointsClient(parentURL: baseURL, http: http)
    lazy var managerKey: BlockContextContractsContractManagerKey = BlockContextContractsContractManagerKeyClient(parentURL: baseURL, http: http)
    lazy var script: BlockContextContractsContractScript = BlockContextContractsContractScriptClient(parentURL: baseURL, http: http)
    lazy var singleSaplingGetDiff: BlockContextContractsContractSingleSaplingGetDiff = BlockContextContractsContractSingleSaplingGetDiffClient(parentURL: baseURL, http: http)
    lazy var storage: BlockContextContractsContractStorage = BlockContextContractsContractStorageClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/contracts/<contract_id>/balance

struct BlockContextContractsContractBalanceClient: BlockContextContractsContractBalance {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/balance */ parentURL.appendingPathComponent("balance")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractBalanceGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/counter

struct BlockContextContractsContractCounterClient: BlockContextContractsContractCounter {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/counter */ parentURL.appendingPathComponent("counter")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractCounterGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/delegate

struct BlockContextContractsContractDelegateClient: BlockContextContractsContractDelegate {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/delegate */ parentURL.appendingPathComponent("delegate")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractDelegateGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints

struct BlockContextContractsContractEntrypointsClient: BlockContextContractsContractEntrypoints {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/entrypoints */ parentURL.appendingPathComponent("entrypoints")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsGetConfiguration) async throws -> GetContractEntrypointsResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    func callAsFunction(string: String) -> BlockContextContractsContractEntrypointsEntrypoint {
        BlockContextContractsContractEntrypointsEntrypointClient(parentURL: baseURL, string: string, http: http)
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints/<string>

struct BlockContextContractsContractEntrypointsEntrypointClient: BlockContextContractsContractEntrypointsEntrypoint {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, string: String, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/entrypoints>/<string> */ parentURL.appendingPathComponent("string")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractEntrypointsEntrypointGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/manager_key

struct BlockContextContractsContractManagerKeyClient: BlockContextContractsContractManagerKey {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/manager_key */ parentURL.appendingPathComponent("manager_key")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractManagerKeyGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script

class BlockContextContractsContractScriptClient: BlockContextContractsContractScript {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/script */ parentURL.appendingPathComponent("script")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractScriptGetConfiguration) async throws -> GetContractScriptResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    lazy var normalized: BlockContextContractsContractScriptNormalized = BlockContextContractsContractScriptNormalizedClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/contracts/<contract_id>/script/normalized

struct BlockContextContractsContractScriptNormalizedClient: BlockContextContractsContractScriptNormalized {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/script/normalized */ parentURL.appendingPathComponent("normalized")
        self.http = http
    }
    
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractScriptNormalizedPostConfiguration) async throws -> GetContractNormalizedScriptResponse {
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

struct BlockContextContractsContractSingleSaplingGetDiffClient: BlockContextContractsContractSingleSaplingGetDiff {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/single_sapling_get_diff */ parentURL.appendingPathComponent("single_sapling_get_diff")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractSingleSaplingGetDiffGetConfiguration) async throws -> GetContractSaplingStateDiffResponse {
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

class BlockContextContractsContractStorageClient: BlockContextContractsContractStorage {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/storage */ parentURL.appendingPathComponent("storage")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextContractsContractStorageGetConfiguration) async throws -> GetContractStorageResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    lazy var normalized: BlockContextContractsContractStorageNormalized = BlockContextContractsContractStorageNormalizedClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage/normalized

struct BlockContextContractsContractStorageNormalizedClient: BlockContextContractsContractStorageNormalized {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/contracts/<contract_id>/storage/normalized */ parentURL.appendingPathComponent("normalized")
        self.http = http
    }
    
    func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractStorageNormalizedPostConfiguration) async throws -> GetContractNormalizedStorageResponse {
        try await http.post(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [], request: GetContractNormalizedStorageRequest(unparsingMode: unparsingMode))
    }
}

// MARK: ../<block_id>/context/delegates

struct BlockContextDelegatesClient: BlockContextDelegates {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates */ parentURL.appendingPathComponent("delegates")
        self.http = http
    }
    
    func callAsFunction(pkh: KeyHash.Public) -> BlockContextDelegatesDelegate {
        BlockContextDelegatesDelegateClient(parentURL: baseURL, pkh: pkh, http: http)
    }
}

// MARK: ../<block_id>/context/delegates/<pkh>

class BlockContextDelegatesDelegateClient: BlockContextDelegatesDelegate {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, pkh: KeyHash.Public, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/<pkh> */ parentURL.appendingPathComponent(pkh.base58)
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesDelegateGetConfiguration) async throws -> GetDelegateDetailsResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
    
    lazy var currentFrozenDeposits: BlockContextDelegatesCurrentFrozenDeposits = BlockContextDelegatesCurrentFrozenDepositsClient(parentURL: baseURL, http: http)
    lazy var deactivated: BlockContextDelegatesDeactivated = BlockContextDelegatesDeactivatedClient(parentURL: baseURL, http: http)
    lazy var delegatedBalance: BlockContextDelegatesDelegatedBalance = BlockContextDelegatesDelegatedBalanceClient(parentURL: baseURL, http: http)
    lazy var delegatedContracts: BlockContextDelegatesDelegatedContracts = BlockContextDelegatesDelegatedContractsClient(parentURL: baseURL, http: http)
    lazy var frozenDeposits: BlockContextDelegatesCurrentFrozenDeposits = BlockContextDelegatesCurrentFrozenDepositsClient(parentURL: baseURL, http: http)
    lazy var frozenDepositsLimit: BlockContextDelegatesFrozenDeposistsLimit = BlockContextDelegatesFrozenDeposistsLimitClient(parentURL: baseURL, http: http)
    lazy var fullBalance: BlockContextDelegatesFullBalance = BlockContextDelegatesFullBalanceClient(parentURL: baseURL, http: http)
    lazy var gracePeriod: BlockContextDelegatesGracePeriod = BlockContextDelegatesGracePeriodClient(parentURL: baseURL, http: http)
    lazy var participation: BlockContextDelegatesParticipation = BlockContextDelegatesParticipationClient(parentURL: baseURL, http: http)
    lazy var stakingBalance: BlockContextDelegatesStakingBalance = BlockContextDelegatesStakingBalanceClient(parentURL: baseURL, http: http)
    lazy var votingPower: BlockContextDelegatesVotingPower = BlockContextDelegatesVotingPowerClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/delegates/current_frozen_deposits

struct BlockContextDelegatesCurrentFrozenDepositsClient: BlockContextDelegatesCurrentFrozenDeposits {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/current_frozen_deposits */ parentURL.appendingPathComponent("current_frozen_deposits")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesCurrentFrozenDepositsGetConfiguration) async throws -> GetDelegateCurrentFrozenDepositsResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/deactivated

struct BlockContextDelegatesDeactivatedClient: BlockContextDelegatesDeactivated {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/deactivated */ parentURL.appendingPathComponent("deactivated")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesDeactivatedGetConfiguration) async throws -> GetDelegateDeactivatedStatusResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/delegated_balance

struct BlockContextDelegatesDelegatedBalanceClient: BlockContextDelegatesDelegatedBalance {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/delegated_balance */ parentURL.appendingPathComponent("delegated_balance")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesDelegatedBalanceGetConfiguration) async throws -> GetDelegateDelegatedBalanceResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/delegated_contracts

struct BlockContextDelegatesDelegatedContractsClient: BlockContextDelegatesDelegatedContracts {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/delegated_contracts */ parentURL.appendingPathComponent("delegated_contracts")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesDelegatedContractsGetConfiguration) async throws -> GetDelegateDelegatedContractsResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/frozen_deposits

struct BlockContextDelegatesFrozenDepositsClient: BlockContextDelegatesFrozenDeposits {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/frozen_deposits */ parentURL.appendingPathComponent("frozen_deposits")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesFrozenDepositsGetConfiguration) async throws -> GetDelegateFrozenDepositsResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/frozen_deposits_limit

struct BlockContextDelegatesFrozenDeposistsLimitClient: BlockContextDelegatesFrozenDeposistsLimit {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/frozen_deposits_limit */ parentURL.appendingPathComponent("frozen_deposits_limit")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesFrozenDeposistsLimitGetConfiguration) async throws -> GetDelegateFrozenDepositsLimitResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/full_balance

struct BlockContextDelegatesFullBalanceClient: BlockContextDelegatesFullBalance {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/full_balance */ parentURL.appendingPathComponent("full_balance")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesFullBalanceGetConfiguration) async throws -> GetDelegateFullBalanceResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/grace_period

struct BlockContextDelegatesGracePeriodClient: BlockContextDelegatesGracePeriod {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/grace_period */ parentURL.appendingPathComponent("grace_period")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesGracePeriodGetConfiguration) async throws -> GetDelegateGracePeriodResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/participation

struct BlockContextDelegatesParticipationClient: BlockContextDelegatesParticipation {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/participation */ parentURL.appendingPathComponent("participation")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesParticipationGetConfiguration) async throws -> GetDelegateParticipationResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/staking_balance

struct BlockContextDelegatesStakingBalanceClient: BlockContextDelegatesStakingBalance {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/staking_balance */ parentURL.appendingPathComponent("staking_balance")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesStakingBalanceGetConfiguration) async throws -> GetDelegateStakingBalanceResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/delegates/voting_power

struct BlockContextDelegatesVotingPowerClient: BlockContextDelegatesVotingPower {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/delegates/voting_power */ parentURL.appendingPathComponent("voting_power")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextDelegatesVotingPowerGetConfiguration) async throws -> GetDelegateVotingPowerResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/context/sapling

struct BlockContextSaplingClient: BlockContextSapling {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/sapling */ parentURL.appendingPathComponent("sapling")
        self.http = http
    }
    
    func callAsFunction(stateID: String) -> BlockContextSaplingState {
        BlockContextSaplingStateClient(parentURL: baseURL, stateID: stateID, http: http)
    }
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>

class BlockContextSaplingStateClient: BlockContextSaplingState {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, stateID: String, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/sapling/<sapling_state_id> */ parentURL.appendingPathComponent(stateID)
        self.http = http
    }
    
    lazy var getDiff: BlockContextSaplingStateGetDiff = BlockContextSaplingStateGetDiffClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/context/sapling/<sapling_state_id>/get_diff

struct BlockContextSaplingStateGetDiffClient: BlockContextSaplingStateGetDiff {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/context/sapling/<sapling_state_id>/get_diff */ parentURL.appendingPathComponent("get_diff")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockContextSaplingStateGetDiffGetConfiguration) async throws -> GetSaplingStateDiffResponse {
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

struct BlockHeaderClient: BlockHeader {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/header */ parentURL.appendingPathComponent("header")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws -> GetBlockHeaderResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}

// MARK: ../<block_id>/helpers

class BlockHelpersClient: BlockHelpers {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/helpers */ parentURL.appendingPathComponent("helpers")
        self.http = http
    }
    
    lazy var preapply: BlockHelpersPreapply = BlockHelpersPreapplyClient(parentURL: baseURL, http: http)
    lazy var scripts: BlockHelpersScripts = BlockHelpersScriptsClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/helpers/preapply

class BlockHelpersPreapplyClient: BlockHelpersPreapply {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/helpers/prepply */ parentURL.appendingPathComponent("preapply")
        self.http = http
    }
    
    lazy var operations: BlockHelpersPreapplyOperations = BlockHelpersPreapplyOperationsClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/helpers/preapply/operations

struct BlockHelpersPreapplyOperationsClient: BlockHelpersPreapplyOperations {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/helpers/prepply/operations */ parentURL.appendingPathComponent("operations")
        self.http = http
    }
    
    func post(
        operations: [RPCApplicableOperation],
        configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration
    ) async throws -> PreapplyOperationsResponse {
        try await http.post(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [], request: operations)
    }
}

// MARK: ../<block_id>/helpers/scripts

class BlockHelpersScriptsClient: BlockHelpersScripts {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/helpers/scripts */ parentURL.appendingPathComponent("scripts")
        self.http = http
    }
    
    lazy var runOperation: BlockHelpersScriptsRunOperation = BlockHelpersScriptsRunOperationClient(parentURL: baseURL, http: http)
}

// MARK: ../<block_id>/helpers/scripts/run_operation

struct BlockHelpersScriptsRunOperationClient: BlockHelpersScriptsRunOperation {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/helpers/scripts/run_operation */ parentURL.appendingPathComponent("run_operation")
        self.http = http
    }
    
    func post(
        operation: RPCRunnableOperation,
        configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration
    ) async throws -> RunOperationResponse {
        try await http.post(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [], request: RunOperationRequest(from: operation))
    }
}

// MARK: ../<block_id>/operations

struct BlockOperationsClient: BlockOperations {
    let baseURL: URL
    let http: HTTP

    init(parentURL: URL, http: HTTP) {
        self.baseURL = /* ../<block_id>/operations */ parentURL.appendingPathComponent("operations")
        self.http = http
    }
    
    func get(configuredWith configuration: BlockOperationsGetConfiguration) async throws -> GetBlockOperationsResponse {
        try await http.get(baseURL: baseURL, endpoint: "/", headers: configuration.headers, parameters: [])
    }
}
