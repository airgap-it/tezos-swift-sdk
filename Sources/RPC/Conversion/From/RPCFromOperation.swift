//
//  RPCFromOperation.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore
import TezosOperation

// MARK: RPCOperation

public extension RPCOperation {
    
    init(from operation: TezosOperation, `protocol`: ProtocolHash, chainID: ChainID, hash: OperationHash, metadata: RPCOperationMetadata? = nil) {
        self.init(
            protocol: `protocol`,
            chainID: chainID,
            hash: hash,
            branch: operation.branch,
            contents: operation.contents.map({ .init(from: $0) }),
            signature: operation.signature,
            metadata: metadata
        )
    }
}

// MARK: RPCOperation.Content

public extension RPCOperation.Content {
    
    init(from content: TezosOperation.Content) {
        switch content {
        case .seedNonceRevelation(let seedNonceRevelation):
            self = .seedNonceRevelation(.init(from: seedNonceRevelation))
        case .doubleEndorsementEvidence(let doubleEndorsementEvidence):
            self = .doubleEndorsementEvidence(.init(from: doubleEndorsementEvidence))
        case .doubleBakingEvidence(let doubleBakingEvidence):
            self = .doubleBakingEvidence(.init(from: doubleBakingEvidence))
        case .activateAccount(let activateAccount):
            self = .activateAccount(.init(from: activateAccount))
        case .proposals(let proposals):
            self = .proposals(.init(from: proposals))
        case .ballot(let ballot):
            self = .ballot(.init(from: ballot))
        case .doublePreendorsementEvidence(let doublePreendorsementEvidence):
            self = .doublePreendorsementEvidence(.init(from: doublePreendorsementEvidence))
        case .failingNoop(let failingNoop):
            self = .failingNoop(.init(from: failingNoop))
        case .preendorsement(let preendorsement):
            self = .preendorsement(.init(from: preendorsement))
        case .endorsement(let endorsement):
            self = .endorsement(.init(from: endorsement))
        case .reveal(let reveal):
            self = .reveal(.init(from: reveal))
        case .transaction(let transaction):
            self = .transaction(.init(from: transaction))
        case .origination(let origination):
            self = .origination(.init(from: origination))
        case .delegation(let delegation):
            self = .delegation(.init(from: delegation))
        case .registerGlobalConstant(let registerGlobalConstant):
            self = .registerGlobalConstant(.init(from: registerGlobalConstant))
        case .setDepositsLimit(let setDepositsLimit):
            self = .setDepositsLimit(.init(from: setDepositsLimit))
        }
    }
}
    
// MARK: RPCOperation.Content.SeedNonceRevelation

private extension RPCOperation.Content.SeedNonceRevelation {
    
    init(from content: TezosOperation.Content.SeedNonceRevelation) {
        self.init(level: content.level, nonce: .init(content.nonce))
    }
}
    
// MARK: RPCOperation.Content.DoubleEndorsementEvidence

private extension RPCOperation.Content.DoubleEndorsementEvidence {
    
    init(from content: TezosOperation.Content.DoubleEndorsementEvidence) {
        self.init(op1: .init(from: content.op1), op2: .init(from: content.op2))
    }
}

private extension RPCOperation.Content.InlinedEndorsement {
    
    init(from inlinedEndorsement: TezosOperation.InlinedEndorsement) {
        self.init(branch: inlinedEndorsement.branch, operations: .init(from: inlinedEndorsement.operations), signature: inlinedEndorsement.signature)
    }
}
    
// MARK: RPCOperation.Content.DoubleBakingEvidence
            
private extension RPCOperation.Content.DoubleBakingEvidence {
    
    init(from content: TezosOperation.Content.DoubleBakingEvidence) {
        self.init(bh1: .init(from: content.bh1), bh2: .init(from: content.bh2))
    }
}

private extension RPCBlockHeader {
    
    init(from blockHeader: TezosOperation.BlockHeader) {
        self.init(
            level: blockHeader.level,
            proto: blockHeader.proto,
            predecessor: blockHeader.predecessor,
            timestamp: blockHeader.timestamp,
            validationPass: blockHeader.validationPass,
            operationsHash: blockHeader.operationsHash,
            fitness: blockHeader.fitness.map({ .init($0) }),
            context: blockHeader.context,
            payloadHash: blockHeader.payloadHash,
            payloadRound: blockHeader.payloadRound,
            proofOfWorkNonce: .init(blockHeader.proofOfWorkNonce),
            seedNonceHash: blockHeader.seedNonceHash,
            liquidityBakingToggleVote: .init(from: blockHeader.liquidityBakingToggleVote),
            signature: blockHeader.signature
        )
    }
}

private extension RPCLiquidityBakingToggleVote {
    
