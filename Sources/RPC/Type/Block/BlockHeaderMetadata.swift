//
//  BlockHeaderMetadata.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation
import TezosCore

// MARK: RPCBlockHeaderMetadata

public struct RPCBlockHeaderMetadata: Hashable, Codable {
    public let `protocol`: ProtocolHash
    public let nextProtocol: ProtocolHash
    public let testChainStatus: RPCTestChainStatus
    public let maxOperationsTTL: Int32
    public let maxOperationDataLength: Int32
    public let maxBlockHeaderLength: Int32
    public let maxOperationListLength: [RPCOperationListMetadata]
    public let proposer: KeyHash.Public
    public let baker: KeyHash.Public
    public let levelInfo: RPCLevelInfo
    public let votingPeriodInfo: RPCVotingPeriodInfo
    public let nonceHash: NonceHash?
    public let consumedGas: String
    public let deactivated: [KeyHash.Public]
    public let balanceUpdates: [RPCBalanceUpdate]?
    public let liquidityBakingToggleEma: Int32
    public let implicitOperationsResults: [RPCSuccessfulManagerOperationResult]
    public let consumedMilligas: String
    
    public init(
        `protocol`: ProtocolHash,
        nextProtocol: ProtocolHash,
        testChainStatus: RPCTestChainStatus,
        maxOperationsTTL: Int32,
        maxOperationDataLength: Int32,
        maxBlockHeaderLength: Int32,
        maxOperationListLength: [RPCOperationListMetadata],
        proposer: KeyHash.Public,
        baker: KeyHash.Public,
        levelInfo: RPCLevelInfo,
        votingPeriodInfo: RPCVotingPeriodInfo,
        nonceHash: NonceHash?,
        consumedGas: String,
        deactivated: [KeyHash.Public],
        balanceUpdates: [RPCBalanceUpdate]?,
        liquidityBakingToggleEma: Int32,
        implicitOperationsResults: [RPCSuccessfulManagerOperationResult],
        consumedMilligas: String
    ) {
        self.protocol = `protocol`
        self.nextProtocol = nextProtocol
        self.testChainStatus = testChainStatus
        self.maxOperationsTTL = maxOperationsTTL
        self.maxOperationDataLength = maxOperationDataLength
        self.maxBlockHeaderLength = maxBlockHeaderLength
        self.maxOperationListLength = maxOperationListLength
        self.proposer = proposer
        self.baker = baker
        self.levelInfo = levelInfo
        self.votingPeriodInfo = votingPeriodInfo
        self.nonceHash = nonceHash
        self.consumedGas = consumedGas
        self.deactivated = deactivated
        self.balanceUpdates = balanceUpdates
        self.liquidityBakingToggleEma = liquidityBakingToggleEma
        self.implicitOperationsResults = implicitOperationsResults
        self.consumedMilligas = consumedMilligas
    }
    
    enum CodingKeys: String, CodingKey {
        case `protocol`
        case nextProtocol = "next_protocol"
        case testChainStatus = "test_chain_status"
        case maxOperationsTTL = "max_operations_ttl"
        case maxOperationDataLength = "max_operation_data_length"
        case maxBlockHeaderLength = "max_block_header_length"
        case maxOperationListLength = "max_operation_list_length"
        case proposer
        case baker
        case levelInfo = "level_info"
        case votingPeriodInfo = "voting_period_info"
        case nonceHash = "nonce_hash"
        case consumedGas = "consumed_gas"
        case deactivated
        case balanceUpdates = "balance_updates"
        case liquidityBakingToggleEma = "liquidity_baking_toggle_ema"
        case implicitOperationsResults = "implicit_operations_results"
        case consumedMilligas = "consumed_milligas"
    }
}
