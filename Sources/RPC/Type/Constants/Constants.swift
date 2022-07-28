//
//  Constants.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import TezosCore

// MARK: RPCConstants

public enum RPCConstants: Hashable, Codable {
    case active(Active)
    
    public var proofOfWorkNonceSize: UInt8 {
        switch self {
        case .active(let active):
            return active.proofOfWorkNonceSize
        }
    }
    
    public var nonceLength: UInt8 {
        switch self {
        case .active(let active):
            return active.nonceLength
        }
    }
    
    public var maxOperationDataLength: Int32 {
        switch self {
        case .active(let active):
            return active.maxOperationDataLength
        }
    }
    
    public var preservedCycles: UInt8 {
        switch self {
        case .active(let active):
            return active.preservedCycles
        }
    }
    
    public var blocksPerCycle: Int32 {
        switch self {
        case .active(let active):
            return active.blocksPerCycle
        }
    }
    
    public var blocksPerCommitment: Int32 {
        switch self {
        case .active(let active):
            return active.blocksPerCommitment
        }
    }
    
    public var michelsonMaximumTypeSize: UInt16 {
        switch self {
        case .active(let active):
            return active.michelsonMaximumTypeSize
        }
    }
    
    public var hardGasLimitPerOperation: String {
        switch self {
        case .active(let active):
            return active.hardGasLimitPerOperation
        }
    }
    
    public var hardGasLimitPerBlock: String {
        switch self {
        case .active(let active):
            return active.hardGasLimitPerBlock
        }
    }
    
    public var proofOfWorkThreshold: Int64 {
        switch self {
        case .active(let active):
            return active.proofOfWorkThreshold
        }
    }
    
    public var tokensPerRoll: Mutez {
        switch self {
        case .active(let active):
            return active.tokensPerRoll
        }
    }
    
    public var seedNonceRevelationTip: Mutez {
        switch self {
        case .active(let active):
            return active.seedNonceRevelationTip
        }
    }
    
    public var costPerByte: Mutez {
        switch self {
        case .active(let active):
            return active.costPerByte
        }
    }
    
    public var hardStorageLimitPerOperation: String {
        switch self {
        case .active(let active):
            return active.hardStorageLimitPerOperation
        }
    }
    
    public var maxAnonOpsPerBlock: UInt8? {
        switch self {
        case .active(let active):
            return active.maxAnonOpsPerBlock
        }
    }
    public var maxProposalsPerDelegate: UInt8? {
        switch self {
        case .active(let active):
            return active.maxProposalsPerDelegate
        }
    }
    public var maxMichelineNodeCount: Int32? {
        switch self {
        case .active(let active):
            return active.maxMichelineNodeCount
        }
    }
    public var maxMichelineBytesLimit: Int32? {
        switch self {
        case .active(let active):
            return active.maxMichelineBytesLimit
        }
    }
    public var maxAllowedGlobalConstantsDepth: Int? {
        switch self {
        case .active(_):
            return nil
        }
    }
    public var cacheLayout: [Int64]? {
        switch self {
        case .active(_):
            return nil
        }
    }
    public var blocksPerStakeSnapshot: Int32? {
        switch self {
        case .active(let active):
            return active.blocksPerStakeSnapshot
        }
    }
    
    public var blocksPerVotingPeriod: Int32? {
        switch self {
        case .active(_):
            return nil
        }
    }
    
    public var originationSize: Int32? {
        switch self {
        case .active(let active):
            return active.originationSize
        }
    }
    
    public var bakingRewardFixedPortion: Mutez? {
        switch self {
        case .active(let active):
            return active.bakingRewardFixedPortion
        }
    }
    
    public var bakingRewardBonusPerSlot: Mutez? {
        switch self {
        case .active(let active):
            return active.bakingRewardBonusPerSlot
        }
    }
    
    public var endorsingRewardPerSlot: Mutez? {
        switch self {
        case .active(let active):
            return active.endorsingRewardPerSlot
        }
    }
    
    public var quorumMin: Int32? {
        switch self {
        case .active(let active):
            return active.quorumMin
        }
    }
    
    public var quorumMax: Int32? {
        switch self {
        case .active(let active):
            return active.quorumMax
        }
    }
    
    public var minProposalQuorum: Int32? {
        switch self {
        case .active(let active):
            return active.minProposalQuorum
        }
    }
    
    public var liquidityBakingSubsidy: Mutez? {
        switch self {
        case .active(let active):
            return active.liquidityBakingSubsidy
        }
    }
    
    public var liquidityBakingSunsetLevel: Int32? {
        switch self {
        case .active(let active):
            return active.liquidityBakingSunsetLevel
        }
    }
    
    public var liquidityBakingEscapeEmaThreshold: Int? {
        switch self {
        case .active(_):
            return nil
        }
    }
    
    public var maxOperationsTimeToLive: Int16? {
        switch self {
        case .active(let active):
            return active.maxOperationsTimeToLive
        }
    }
    
