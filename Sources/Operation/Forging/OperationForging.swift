//
//  OperationForging.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation
import TezosCore
import TezosMichelson

// MARK: Protocol

public protocol ToForged {
    func forge() throws -> [UInt8]
}

public protocol FromForged {
    init(fromForged bytes: [UInt8]) throws
}

protocol FromForgedConsuming: FromForged {
    init(fromForgedConsuming bytes: inout [UInt8]) throws
}

extension FromForgedConsuming {
    public init(fromForged bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromForgedConsuming: &bytes)
    }
}

public typealias Forgeable = FromForged & ToForged
typealias ForgeableConsuming = FromForgedConsuming & ToForged

// MARK: TezosOperation

extension TezosOperation: Forgeable {
    public init(fromForged bytes: [UInt8]) throws {
        self = .unsigned(try .init(fromForged: bytes))
    }
    
    public func forge() throws -> [UInt8] {
        switch self {
        case .unsigned(let unsigned):
            return try unsigned.forge()
        case .signed(let signed):
            return try signed.forge()
        }
    }
}

extension TezosOperation.Unsigned: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        let branch = try BlockHash(fromConsuming: &bytes)
        let contents = try unforgeContent(from: &bytes)
        
        self.init(branch: branch, contents: contents)
    }
    
    public func forge() throws -> [UInt8] {
        let branchBytes = try branch.encodeToBytes()
        let contentsBytes = try forgeContent(contents)
        
        return branchBytes + contentsBytes
    }
}

extension TezosOperation.Signed: ToForged {
    public func forge() throws -> [UInt8] {
        let branchBytes = try branch.encodeToBytes()
        let contentsBytes = try forgeContent(contents)
        
        return branchBytes + contentsBytes
    }
}

// MARK: TezosOperation.Content

extension TezosOperation.Content: ForgeableConsuming {
    
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        guard let kind = Self.resolveKind(from: bytes) else {
            throw TezosError.invalidValue("Invalid encoded Operation.Content value.")
        }
        
        self = try kind.rawValue.init(fromForgedConsuming: &bytes).asContent()
    }
    
    public func forge() throws -> [UInt8] {
        try asForgeable().forge()
    }
}

// MARK: SeedNonceRevelation

extension TezosOperation.Content.SeedNonceRevelation: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.seedNonceRevelation, bytes: &bytes)
        
        let level = try Int32(fromConsuming: &bytes)
        let nonce = try HexString(fromConsuming: &bytes, count: 32)
        
        self.init(level: level, nonce: nonce)
    }
    
    public func forge() throws -> [UInt8] {
        let levelBytes = try level.encodeToBytes()
        let nonceBytes = try nonce.encodeToBytes()
        
        return Self.tag + levelBytes + nonceBytes
    }
}

// MARK: DoubleEndorsementEvidence

extension TezosOperation.Content.DoubleEndorsementEvidence: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.doubleEndorsementEvidence, bytes: &bytes)
        
        let op1Length = try Int32(fromConsuming: &bytes)
        var op1Bytes = bytes.consumeSubrange(0..<Int(op1Length))
        let op1 = try TezosOperation.InlinedEndorsement(fromConsuming: &op1Bytes)
        
        let op2Length = try Int32(fromConsuming: &bytes)
        var op2Bytes = bytes.consumeSubrange(0..<Int(op2Length))
        let op2 = try TezosOperation.InlinedEndorsement(fromConsuming: &op2Bytes)
        
        self.init(op1: op1, op2: op2)
    }
    
    public func forge() throws -> [UInt8] {
        let op1Bytes = try op1.encodeToBytes()
        let op1Length = try Int32(op1Bytes.count).encodeToBytes()
        
        let op2Bytes = try op2.encodeToBytes()
        let op2Length = try Int32(op2Bytes.count).encodeToBytes()
        
        return Self.tag + op1Length + op1Bytes + op2Length + op2Bytes
    }
}

// MARK: DoubleBakingEvidence

