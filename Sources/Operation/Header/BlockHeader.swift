//
//  BlockHeader.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import TezosCore

extension TezosOperation {
    
    public struct BlockHeader: Hashable {
        public let level: Int32
        public let proto: UInt8
        public let predecessor: BlockHash
        public let timestamp: Timestamp
        public let validationPass: UInt8
        public let operationsHash: OperationListListHash
        public let fitness: [HexString]
        public let context: ContextHash
        public let payloadHash: BlockPayloadHash
        public let payloadRound: Int32
        public let proofOfWorkNonce: HexString
        public let seedNonceHash: NonceHash?
        public let liquidityBakingToggleVote: LiquidityBakingToggleVote
        public let signature: Signature
        
        public init(
            level: Int32,
            proto: UInt8,
            predecessor: BlockHash,
            timestamp: Timestamp,
            validationPass: UInt8,
            operationsHash: OperationListListHash,
            fitness: [HexString],
            context: ContextHash,
            payloadHash: BlockPayloadHash,
            payloadRound: Int32,
            proofOfWorkNonce: HexString,
            seedNonceHash: NonceHash? = nil,
            liquidityBakingToggleVote: LiquidityBakingToggleVote,
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
    }
    
    public enum LiquidityBakingToggleVote: BytesTagIterable {
        case on
        case off
        case pass
        
        public var value: [UInt8] {
            switch self {
            case .on:
                return [0]
            case .off:
                return [1]
            case .pass:
                return [2]
            }
        }
    }
}
