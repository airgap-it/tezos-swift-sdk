//
//  OperationForging.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation
import TezosCore

// MARK: Operation

extension Operation {
    init(fromForged bytes: [UInt8]) throws {
        self = .unsigned(try .init(fromForged: bytes))
    }
}

extension Operation.Unsigned {
    public init(fromForged bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromForgedConsuming: &bytes)
    }
    
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        let branch = try BlockHash(fromConsuming: &bytes)
        let content = try unforgeContent(from: &bytes)
        
        self.init(branch: branch, content: content)
    }
}

extension Operation.`Protocol` {
    public func forge() throws -> [UInt8] {
        let branchBytes = try branch.encodeToBytes()
        let contentsBytes = try forgeContent(content)
        
        return branchBytes + contentsBytes
    }
}

// MARK: Operation.Content

extension Operation.Content {
    public init(fromForged bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromForgedConsuming: &bytes)
    }
    
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        throw fatalError("TODO: implement")
    }
    
    public func forge() throws -> [UInt8] {
        switch self {
        case .seedNonceRevelation(let seedNonceRevelation):
            return try seedNonceRevelation.forge()
        case .doubleEndorsementEvidence(let doubleEndorsementEvidence):
            return try doubleEndorsementEvidence.forge()
        case .doubleBakingEvidence(let doubleBakingEvidence):
            return try doubleBakingEvidence.forge()
        case .activateAccount(let activateAccount):
            return try activateAccount.forge()
        case .proposals(let proposals):
            return try proposals.forge()
        case .ballot(let ballot):
            return try ballot.forge()
        case .doublePreendorsementEvidence(let doublePreendorsementEvidence):
            return try doublePreendorsementEvidence.forge()
        case .failingNoop(let failingNoop):
            return try failingNoop.forge()
        case .preendorsement(let preendorsement):
            return try preendorsement.forge()
        case .endorsement(let endorsement):
            return try endorsement.forge()
        case .reveal(let reveal):
            return try reveal.forge()
        case .transaction(let transaction):
            return try transaction.forge()
        case .origination(let origination):
            return try origination.forge()
        case .delegation(let delegation):
            return try delegation.forge()
        case .registerGlobalConstant(let registerGlobalConstant):
            return try registerGlobalConstant.forge()
        case .setDepositsLimit(let setDepositsLimit):
            return try setDepositsLimit.forge()
        }
    }
}

extension Operation.Content.SeedNonceRevelation {
    public func forge() throws -> [UInt8] {
        let levelBytes = try level.encodeToBytes()
        let nonceBytes = try nonce.encodeToBytes()
        
        return Self.tag + levelBytes + nonceBytes
    }
}

extension Operation.Content.DoubleEndorsementEvidence {
    public func forge() throws -> [UInt8] {
        let op1Bytes = try op1.encodeToBytes()
        let op1Length = try Int32(op1Bytes.count).encodeToBytes()
        
        let op2Bytes = try op2.encodeToBytes()
        let op2Length = try Int32(op2Bytes.count).encodeToBytes()
        
        return Self.tag + op1Length + op1Bytes + op2Length + op2Bytes
    }
}

extension Operation.Content.DoubleBakingEvidence {
    public func forge() throws -> [UInt8] {
        let bh1Bytes = try bh1.encodeToBytes()
        let bh1Length = try Int32(bh1Bytes.count).encodeToBytes()
        
        let bh2Bytes = try bh2.encodeToBytes()
        let bh2Length = try Int32(bh2Bytes.count).encodeToBytes()
        
        return Self.tag + bh1Length + bh1Bytes + bh2Length + bh2Bytes
    }
}

extension Operation.Content.ActivateAccount {
    public func forge() throws -> [UInt8] {
        let pkhBytes = try pkh.encodeToBytes()
        let secretBytes = try secret.encodeToBytes()
        
        return Self.tag + pkhBytes + secretBytes
    }
}

extension Operation.Content.Proposals {
    public func forge() throws -> [UInt8] {
        let sourceBytes = try source.encodeToBytes()
        let periodBytes = try period.encodeToBytes()
        
        let proposalsBytes = try proposals.encodeToBytes { try $0.encodeToBytes() }
        let proposalsLength = try Int32(proposalsBytes.count).encodeToBytes()
        
        return Self.tag + sourceBytes + periodBytes + proposalsLength + proposalsBytes
    }
}