extension TezosOperation.Content.DoubleBakingEvidence: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.doubleBakingEvidence, bytes: &bytes)
        
        let bh1Length = try Int32(fromConsuming: &bytes)
        var bh1Bytes = bytes.consumeSubrange(0..<Int(bh1Length))
        let bh1 = try TezosOperation.BlockHeader(fromConsuming: &bh1Bytes)
        
        let bh2Length = try Int32(fromConsuming: &bytes)
        var bh2Bytes = bytes.consumeSubrange(0..<Int(bh2Length))
        let bh2 = try TezosOperation.BlockHeader(fromConsuming: &bh2Bytes)
        
        self.init(bh1: bh1, bh2: bh2)
    }
    
    public func forge() throws -> [UInt8] {
        let bh1Bytes = try bh1.encodeToBytes()
        let bh1Length = try Int32(bh1Bytes.count).encodeToBytes()
        
        let bh2Bytes = try bh2.encodeToBytes()
        let bh2Length = try Int32(bh2Bytes.count).encodeToBytes()
        
        return Self.tag + bh1Length + bh1Bytes + bh2Length + bh2Bytes
    }
}

// MARK: ActivateAccount

extension TezosOperation.Content.ActivateAccount: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.activateAccount, bytes: &bytes)
        
        let pkh = try Ed25519PublicKeyHash(fromConsuming: &bytes)
        let secret = try HexString(fromConsuming: &bytes, count: 20)
        
        self.init(pkh: pkh, secret: secret)
    }
    
    public func forge() throws -> [UInt8] {
        let pkhBytes = try pkh.encodeToBytes()
        let secretBytes = try secret.encodeToBytes()
        
        return Self.tag + pkhBytes + secretBytes
    }
}

// MARK: Proposals

extension TezosOperation.Content.Proposals: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.proposals, bytes: &bytes)
        
        let source = try Address.Implicit(fromConsuming: &bytes)
        let period = try Int32(fromConsuming: &bytes)
        
        let proposalsLength = try Int32(fromConsuming: &bytes)
        var proposalsBytes = bytes.consumeSubrange(0..<Int(proposalsLength))
        let proposals = try [ProtocolHash](fromConsuming: &proposalsBytes) { try ProtocolHash(fromConsuming: &$0) }
        
        self.init(source: source, period: period, proposals: proposals)
    }
    
    public func forge() throws -> [UInt8] {
        let sourceBytes = try source.encodeToBytes()
        let periodBytes = try period.encodeToBytes()
        
        let proposalsBytes = try proposals.encodeToBytes { try $0.encodeToBytes() }
        let proposalsLength = try Int32(proposalsBytes.count).encodeToBytes()
        
        return Self.tag + sourceBytes + periodBytes + proposalsLength + proposalsBytes
    }
}

// MARK: Ballot

extension TezosOperation.Content.Ballot: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.ballot, bytes: &bytes)
        
        let source = try Address.Implicit(fromConsuming: &bytes)
        let period = try Int32(fromConsuming: &bytes)
        let proposal = try ProtocolHash(fromConsuming: &bytes)
        guard let ballot = Kind(fromConsuming: &bytes) else {
            throw TezosError.invalidValue("Invalid encoded OperationContent value.")
        }
        
        self.init(source: source, period: period, proposal: proposal, ballot: ballot)
    }
    
    public func forge() throws -> [UInt8] {
        let sourceBytes = try source.encodeToBytes()
        let periodBytes = try period.encodeToBytes()
        let proposalBytes = try proposal.encodeToBytes()
        let ballotBytes = ballot.encodeToBytes()
        
        return Self.tag + sourceBytes + periodBytes + proposalBytes + ballotBytes
    }
}

// MARK: DoublePreendorsementEvidence

