//
//  BlockHeader.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation
import TezosCore

extension Operation {
    public typealias ShellBlockHeader = ShellBlockHeaderProtocol
    public typealias ProtocolBlockHeader = ProtocolBlockHeaderProtocol
    
    public struct BlockHeader: Hashable, ShellBlockHeader, ProtocolBlockHeader {
        public let level: Int
        public let proto: UInt8
        public let predecessor: BlockHash
        public let timestamp: Timestamp
        public let validationPass: UInt8
        public let operationsHash: OperationListListHash
        public let fitness: [HexString]
        public let context: ContextHash
        public let payloadHash: BlockPayloadHash
        public let payloadRound: Int
        public let proofOfWorkNonce: HexString
        public let seedNonceHash: NonceHash?
        public let liquidityBakingEscapeVote: Bool
        public let signature: Signature
        
        public init(
            level: Int,
            proto: UInt8,
            predecessor: BlockHash,
            timestamp: Timestamp,
            validationPass: UInt8,
            operationsHash: OperationListListHash,
            fitness: [HexString],
            context: ContextHash,
            payloadHash: BlockPayloadHash,
            payloadRound: Int,
            proofOfWorkNonce: HexString,
            seedNonceHash: NonceHash? = nil,
            liquidityBakingEscapeVote: Bool,
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
            self.liquidityBakingEscapeVote = liquidityBakingEscapeVote
            self.signature = signature
        }
    }
}

public protocol ShellBlockHeaderProtocol {
    var level: Int { get }
    var proto: UInt8 { get }
    var predecessor: BlockHash { get }
    var timestamp: Timestamp { get }
    var validationPass: UInt8 { get }
    var operationsHash: OperationListListHash { get }
    var fitness: [HexString] { get }
    var context: ContextHash { get }
}

public protocol ProtocolBlockHeaderProtocol {
    var payloadHash: BlockPayloadHash { get }
    var payloadRound: Int { get }
    var proofOfWorkNonce: HexString { get }
    var seedNonceHash: NonceHash? { get }
    var liquidityBakingEscapeVote: Bool { get }
    var signature: Signature { get }
}