extension Operation.Content.Ballot {
    public func forge() throws -> [UInt8] {
        let sourceBytes = try source.encodeToBytes()
        let periodBytes = try period.encodeToBytes()
        let proposalBytes = try proposal.encodeToBytes()
        let ballotBytes = ballot.value
        
        return Self.tag + sourceBytes + periodBytes + proposalBytes + ballotBytes
    }
}

extension Operation.Content.DoublePreendorsementEvidence {
    public func forge() throws -> [UInt8] {
        let op1Bytes = try op1.encodeToBytes()
        let op1Length = try Int32(op1Bytes.count).encodeToBytes()
        
        let op2Bytes = try op2.encodeToBytes()
        let op2Length = try Int32(op2Bytes.count).encodeToBytes()
        
        return Self.tag + op1Length + op1Bytes + op2Length + op2Bytes
    }
}

extension Operation.Content.FailingNoop {
    public func forge() throws -> [UInt8] {
        let bytes = try arbitrary.encodeToBytes()
        let length = try Int32(bytes.count).encodeToBytes()
        
        return Self.tag + length + bytes
    }
}

extension Operation.Content.Preendorsement {
    public func forge() throws -> [UInt8] {
        let consensusBytes = try forgeConsensusOperation(self)
        
        return Self.tag + consensusBytes
    }
}

extension Operation.Content.Endorsement {
    public func forge() throws -> [UInt8] {
        let consensusBytes = try forgeConsensusOperation(self)
        
        return Self.tag + consensusBytes
    }
}

extension Operation.Content.Reveal {
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        let publicKeyBytes = try publicKey.encodeToBytes()
        
        return Self.tag + managerBytes + publicKeyBytes
    }
}

extension Operation.Content.Transaction {
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        let amountBytes = try amount.encodeToBytes()
        let destinationBytes = try destination.encodeToBytes()
        
        let parametersBytes = try parameters?.encodeToBytes() ?? []
        let parametersPresence = try (!parametersBytes.isEmpty).encodeToBytes()
        
        return Self.tag + managerBytes + amountBytes + destinationBytes + parametersPresence + parametersBytes
    }
}

extension Operation.Content.Origination {
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        let balanceBytes = try balance.encodeToBytes()
        
        let delegateBytes = try delegate?.encodeToBytes() ?? []
        let delegatePresence = try (!delegateBytes.isEmpty).encodeToBytes()
        
        let scriptBytes = try script.encodeToBytes()
        
        return Self.tag + managerBytes + balanceBytes + delegatePresence + delegateBytes + scriptBytes
    }
}

extension Operation.Content.Delegation {
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        
        let delegateBytes = try delegate?.encodeToBytes() ?? []
        let delegatePresence = try (!delegateBytes.isEmpty).encodeToBytes()
        
        return Self.tag + managerBytes + delegatePresence + delegateBytes
    }
}

extension Operation.Content.RegisterGlobalConstant {
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        
        let valueBytes = try value.encodeToBytes()
        let valueLength = try Int32(valueBytes.count).encodeToBytes()
        
        return Self.tag + managerBytes + valueLength + valueBytes
    }
}

extension Operation.Content.SetDepositsLimit {
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        
        let limitBytes = try limit?.encodeToBytes() ?? []
        let limitPresence = try (!limitBytes.isEmpty).encodeToBytes()
        
        return Self.tag + managerBytes + limitPresence + limitBytes
    }
}

// MARK: Utilities: Unforge

private func unforgeContent(from bytes: inout [UInt8], unforged: [Operation.Content] = []) throws -> [Operation.Content] {
    guard !bytes.isEmpty else {
        return unforged
    }
    
    let content = try Operation.Content(fromForgedConsuming: &bytes)
    return try unforgeContent(from: &bytes, unforged: unforged + [content])
}

// MARK: Utilities: Forge

private func forgeContent(_ content: [Operation.Content]) throws -> [UInt8] {
    try content.reduce([]) { acc, next in acc + (try next.forge()) }
}

private func forgeConsensusOperation(_ operation: Operation.Content.Consensus) throws -> [UInt8] {
    let slotBytes = try operation.slot.encodeToBytes()
    let levelBytes = try operation.level.encodeToBytes()
    let roundBytes = try operation.round.encodeToBytes()
    let blockPayloadHashBytes = try operation.blockPayloadHash.encodeToBytes()
    
    return slotBytes + levelBytes + roundBytes + blockPayloadHashBytes
}