    public var minimalBlockDelay: Int64? {
        switch self {
        case .active(let active):
            return active.minimalBlockDelay
        }
    }
    
    public var delayIncrementPerRound: Int64? {
        switch self {
        case .active(let active):
            return active.delayIncrementPerRound
        }
    }
    
    public var consensusCommitteeSize: Int32? {
        switch self {
        case .active(let active):
            return active.consensusCommitteeSize
        }
    }
    
    public var consensusThreshold: Int32? {
        switch self {
        case .active(let active):
            return active.consensusThreshold
        }
    }
    
    public var minimalParticipationRatio: RPCRatio? {
        switch self {
        case .active(let active):
            return active.minimalParticipationRatio
        }
    }
    
    public var maxSlashingPeriod: Int32? {
        switch self {
        case .active(let active):
            return active.maxSlashingPeriod
        }
    }
    
    public var frozenDepositsPercentage: Int32? {
        switch self {
        case .active(let active):
            return active.frozenDepositsPercentage
        }
    }
    
    public var doubleBakingPunishment: Mutez? {
        switch self {
        case .active(let active):
            return active.doubleBakingPunishment
        }
    }
    
    public var ratioOfFrozenDepositsSlashedPerDoubleEndorsement: RPCRatio? {
        switch self {
        case .active(let active):
            return active.ratioOfFrozenDepositsSlashedPerDoubleEndorsement
        }
    }
    
    public var delegateSelection: RPCDelegateSelection? {
        switch self {
        case .active(_):
            return nil
        }
    }
    
    public var cacheLayoutSize: UInt8? {
        switch self {
        case .active(let active):
            return active.cacheLayoutSize
        }
    }
    
    public var cyclesPerVotingPeriod: Int32? {
        switch self {
        case .active(let active):
            return active.cyclesPerVotingPeriod
        }
    }
    
    public var liquidityBakingToggleEmaThreshold: Int32? {
        switch self {
        case .active(let active):
            return active.liquidityBakingToggleEmaThreshold
        }
    }
    
    public var initialSeed: RandomHash? {
        switch self {
        case .active(let active):
            return active.initialSeed
        }
    }
    
    public var cacheScriptSize: Int32? {
        switch self {
        case .active(let active):
            return active.cacheScriptSize
        }
    }
    
    public var cacheStakeDistributionCycles: Int8? {
        switch self {
        case .active(let active):
            return active.cacheStakeDistributionCycles
        }
    }
    
    public var cacheSamplerStateCycles: Int8? {
        switch self {
        case .active(let active):
            return active.cacheSamplerStateCycles
        }
    }
    
    public var txRollupEnable: Bool? {
        switch self {
        case .active(let active):
            return active.txRollupEnable
        }
    }
    
    public var txRollupOriginationSize: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupOriginationSize
        }
    }
    
    public var txRollupHardSizeLimitPerInbox: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupHardSizeLimitPerInbox
        }
    }
    
    public var txRollupHardSizeLimitPerMessage: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupHardSizeLimitPerMessage
        }
    }
    
    public var txRollupMaxWithdrawalsPerBatch: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupMaxWithdrawalsPerBatch
        }
    }
    
    public var txRollupCommitmentBond: Mutez? {
        switch self {
        case .active(let active):
            return active.txRollupCommitmentBond
        }
    }
    
    public var txRollupFinalityPeriod: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupFinalityPeriod
        }
    }
    
    public var txRollupWithdrawPeriod: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupWithdrawPeriod
        }
    }
    
    public var txRollupMaxInboxesCount: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupMaxInboxesCount
        }
    }
    
    public var txRollupMaxMessagesPerInbox: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupMaxMessagesPerInbox
        }
    }
    
    public var txRollupMaxCommitmentsCount: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupMaxCommitmentsCount
        }
    }
    
    public var txRollupCostPerByteEmaFactor: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupCostPerByteEmaFactor
        }
    }
    
    public var txRollupMaxTicketPayloadSize: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupMaxTicketPayloadSize
        }
    }
    
    public var txRollupRejectionMaxProofSize: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupRejectionMaxProofSize
        }
    }
    
    public var txRollupSunsetLevel: Int32? {
        switch self {
        case .active(let active):
            return active.txRollupSunsetLevel
        }
    }
    
    public var scRollupEnable: Bool? {
        switch self {
        case .active(let active):
            return active.scRollupEnable
        }
    }
    
    public var scRollupOriginationSize: Int32? {
        switch self {
        case .active(let active):
            return active.scRollupOriginationSize
        }
    }
    
    public var scRollupChallengeWindowInBlocks: Int32? {
        switch self {
        case .active(let active):
            return active.scRollupChallengeWindowInBlocks
        }
    }
    
    public var scRollupMaxAvailableMessages: Int32? {
        switch self {
        case .active(let active):
            return active.scRollupMaxAvailableMessages
        }
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        if let active = try? Active(from: decoder) {
            self = .active(active)
        } else {
            throw TezosError.invalidValue("Unknown RPCConstants value.")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .active(let active):
            try active.encode(to: encoder)
        }
    }
}