extension TezosOperation.Content.DoublePreendorsementEvidence: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.doublePreendorsementEvidence, bytes: &bytes)
        
        let op1Length = try Int32(fromConsuming: &bytes)
        var op1Bytes = bytes.consumeSubrange(0..<Int(op1Length))
        let op1 = try TezosOperation.InlinedPreendorsement(fromConsuming: &op1Bytes)
        
        let op2Length = try Int32(fromConsuming: &bytes)
        var op2Bytes = bytes.consumeSubrange(0..<Int(op2Length))
        let op2 = try TezosOperation.InlinedPreendorsement(fromConsuming: &op2Bytes)
        
        self.init(op1: op1, op2: op2)
    }
    
    public func forge() throws -> [UInt8] {
        let op1Bytes = try op1.encodeToBytes()
        let op1Length = try Int32(op1Bytes.count).encodeToBytes()
        
        let op2Bytes = try op2.encodeToBytes()
        let op2Length = try Int32(op2Bytes.count).encodeToBytes()
        
        return Self.tag + op1Length + op1Bytes + op2Length + op2Bytes
    }
}

// MARK: FailingNoop

extension TezosOperation.Content.FailingNoop: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.failingNoop, bytes: &bytes)
        
        let length = try Int32(fromConsuming: &bytes)
        var bytes = bytes.consumeSubrange(0..<Int(length))
        let arbitrary = try HexString(fromConsuming: &bytes)
        
        self.init(arbitrary: arbitrary)
    }
    public func forge() throws -> [UInt8] {
        let bytes = try arbitrary.encodeToBytes()
        let length = try Int32(bytes.count).encodeToBytes()
        
        return Self.tag + length + bytes
    }
}

// MARK: Preendorsement

extension TezosOperation.Content.Preendorsement: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.preendorsement, bytes: &bytes)
        
        let (slot, level, round, blockPayloadHash) = try unforgeConsensusOperation(fromConsuming: &bytes)
        self.init(slot: slot, level: level, round: round, blockPayloadHash: blockPayloadHash)
    }
    
    public func forge() throws -> [UInt8] {
        let consensusBytes = try forgeConsensusOperation(self)
        
        return Self.tag + consensusBytes
    }
}

// MARK: Endorsement

extension TezosOperation.Content.Endorsement: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.endorsement, bytes: &bytes)
        
        let (slot, level, round, blockPayloadHash) = try unforgeConsensusOperation(fromConsuming: &bytes)
        self.init(slot: slot, level: level, round: round, blockPayloadHash: blockPayloadHash)
    }
    
    public func forge() throws -> [UInt8] {
        let consensusBytes = try forgeConsensusOperation(self)
        
        return Self.tag + consensusBytes
    }
}

// MARK: Reveal

extension TezosOperation.Content.Reveal: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.reveal, bytes: &bytes)
        
        let (source, fee, counter, gasLimit, storageLimit) = try unforgeManagerOperation(fromConsuming: &bytes)
        let publicKey = try Key.Public(fromConsuming: &bytes)
            
        self.init(
            source: source,
            fee: fee,
            counter: counter,
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            publicKey: publicKey
        )
    }
    
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        let publicKeyBytes = try publicKey.encodeToBytes()
        
        return Self.tag + managerBytes + publicKeyBytes
    }
}

// MARK: Transaction

extension TezosOperation.Content.Transaction: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.transaction, bytes: &bytes)
        
        let (source, fee, counter, gasLimit, storageLimit) = try unforgeManagerOperation(fromConsuming: &bytes)
        let amount = try Mutez(fromConsuming: &bytes)
        let destination = try Address(fromConsuming: &bytes)
        
        let parametersPresence = Bool(fromConsuming: &bytes) ?? false
        let parameters = parametersPresence ? try Parameters(fromConsuming: &bytes) : nil
            
        self.init(
            source: source,
            fee: fee,
            counter: counter,
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            amount: amount,
            destination: destination,
            parameters: parameters
        )
    }
    
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        let amountBytes = try amount.encodeToBytes()
        let destinationBytes = try destination.encodeToBytes()
        
        let parametersBytes = try parameters?.encodeToBytes() ?? []
        let parametersPresence = try (!parametersBytes.isEmpty).encodeToBytes()
        
        return Self.tag + managerBytes + amountBytes + destinationBytes + parametersPresence + parametersBytes
    }
}

