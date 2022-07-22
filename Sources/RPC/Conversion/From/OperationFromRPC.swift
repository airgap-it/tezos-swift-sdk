//
//  OperationFromRPC.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore
import TezosOperation

// MARK: TezosOperation

public extension TezosOperation {
    
    init(from operation: RPCOperation) throws {
        self.init(
            branch: operation.branch,
            contents: try operation.contents.map({ try .init(from: $0) }),
            signature: operation.signature
        )
    }
}

// MARK: TezosOperation.Content

public extension TezosOperation.Content {
    
    init(from content: RPCOperation.Content) throws {
        switch content {
        case .seedNonceRevelation(let seedNonceRevelation):
            self = .seedNonceRevelation(try .init(from: seedNonceRevelation))
        case .doubleEndorsementEvidence(let doubleEndorsementEvidence):
            self = .doubleEndorsementEvidence(.init(from: doubleEndorsementEvidence))
        case .doubleBakingEvidence(let doubleBakingEvidence):
            self = .doubleBakingEvidence(try .init(from: doubleBakingEvidence))
        case .activateAccount(let activateAccount):
            self = .activateAccount(try .init(from: activateAccount))
        case .proposals(let proposals):
            self = .proposals(.init(from: proposals))
        case .ballot(let ballot):
            self = .ballot(.init(from: ballot))
        case .doublePreendorsementEvidence(let doublePreendorsementEvidence):
            self = .doublePreendorsementEvidence(.init(from: doublePreendorsementEvidence))
        case .failingNoop(let failingNoop):
            self = .failingNoop(try .init(from: failingNoop))
        case .preendorsement(let preendorsement):
            self = .preendorsement(.init(from: preendorsement))
        case .endorsement(let endorsement):
            self = .endorsement(.init(from: endorsement))
        case .reveal(let reveal):
            self = .reveal(try .init(from: reveal))
        case .transaction(let transaction):
            self = .transaction(try .init(from: transaction))
        case .origination(let origination):
            self = .origination(try .init(from: origination))
        case .delegation(let delegation):
            self = .delegation(try .init(from: delegation))
        case .registerGlobalConstant(let registerGlobalConstant):
            self = .registerGlobalConstant(try .init(from: registerGlobalConstant))
        case .setDepositsLimit(let setDepositsLimit):
            self = .setDepositsLimit(try .init(from: setDepositsLimit))
        }
    }
}
    
// MARK: TezosOperation.Content.SeedNonceRevelation

private extension TezosOperation.Content.SeedNonceRevelation {
    
    init(from content: RPCOperation.Content.SeedNonceRevelation) throws {
        self.init(level: content.level, nonce: try .init(from: content.nonce))
    }
}
    
// MARK: TezosOperation.Content.DoubleEndorsementEvidence

private extension TezosOperation.Content.DoubleEndorsementEvidence {
    
    init(from content: RPCOperation.Content.DoubleEndorsementEvidence) {
        self.init(op1: .init(from: content.op1), op2: .init(from: content.op2))
    }
}

private extension TezosOperation.InlinedEndorsement {
    
    init(from inlinedEndorsement: RPCOperation.Content.InlinedEndorsement) {
        self.init(branch: inlinedEndorsement.branch, operations: .init(from: inlinedEndorsement.operations), signature: inlinedEndorsement.signature)
    }
}
    
// MARK: TezosOperation.Content.DoubleBakingEvidence
            
private extension TezosOperation.Content.DoubleBakingEvidence {
    
    init(from content: RPCOperation.Content.DoubleBakingEvidence) throws {
        self.init(bh1: try .init(from: content.bh1), bh2: try .init(from: content.bh2))
    }
}

private extension TezosOperation.BlockHeader {
    
    init(from blockHeader: RPCBlockHeader) throws {
        self.init(
            level: blockHeader.level,
            proto: blockHeader.proto,
            predecessor: blockHeader.predecessor,
            timestamp: blockHeader.timestamp,
            validationPass: blockHeader.validationPass,
            operationsHash: blockHeader.operationsHash,
            fitness: try blockHeader.fitness.map({ try .init(from: $0) }),
            context: blockHeader.context,
            payloadHash: blockHeader.payloadHash,
            payloadRound: blockHeader.payloadRound,
            proofOfWorkNonce: try .init(from: blockHeader.proofOfWorkNonce),
            seedNonceHash: blockHeader.seedNonceHash,
            liquidityBakingToggleVote: .init(from: blockHeader.liquidityBakingToggleVote),
            signature: blockHeader.signature
        )
    }
}

private extension TezosOperation.LiquidityBakingToggleVote {
    
    init(from toggleVote: RPCLiquidityBakingToggleVote) {
        switch toggleVote {
        case .off:
            self = .off
        case .on:
            self = .on
        case .pass:
            self = .pass
        }
    }
}
    
