//
//  BlockHeader.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation
import TezosCore

// MARK: RPCBlockHeader

public struct RPCBlockHeader: Hashable, Codable {
    public let level: Int32
    public let proto: UInt8
    public let predecessor: BlockHash
    public let timestamp: Timestamp
    public let validationPass: UInt8
    public let operationsHash: OperationListListHash
    public let fitness: [String]
    public let context: ContextHash
    public let payloadHash: BlockPayloadHash
    public let payloadRound: Int32
    public let proofOfWorkNonce: String
    public let seedNonceHash: NonceHash?
    public let liquidityBakingToggleVote: RPCVoteToggle
    public let signature: Signature
    
    public init(
        level: Int32,
        proto: UInt8,
        predecessor: BlockHash,
        timestamp: Timestamp,
        validationPass: UInt8,
        operationsHash: OperationListListHash,
        fitness: [String],
        context: ContextHash,
        payloadHash: BlockPayloadHash,
        payloadRound: Int32,
        proofOfWorkNonce: String,
        seedNonceHash: NonceHash?,
        liquidityBakingToggleVote: RPCVoteToggle,
        signature: Signature
    ) {
        self.level = level
        self.proto = proto
        self.predecessor = predecessor
        self.timestamp = timestamp
        self.validationPass = validationPass
        self.operationsHash = operationsHash
        self.fitness = fitness
        self.context = context
        self.payloadHash = payloadHash
        self.payloadRound = payloadRound
        self.proofOfWorkNonce = proofOfWorkNonce
        self.seedNonceHash = seedNonceHash
        self.liquidityBakingToggleVote = liquidityBakingToggleVote
        self.signature = signature
    }
    
    enum CodingKeys: String, CodingKey {
        case level
        case proto
        case predecessor
        case timestamp
        case validationPass = "validation_pass"
        case operationsHash = "operations_hash"
        case fitness
        case context
        case payloadHash = "payload_hash"
        case payloadRound = "payload_round"
        case proofOfWorkNonce = "proof_of_work_nonce"
        case seedNonceHash = "seed_nonce_hash"
        case liquidityBakingToggleVote = "liquidity_baking_toggle_vote"
        case signature
    }
}

// MARK: RPCFullBlockHeader

public struct RPCFullBlockHeader: Hashable, Codable {
    public let `protocol`: ProtocolHash
    public let chainID: ChainID
    public let hash: BlockHash
    public let level: Int32
    public let proto: UInt8
    public let predecessor: BlockHash
    public let timestamp: Timestamp
    public let validationPass: UInt8
    public let operationsHash: OperationListListHash
    public let fitness: [String]
    public let context: ContextHash
    public let payloadHash: BlockPayloadHash
    public let payloadRound: Int32
    public let proofOfWorkNonce: String
    public let seedNonceHash: NonceHash?
    public let liquidityBakingToggleVote: RPCVoteToggle
    public let signature: Signature
    
    public init(
        `protocol`: ProtocolHash,
        chainID: ChainID,
        hash: BlockHash,
        level: Int32,
        proto: UInt8,
        predecessor: BlockHash,
        timestamp: Timestamp,
        validationPass: UInt8,
        operationsHash: OperationListListHash,
        fitness: [String],
        context: ContextHash,
        payloadHash: BlockPayloadHash,
        payloadRound: Int32,
        proofOfWorkNonce: String,
        seedNonceHash: NonceHash?,
        liquidityBakingToggleVote: RPCVoteToggle,
        signature: Signature
    ) {
        self.`protocol` = `protocol`
        self.chainID = chainID
        self.hash = hash
        self.level = level
        self.proto = proto
        self.predecessor = predecessor
        self.timestamp = timestamp
        self.validationPass = validationPass
        self.operationsHash = operationsHash
        self.fitness = fitness
        self.context = context
        self.payloadHash = payloadHash
        self.payloadRound = payloadRound
        self.proofOfWorkNonce = proofOfWorkNonce
        self.seedNonceHash = seedNonceHash
        self.liquidityBakingToggleVote = liquidityBakingToggleVote
        self.signature = signature
    }
    
    enum CodingKeys: String, CodingKey {
        case `protocol`
        case chainID = "chain_id"
        case hash
        case level
        case proto
        case predecessor
        case timestamp
        case validationPass = "validation_pass"
        case operationsHash = "operations_hash"
        case fitness
        case context
        case payloadHash = "payload_hash"
        case payloadRound = "payload_round"
        case proofOfWorkNonce = "proof_of_work_nonce"
        case seedNonceHash = "seed_nonce_hash"
        case liquidityBakingToggleVote = "liquidity_baking_toggle_vote"
        case signature
    }
}