    init(from toggleVote: TezosOperation.LiquidityBakingToggleVote) {
        switch toggleVote {
        case .on:
            self = .on
        case .off:
            self = .off
        case .pass:
            self = .pass
        }
    }
}
    
// MARK: RPCOperation.Content.ActivateAccount

private extension RPCOperation.Content.ActivateAccount {
    
    init(from content: TezosOperation.Content.ActivateAccount) {
        self.init(pkh: content.pkh, secret: .init(content.secret))
    }
}

// MARK: RPCOperation.Content.Proposals

private extension RPCOperation.Content.Proposals {
    
    init(from content: TezosOperation.Content.Proposals) {
        self.init(source: content.source, period: content.period, proposals: content.proposals)
    }
}

// MARK: RPCOperation.Content.Ballot

private extension RPCOperation.Content.Ballot {
    
    init(from content: TezosOperation.Content.Ballot) {
        self.init(source: content.source, period: content.period, proposal: content.proposal, ballot: .init(from: content.ballot))
    }
}

private extension RPCOperation.Content.Ballot.Kind {
    
    init(from kind: TezosOperation.Content.Ballot.Kind) {
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

// MARK: RPCOperation.Content.DoublePreendorsementEvidence

private extension RPCOperation.Content.DoublePreendorsementEvidence {
    
    init(from content: TezosOperation.Content.DoublePreendorsementEvidence) {
        self.init(op1: .init(from: content.op1), op2: .init(from: content.op2))
    }
}

private extension RPCOperation.Content.InlinedPreendorsement {
    
    init(from inlinedPreendorsement: TezosOperation.InlinedPreendorsement) {
        self.init(
            branch: inlinedPreendorsement.branch,
            operations: .init(from: inlinedPreendorsement.operations),
            signature: inlinedPreendorsement.signature
        )
    }
}

// MARK: RPCOperation.Content.FailingNoop

private extension RPCOperation.Content.FailingNoop {
    
    init(from content: TezosOperation.Content.FailingNoop) {
        self.init(arbitrary: .init(content.arbitrary))
    }
}

// MARK: RPCOperation.Content.Preendorsement

private extension RPCOperation.Content.Preendorsement {
    
    init(from content: TezosOperation.Content.Preendorsement) {
        self.init(slot: content.slot, level: content.level, round: content.round, blockPayloadHash: content.blockPayloadHash)
    }
}

// MARK: RPCOperation.Content.Endorsement

private extension RPCOperation.Content.Endorsement {
    
    init(from content: TezosOperation.Content.Endorsement) {
        self.init(slot: content.slot, level: content.level, round: content.round, blockPayloadHash: content.blockPayloadHash)
    }
}

// MARK: RPCOperation.Content.Reveal

private extension RPCOperation.Content.Reveal {
    
    init(from content: TezosOperation.Content.Reveal) {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: content.counter.value,
            gasLimit: content.gasLimit.value,
            storageLimit: content.storageLimit.value,
            publicKey: content.publicKey
        )
    }
}

// MARK: RPCOperation.Content.Transaction

private extension RPCOperation.Content.Transaction {
    
    init(from content: TezosOperation.Content.Transaction) {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: content.counter.value,
            gasLimit: content.gasLimit.value,
            storageLimit: content.storageLimit.value,
            amount: content.amount,
            destination: content.destination,
            parameters: content.parameters
        )
    }
}

// MARK: RPCOperation.Content.Origination

private extension RPCOperation.Content.Origination {
    
    init(from content: TezosOperation.Content.Origination) {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: content.counter.value,
            gasLimit: content.gasLimit.value,
            storageLimit: content.storageLimit.value,
            balance: content.balance,
            delegate: content.delegate,
            script: content.script
        )
    }
}

// MARK: RPCOperation.Content.Delegation

private extension RPCOperation.Content.Delegation {
    
    init(from content: TezosOperation.Content.Delegation) {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: content.counter.value,
            gasLimit: content.gasLimit.value,
            storageLimit: content.storageLimit.value,
            delegate: content.delegate
        )
    }
}

// MARK: RPCOperation.Content.RegisterGlobalConstant

private extension RPCOperation.Content.RegisterGlobalConstant {
    
    init(from content: TezosOperation.Content.RegisterGlobalConstant) {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: content.counter.value,
            gasLimit: content.gasLimit.value,
            storageLimit: content.storageLimit.value,
            value: content.value
        )
    }
}

// MARK: RPCOperation.Content.SetDepositsLimit

private extension RPCOperation.Content.SetDepositsLimit {
    
    init(from content: TezosOperation.Content.SetDepositsLimit) {
        self.init(
            source: content.source,
            fee: content.fee,
            counter: content.counter.value,
            gasLimit: content.gasLimit.value,
            storageLimit: content.storageLimit.value,
            limit: content.limit
        )
    }
}