// MARK: TezosOperation.Content.ActivateAccount

private extension TezosOperation.Content.ActivateAccount {
    
    init(from content: RPCOperation.Content.ActivateAccount) throws {
        self.init(pkh: content.pkh, secret: try .init(from: content.secret))
    }
}

// MARK: TezosOperation.Content.Proposals

private extension TezosOperation.Content.Proposals {
    
    init(from content: RPCOperation.Content.Proposals) {
        self.init(source: content.source, period: content.period, proposals: content.proposals)
    }
}

// MARK: TezosOperation.Content.Ballot

private extension TezosOperation.Content.Ballot {
    
    init(from content: RPCOperation.Content.Ballot) {
        self.init(source: content.source, period: content.period, proposal: content.proposal, ballot: .init(from: content.ballot))
    }
}

private extension TezosOperation.Content.Ballot.Kind {
    
    init(from kind: RPCOperation.Content.Ballot.Kind) {
        switch kind {
        case .yay:
            self = .yay
        case .nay:
            self = .nay
        case .pass:
            self = .pass
        }
    }
}

// MARK: TezosOperation.Content.DoublePreendorsementEvidence

private extension TezosOperation.Content.DoublePreendorsementEvidence {
    
    init(from content: RPCOperation.Content.DoublePreendorsementEvidence) {
        self.init(op1: .init(from: content.op1), op2: .init(from: content.op2))
    }
}

private extension TezosOperation.InlinedPreendorsement {
    
    init(from inlinedPreendorsement: RPCOperation.Content.InlinedPreendorsement) {
        self.init(
            branch: inlinedPreendorsement.branch,
            operations: .init(from: inlinedPreendorsement.operations),
            signature: inlinedPreendorsement.signature
        )
    }
}

// MARK: TezosOperation.Content.FailingNoop

private extension TezosOperation.Content.FailingNoop {
    
    init(from content: RPCOperation.Content.FailingNoop) throws {
        self.init(arbitrary: try .init(from: content.arbitrary))
    }
}

// MARK: TezosOperation.Content.Preendorsement

private extension TezosOperation.Content.Preendorsement {
    
    init(from content: RPCOperation.Content.Preendorsement) {
        self.init(slot: content.slot, level: content.level, round: content.round, blockPayloadHash: content.blockPayloadHash)
    }
}

// MARK: TezosOperation.Content.Endorsement

private extension TezosOperation.Content.Endorsement {
    
    init(from content: RPCOperation.Content.Endorsement) {
        self.init(slot: content.slot, level: content.level, round: content.round, blockPayloadHash: content.blockPayloadHash)
    }
}

// MARK: TezosOperation.Content.Reveal

private extension TezosOperation.Content.Reveal {
    
    init(from content: RPCOperation.Content.Reveal) throws {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: try .init(content.counter),
            gasLimit: try .init(content.gasLimit),
            storageLimit: try .init(content.storageLimit),
            publicKey: content.publicKey
        )
    }
}

// MARK: TezosOperation.Content.Transaction

private extension TezosOperation.Content.Transaction {
    
    init(from content: RPCOperation.Content.Transaction) throws {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: try .init(content.counter),
            gasLimit: try .init(content.gasLimit),
            storageLimit: try .init(content.storageLimit),
            amount: content.amount,
            destination: content.destination,
            parameters: content.parameters
        )
    }
}

// MARK: TezosOperation.Content.Origination

private extension TezosOperation.Content.Origination {
    
    init(from content: RPCOperation.Content.Origination) throws {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: try .init(content.counter),
            gasLimit: try .init(content.gasLimit),
            storageLimit: try .init(content.storageLimit),
            balance: content.balance,
            delegate: content.delegate,
            script: content.script
        )
    }
}

// MARK: TezosOperation.Content.Delegation

private extension TezosOperation.Content.Delegation {
    
    init(from content: RPCOperation.Content.Delegation) throws {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: try .init(content.counter),
            gasLimit: try .init(content.gasLimit),
            storageLimit: try .init(content.storageLimit),
            delegate: content.delegate
        )
    }
}

// MARK: TezosOperation.Content.RegisterGlobalConstant

private extension TezosOperation.Content.RegisterGlobalConstant {
    
    init(from content: RPCOperation.Content.RegisterGlobalConstant) throws {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: try .init(content.counter),
            gasLimit: try .init(content.gasLimit),
            storageLimit: try .init(content.storageLimit),
            value: content.value
        )
    }
}

// MARK: TezosOperation.Content.SetDepositsLimit

private extension TezosOperation.Content.SetDepositsLimit {
    
    init(from content: RPCOperation.Content.SetDepositsLimit) throws {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: try .init(content.counter),
            gasLimit: try .init(content.gasLimit),
            storageLimit: try .init(content.storageLimit),
            limit: content.limit
        )
    }
}