// MARK: Origination

extension TezosOperation.Content.Origination: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.origination, bytes: &bytes)
        
        let (source, fee, counter, gasLimit, storageLimit) = try unforgeManagerOperation(fromConsuming: &bytes)
        let balance = try Mutez(fromConsuming: &bytes)
        
        let delegatePresence = Bool(fromConsuming: &bytes) ?? false
        let delegate = delegatePresence ? try Address.Implicit(fromConsuming: &bytes) : nil
        
        let script = try Script(fromConsuming: &bytes)
            
        self.init(
            source: source,
            fee: fee,
            counter: counter,
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            balance: balance,
            delegate: delegate,
            script: script
        )
    }
    
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        let balanceBytes = try balance.encodeToBytes()
        
        let delegateBytes = try delegate?.encodeToBytes() ?? []
        let delegatePresence = try (!delegateBytes.isEmpty).encodeToBytes()
        
        let scriptBytes = try script.encodeToBytes()
        
        return Self.tag + managerBytes + balanceBytes + delegatePresence + delegateBytes + scriptBytes
    }
}

// MARK: Delegation

extension TezosOperation.Content.Delegation: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.delegation, bytes: &bytes)
        
        let (source, fee, counter, gasLimit, storageLimit) = try unforgeManagerOperation(fromConsuming: &bytes)
        
        let delegatePresence = Bool(fromConsuming: &bytes) ?? false
        let delegate = delegatePresence ? try Address.Implicit(fromConsuming: &bytes) : nil
            
        self.init(
            source: source,
            fee: fee,
            counter: counter,
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            delegate: delegate
        )
    }
    
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        
        let delegateBytes = try delegate?.encodeToBytes() ?? []
        let delegatePresence = try (!delegateBytes.isEmpty).encodeToBytes()
        
        return Self.tag + managerBytes + delegatePresence + delegateBytes
    }
}

// MARK: RegisterGlobalConstant

extension TezosOperation.Content.RegisterGlobalConstant: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.registerGlobalConstant, bytes: &bytes)
        
        let (source, fee, counter, gasLimit, storageLimit) = try unforgeManagerOperation(fromConsuming: &bytes)
        
        let valueLength = try Int32(fromConsuming: &bytes)
        var valueBytes = bytes.consumeSubrange(0..<Int(valueLength))
        let value = try Micheline(fromConsuming: &valueBytes)
            
        self.init(
            source: source,
            fee: fee,
            counter: counter,
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            value: value
        )
    }
    
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        
        let valueBytes = try value.encodeToBytes()
        let valueLength = try Int32(valueBytes.count).encodeToBytes()
        
        return Self.tag + managerBytes + valueLength + valueBytes
    }
}

// MARK: SetDepositsLimit

extension TezosOperation.Content.SetDepositsLimit: ForgeableConsuming {
    init(fromForgedConsuming bytes: inout [UInt8]) throws {
        try assertConsumingKind(.setDepositsLimit, bytes: &bytes)
        
        let (source, fee, counter, gasLimit, storageLimit) = try unforgeManagerOperation(fromConsuming: &bytes)
        
        let limitPresence = Bool(fromConsuming: &bytes) ?? false
        let limit = limitPresence ? try Mutez(fromConsuming: &bytes) : nil
            
        self.init(
            source: source,
            fee: fee,
            counter: counter,
            gasLimit: gasLimit,
            storageLimit: storageLimit,
            limit: limit
        )
    }
    
    public func forge() throws -> [UInt8] {
        let managerBytes = try forgeManagerOperation(self)
        
        let limitBytes = try limit?.encodeToBytes() ?? []
        let limitPresence = try (!limitBytes.isEmpty).encodeToBytes()
        
        return Self.tag + managerBytes + limitPresence + limitBytes
    }
}