private func forgeManagerOperation(_ operation: Operation.Content.Manager) throws -> [UInt8] {
    let sourceBytes = try operation.source.encodeToBytes()
    let feeBytes = try operation.fee.encodeToBytes()
    let counterBytes = operation.counter.encodeToBytes()
    let gasLimitBytes = operation.gasLimit.encodeToBytes()
    let storageLimitBytes = operation.storageLimit.encodeToBytes()

    return sourceBytes + feeBytes + counterBytes + gasLimitBytes + storageLimitBytes
}

private extension Operation.InlinedEndorsement {
    func encodeToBytes() throws -> [UInt8] {
        let branchBytes = try branch.encodeToBytes()
        let operationsBytes = try operations.forge()
        let signatureBytes = try signature.encodeToBytes()
        
        return branchBytes + operationsBytes + signatureBytes
    }
}

private extension Operation.InlinedPreendorsement {
    func encodeToBytes() throws -> [UInt8] {
        let branchBytes = try branch.encodeToBytes()
        let operationsBytes = try operations.forge()
        let signatureBytes = try signature.encodeToBytes()
        
        return branchBytes + operationsBytes + signatureBytes
    }
}

private extension Operation.BlockHeader {
    func encodeToBytes() throws -> [UInt8] {
        let levelBytes = try level.encodeToBytes()
        let protoBytes = try proto.encodeToBytes()
        let predecessorBytes = try predecessor.encodeToBytes()
        let timestampBytes = try timestamp.encodeToBytes()
        let validationPassBytes = try validationPass.encodeToBytes()
        let operationsHashBytes = try operationsHash.encodeToBytes()

        let fitnessBytes = try fitness.encodeToBytes {
            let bytes = try $0.encodeToBytes()
            let length = try Int32(bytes.count).encodeToBytes()
            
            return length + bytes
        }
        let fitnessLength = try Int32(fitnessBytes.count).encodeToBytes()

        let contextBytes = try context.encodeToBytes()
        let payloadHashBytes = try payloadHash.encodeToBytes()
        let payloadRoundBytes = try payloadRound.encodeToBytes()
        let proofOfWorkNonceBytes = try proofOfWorkNonce.encodeToBytes()

        let seedNonceHashBytes = try seedNonceHash?.encodeToBytes() ?? []
        let seedNonceHashPresence = try (!seedNonceHashBytes.isEmpty).encodeToBytes()

        let liquidityBankingEscapeVoteBytes = try liquidityBakingEscapeVote.encodeToBytes()
        let signatureBytes = try signature.encodeToBytes()

        return levelBytes +
            protoBytes +
            predecessorBytes +
            timestampBytes +
            validationPassBytes +
            operationsHashBytes +
            fitnessLength +
            fitnessBytes +
            contextBytes +
            payloadHashBytes +
            payloadRoundBytes +
            proofOfWorkNonceBytes +
            seedNonceHashPresence +
            seedNonceHashBytes +
            liquidityBankingEscapeVoteBytes +
            signatureBytes
    }
}

private extension Operation.Parameters {
    func encodeToBytes() throws -> [UInt8] {
        let entrypointBytes = try entrypoint.encodeToBytes()

        let valueBytes = try value.encodeToBytes()
        let valueLength = try Int32(valueBytes.count).encodeToBytes()

        return entrypointBytes + valueLength + valueBytes
    }
}

private extension Operation.Entrypoint {
    func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .named(let string):
            let bytes = try string.encodeToBytes()
            let length = try UInt8(bytes.count).encodeToBytes()
            
            return tag + length + bytes
        default:
            return tag
        }
    }
}

private extension Operation.Script {
    func encodeToBytes() throws -> [UInt8] {
        let codeBytes = try code.encodeToBytes()
        let codeLength = try Int32(codeBytes.count).encodeToBytes()

        let storageBytes = try storage.encodeToBytes()
        let storageLength = try Int32(storageBytes.count).encodeToBytes()

        return codeLength + codeBytes + storageLength + storageBytes
    }
}

private extension Timestamp {
    func encodeToBytes() throws -> [UInt8] {
        try toMillis().encodeToBytes()
    }
}