// MARK: Utilities: Unforge

private func unforgeContent(from bytes: inout [UInt8], unforged: [TezosOperation.Content] = []) throws -> [TezosOperation.Content] {
    guard !bytes.isEmpty else {
        return unforged
    }
    
    let content = try TezosOperation.Content(fromForgedConsuming: &bytes)
    return try unforgeContent(from: &bytes, unforged: unforged + [content])
}

private func unforgeConsensusOperation(
    fromConsuming bytes: inout [UInt8]
) throws -> (slot: UInt16, level: Int32, round: Int32, blockPayloadHash: BlockPayloadHash) {
    let slot = try UInt16(fromConsuming: &bytes)
    let level = try Int32(fromConsuming: &bytes)
    let round = try Int32(fromConsuming: &bytes)
    let blockPayloadHash = try BlockPayloadHash(fromConsuming: &bytes)
    
    return (slot, level, round, blockPayloadHash)
}

private func unforgeManagerOperation(
    fromConsuming bytes: inout [UInt8]
) throws -> (source: Address.Implicit, fee: Mutez, counter: TezosNat, gasLimit: TezosNat, storageLimit: TezosNat) {
    let source = try Address.Implicit(fromConsuming: &bytes)
    let fee = try Mutez(fromConsuming: &bytes)
    let counter = try TezosNat(fromConsuming: &bytes)
    let gasLimit = try TezosNat(fromConsuming: &bytes)
    let storageLimit = try TezosNat(fromConsuming: &bytes)

    return (source, fee, counter, gasLimit, storageLimit)
}

private func assertConsumingKind(_ kind: TezosOperation.Content.Kind, bytes: inout [UInt8]) throws {
    guard TezosOperation.Content.resolveKind(from: bytes) == kind else {
        throw TezosError.invalidValue("Invalid tag, encoded value is not \(kind).")
    }
    
    let _ = bytes.consumeSubrange(0..<kind.rawValue.tag.count)
}

// MARK: Utilities: Forge

private func forgeContent(_ content: [TezosOperation.Content]) throws -> [UInt8] {
    try content.reduce([]) { acc, next in acc + (try next.forge()) }
}

private func forgeConsensusOperation(_ operation: TezosOperation.Content.Consensus) throws -> [UInt8] {
    let slotBytes = try operation.slot.encodeToBytes()
    let levelBytes = try operation.level.encodeToBytes()
    let roundBytes = try operation.round.encodeToBytes()
    let blockPayloadHashBytes = try operation.blockPayloadHash.encodeToBytes()
    
    return slotBytes + levelBytes + roundBytes + blockPayloadHashBytes
}

private func forgeManagerOperation(_ operation: TezosOperation.Content.Manager) throws -> [UInt8] {
    let sourceBytes = try operation.source.encodeToBytes()
    let feeBytes = try operation.fee.encodeToBytes()
    let counterBytes = operation.counter.encodeToBytes()
    let gasLimitBytes = operation.gasLimit.encodeToBytes()
    let storageLimitBytes = operation.storageLimit.encodeToBytes()

    return sourceBytes + feeBytes + counterBytes + gasLimitBytes + storageLimitBytes
}

// MARK: Utility Extensions

private extension TezosOperation.Content {
    static func resolveKind(from bytes: [UInt8]) -> Kind? {
        Kind.allCases.first(where: { bytes.starts(with: $0.rawValue.tag) })
    }
}

private extension TezosOperation.Content {
    func asForgeable() -> Forgeable {
        switch self {
        case .seedNonceRevelation(let seedNonceRevelation):
            return seedNonceRevelation
        case .doubleEndorsementEvidence(let doubleEndorsementEvidence):
            return doubleEndorsementEvidence
        case .doubleBakingEvidence(let doubleBakingEvidence):
            return doubleBakingEvidence
        case .activateAccount(let activateAccount):
            return activateAccount
        case .proposals(let proposals):
            return proposals
        case .ballot(let ballot):
            return ballot
        case .doublePreendorsementEvidence(let doublePreendorsementEvidence):
            return doublePreendorsementEvidence
        case .failingNoop(let failingNoop):
            return failingNoop
        case .preendorsement(let preendorsement):
            return preendorsement
        case .endorsement(let endorsement):
            return endorsement
        case .reveal(let reveal):
            return reveal
        case .transaction(let transaction):
            return transaction
        case .origination(let origination):
            return origination
        case .delegation(let delegation):
            return delegation
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant
        case .setDepositsLimit(let setDepositsLimit):
            return setDepositsLimit
        }
    }
}

private extension TezosOperation.InlinedEndorsement {
    init(fromConsuming bytes: inout [UInt8]) throws {
        let branch = try BlockHash(fromConsuming: &bytes)
        let operations = try TezosOperation.Content.Endorsement(fromForgedConsuming: &bytes)
        let signature = try Signature(fromConsuming: &bytes)
        
        self.init(branch: branch, operations: operations, signature: signature)
    }
    
    func encodeToBytes() throws -> [UInt8] {
        let branchBytes = try branch.encodeToBytes()
        let operationsBytes = try operations.forge()
        let signatureBytes = try signature.encodeToBytes()
        
        return branchBytes + operationsBytes + signatureBytes
    }
}

private extension TezosOperation.InlinedPreendorsement {
    init(fromConsuming bytes: inout [UInt8]) throws {
        let branch = try BlockHash(fromConsuming: &bytes)
        let operations = try TezosOperation.Content.Preendorsement(fromForgedConsuming: &bytes)
        let signature = try Signature(fromConsuming: &bytes)
        
        self.init(branch: branch, operations: operations, signature: signature)
    }
    
    func encodeToBytes() throws -> [UInt8] {
        let branchBytes = try branch.encodeToBytes()
        let operationsBytes = try operations.forge()
        let signatureBytes = try signature.encodeToBytes()
        
        return branchBytes + operationsBytes + signatureBytes
    }
}

private extension TezosOperation.BlockHeader {
    init(fromConsuming bytes: inout [UInt8]) throws {
        let level = try Int32(fromConsuming: &bytes)
        let proto = try UInt8(fromConsuming: &bytes)
        let predecessor = try BlockHash(fromConsuming: &bytes)
        let timestamp = try Timestamp(fromConsuming: &bytes)
        let validationPass = try UInt8(fromConsuming: &bytes)
        let operationsHash = try OperationListListHash(fromConsuming: &bytes)

        let fitnessLength = try Int32(fromConsuming: &bytes)
        var fitnessBytes = bytes.consumeSubrange(0..<Int(fitnessLength))
        let fitness = try [HexString](fromConsuming: &fitnessBytes) {
            let length = try Int32(fromConsuming: &$0)
            return try HexString(fromConsuming: &$0, count: Int(length))
        }

        let context = try ContextHash(fromConsuming: &bytes)
        let payloadHash = try BlockPayloadHash(fromConsuming: &bytes)
        let payloadRound = try Int32(fromConsuming: &bytes)
        let proofOfWorkNonce = try HexString(fromConsuming: &bytes, count: 8)

        let seedNonceHashPresence = Bool(fromConsuming: &bytes) ?? false
        let seedNonceHash = seedNonceHashPresence ? try NonceHash(fromConsuming: &bytes) : nil

        guard let liquidityBakingToggleVote = TezosOperation.LiquidityBakingToggleVote(fromConsuming: &bytes) else {
            throw TezosError.invalidValue("Invalid encoded OperationContent value.")
        }
        
        let signature = try Signature(fromConsuming: &bytes)

        self.init(
            level: level,
            proto: proto,
            predecessor: predecessor,
            timestamp: timestamp,
            validationPass: validationPass,
            operationsHash: operationsHash,
            fitness: fitness,
            context: context,
            payloadHash: payloadHash,
            payloadRound: payloadRound,
            proofOfWorkNonce: proofOfWorkNonce,
            seedNonceHash: seedNonceHash,
            liquidityBakingToggleVote: liquidityBakingToggleVote,
            signature: signature
        )
    }
    
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

        let liquidityBakingToggleVoteBytes = liquidityBakingToggleVote.encodeToBytes()
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
            liquidityBakingToggleVoteBytes +
            signatureBytes
    }
}

private extension Parameters {
    init(fromConsuming bytes: inout [UInt8]) throws {
        let entrypoint = try Entrypoint(fromConsuming: &bytes)
        
        let valueLength = try Int32(fromConsuming: &bytes)
        var valueBytes = bytes.consumeSubrange(0..<Int(valueLength))
        let value = try Micheline(fromConsuming: &valueBytes)
        
        self.init(entrypoint: entrypoint, value: value)
    }
    
    func encodeToBytes() throws -> [UInt8] {
        let entrypointBytes = try entrypoint.encodeToBytes()

        let valueBytes = try value.encodeToBytes()
        let valueLength = try Int32(valueBytes.count).encodeToBytes()

        return entrypointBytes + valueLength + valueBytes
    }
}

private extension Entrypoint {
    init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag.allCases.first(where: { bytes.starts(with: $0.rawValue) }) else {
            throw TezosError.invalidValue("Invalid encoded OperationContent value.")
        }
        
        let _ = bytes.consumeSubrange(0..<tag.rawValue.count)
        if let staticValue = tag.toStaticValue() {
            self = staticValue.toEntrypoint()
        } else {
            let length = try UInt8(fromConsuming: &bytes)
            let name = try String(fromConsuming: &bytes, count: Int(length))
            
            self = .named(name)
        }
    }
    
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

private extension Script {
    init(fromConsuming bytes: inout [UInt8]) throws {
        let codeLength = try Int32(fromConsuming: &bytes)
        var codeBytes = bytes.consumeSubrange(0..<Int(codeLength))
        let code = try Micheline(fromConsuming: &codeBytes)
        
        let storageLength = try Int32(fromConsuming: &bytes)
        var storageBytes = bytes.consumeSubrange(0..<Int(storageLength))
        let storage = try Micheline(fromConsuming: &storageBytes)
        
        self.init(code: code, storage: storage)
    }
    
    func encodeToBytes() throws -> [UInt8] {
        let codeBytes = try code.encodeToBytes()
        let codeLength = try Int32(codeBytes.count).encodeToBytes()

        let storageBytes = try storage.encodeToBytes()
        let storageLength = try Int32(storageBytes.count).encodeToBytes()

        return codeLength + codeBytes + storageLength + storageBytes
    }
}

private extension TezosOperation.Content.Ballot.Kind {
    init?(fromConsuming bytes: inout [UInt8]) {
        guard let kind = Self.allCases.first(where: { bytes.starts(with: $0.value) }) else {
            return nil
        }
        
        let _ = bytes.consumeSubrange(0..<kind.value.count)
        self = kind
    }
    
    func encodeToBytes() -> [UInt8] {
        value
    }
}

private extension TezosOperation.LiquidityBakingToggleVote {
    init?(fromConsuming bytes: inout [UInt8]) {
        guard let toggleVote = Self.allCases.first(where: { bytes.starts(with: $0.value) }) else {
            return nil
        }
        
        let _ = bytes.consumeSubrange(0..<toggleVote.value.count)
        self = toggleVote
    }
    
    func encodeToBytes() -> [UInt8] {
        value
    }
}

private extension Timestamp {
    init(fromConsuming bytes: inout [UInt8]) throws {
        let millis = Timestamp.millis(try Int64(fromConsuming: &bytes))
        self = .rfc3339(millis.toRFC3339())
    }
    
    func encodeToBytes() throws -> [UInt8] {
        try toMillis().encodeToBytes()
    }
}
