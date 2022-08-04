//
//  ActiveConstants.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import TezosCore

extension RPCConstants {
    
    public struct Active: Hashable, Codable {
        public let proofOfWorkNonceSize: UInt8
        public let nonceLength: UInt8
        public let maxAnonOpsPerBlock: UInt8
        public let maxOperationDataLength: Int32
        public let maxProposalsPerDelegate: UInt8
        public let maxMichelineNodeCount: Int32
        public let maxMichelineBytesLimit: Int32
        public let maxAllowedGlobalConstantsDepth: Int32
        public let cacheLayoutSize: UInt8
        public let michelsonMaximumTypeSize: UInt16
        public let preservedCycles: UInt8
        public let blocksPerCycle: Int32
        public let blocksPerCommitment: Int32
        public let blocksPerStakeSnapshot: Int32
        public let cyclesPerVotingPeriod: Int32
        public let hardGasLimitPerOperation: String
        public let hardGasLimitPerBlock: String
        public let proofOfWorkThreshold: Int64
        public let tokensPerRoll: Mutez
        public let seedNonceRevelationTip: Mutez
        public let originationSize: Int32
        public let bakingRewardFixedPortion: Mutez
        public let bakingRewardBonusPerSlot: Mutez
        public let endorsingRewardPerSlot: Mutez
        public let costPerByte: Mutez
        public let hardStorageLimitPerOperation: String
        public let quorumMin: Int32
        public let quorumMax: Int32
        public let minProposalQuorum: Int32
        public let liquidityBakingSubsidy: Mutez
        public let liquidityBakingSunsetLevel: Int32
        public let liquidityBakingToggleEmaThreshold: Int32
        public let maxOperationsTimeToLive: Int16
        public let minimalBlockDelay: Int64
        public let delayIncrementPerRound: Int64
        public let consensusCommitteeSize: Int32
        public let consensusThreshold: Int32
        public let minimalParticipationRatio: RPCRatio
        public let maxSlashingPeriod: Int32
        public let frozenDepositsPercentage: Int32
        public let doubleBakingPunishment: Mutez
        public let ratioOfFrozenDepositsSlashedPerDoubleEndorsement: RPCRatio
        public let initialSeed: RandomHash?
        public let cacheScriptSize: Int32
        public let cacheStakeDistributionCycles: Int8
        public let cacheSamplerStateCycles: Int8
        public let txRollupEnable: Bool
        public let txRollupOriginationSize: Int32
        public let txRollupHardSizeLimitPerInbox: Int32
        public let txRollupHardSizeLimitPerMessage: Int32
        public let txRollupMaxWithdrawalsPerBatch: Int32
        public let txRollupCommitmentBond: Mutez
        public let txRollupFinalityPeriod: Int32
        public let txRollupWithdrawPeriod: Int32
        public let txRollupMaxInboxesCount: Int32
        public let txRollupMaxMessagesPerInbox: Int32
        public let txRollupMaxCommitmentsCount: Int32
        public let txRollupCostPerByteEmaFactor: Int32
        public let txRollupMaxTicketPayloadSize: Int32
        public let txRollupRejectionMaxProofSize: Int32
        public let txRollupSunsetLevel: Int32
        public let scRollupEnable: Bool
        public let scRollupOriginationSize: Int32
        public let scRollupChallengeWindowInBlocks: Int32
        public let scRollupMaxAvailableMessages: Int32
        
        public init(
            proofOfWorkNonceSize: UInt8,
            nonceLength: UInt8,
            maxAnonOpsPerBlock: UInt8,
            maxOperationDataLength: Int32,
            maxProposalsPerDelegate: UInt8,
            maxMichelineNodeCount: Int32,
            maxMichelineBytesLimit: Int32,
            maxAllowedGlobalConstantsDepth: Int32,
            cacheLayoutSize: UInt8,
            michelsonMaximumTypeSize: UInt16,
            preservedCycles: UInt8,
            blocksPerCycle: Int32,
            blocksPerCommitment: Int32,
            blocksPerStakeSnapshot: Int32,
            cyclesPerVotingPeriod: Int32,
            hardGasLimitPerOperation: String,
            hardGasLimitPerBlock: String,
            proofOfWorkThreshold: Int64,
            tokensPerRoll: Mutez,
            seedNonceRevelationTip: Mutez,
            originationSize: Int32,
            bakingRewardFixedPortion: Mutez,
            bakingRewardBonusPerSlot: Mutez,
            endorsingRewardPerSlot: Mutez,
            costPerByte: Mutez,
            hardStorageLimitPerOperation: String,
            quorumMin: Int32,
            quorumMax: Int32,
            minProposalQuorum: Int32,
            liquidityBakingSubsidy: Mutez,
            liquidityBakingSunsetLevel: Int32,
            liquidityBakingToggleEmaThreshold: Int32,
            maxOperationsTimeToLive: Int16,
            minimalBlockDelay: Int64,
            delayIncrementPerRound: Int64,
            consensusCommitteeSize: Int32,
            consensusThreshold: Int32,
            minimalParticipationRatio: RPCRatio,
            maxSlashingPeriod: Int32,
            frozenDepositsPercentage: Int32,
            doubleBakingPunishment: Mutez,
            ratioOfFrozenDepositsSlashedPerDoubleEndorsement: RPCRatio,
            initialSeed: RandomHash?,
            cacheScriptSize: Int32,
            cacheStakeDistributionCycles: Int8,
            cacheSamplerStateCycles: Int8,
            txRollupEnable: Bool,
            txRollupOriginationSize: Int32,
            txRollupHardSizeLimitPerInbox: Int32,
            txRollupHardSizeLimitPerMessage: Int32,
            txRollupMaxWithdrawalsPerBatch: Int32,
            txRollupCommitmentBond: Mutez,
            txRollupFinalityPeriod: Int32,
            txRollupWithdrawPeriod: Int32,
            txRollupMaxInboxesCount: Int32,
            txRollupMaxMessagesPerInbox: Int32,
            txRollupMaxCommitmentsCount: Int32,
            txRollupCostPerByteEmaFactor: Int32,
            txRollupMaxTicketPayloadSize: Int32,
            txRollupRejectionMaxProofSize: Int32,
            txRollupSunsetLevel: Int32,
            scRollupEnable: Bool,
            scRollupOriginationSize: Int32,
            scRollupChallengeWindowInBlocks: Int32,
            scRollupMaxAvailableMessages: Int32
        ) {
            self.proofOfWorkNonceSize = proofOfWorkNonceSize
            self.nonceLength = nonceLength
            self.maxAnonOpsPerBlock = maxAnonOpsPerBlock
            self.maxOperationDataLength = maxOperationDataLength
            self.maxProposalsPerDelegate = maxProposalsPerDelegate
            self.maxMichelineNodeCount = maxMichelineNodeCount
            self.maxMichelineBytesLimit = maxMichelineBytesLimit
            self.maxAllowedGlobalConstantsDepth = maxAllowedGlobalConstantsDepth
            self.cacheLayoutSize = cacheLayoutSize
            self.michelsonMaximumTypeSize = michelsonMaximumTypeSize
            self.preservedCycles = preservedCycles
            self.blocksPerCycle = blocksPerCycle
            self.blocksPerCommitment = blocksPerCommitment
            self.blocksPerStakeSnapshot = blocksPerStakeSnapshot
            self.cyclesPerVotingPeriod = cyclesPerVotingPeriod
            self.hardGasLimitPerOperation = hardGasLimitPerOperation
            self.hardGasLimitPerBlock = hardGasLimitPerBlock
            self.proofOfWorkThreshold = proofOfWorkThreshold
            self.tokensPerRoll = tokensPerRoll
            self.seedNonceRevelationTip = seedNonceRevelationTip
            self.originationSize = originationSize
            self.bakingRewardFixedPortion = bakingRewardFixedPortion
            self.bakingRewardBonusPerSlot = bakingRewardBonusPerSlot
            self.endorsingRewardPerSlot = endorsingRewardPerSlot
            self.costPerByte = costPerByte
            self.hardStorageLimitPerOperation = hardStorageLimitPerOperation
            self.quorumMin = quorumMin
            self.quorumMax = quorumMax
            self.minProposalQuorum = minProposalQuorum
            self.liquidityBakingSubsidy = liquidityBakingSubsidy
            self.liquidityBakingSunsetLevel = liquidityBakingSunsetLevel
            self.liquidityBakingToggleEmaThreshold = liquidityBakingToggleEmaThreshold
            self.maxOperationsTimeToLive = maxOperationsTimeToLive
            self.minimalBlockDelay = minimalBlockDelay
            self.delayIncrementPerRound = delayIncrementPerRound
            self.consensusCommitteeSize = consensusCommitteeSize
            self.consensusThreshold = consensusThreshold
            self.minimalParticipationRatio = minimalParticipationRatio
            self.maxSlashingPeriod = maxSlashingPeriod
            self.frozenDepositsPercentage = frozenDepositsPercentage
            self.doubleBakingPunishment = doubleBakingPunishment
            self.ratioOfFrozenDepositsSlashedPerDoubleEndorsement = ratioOfFrozenDepositsSlashedPerDoubleEndorsement
            self.initialSeed = initialSeed
            self.cacheScriptSize = cacheScriptSize
            self.cacheStakeDistributionCycles = cacheStakeDistributionCycles
            self.cacheSamplerStateCycles = cacheSamplerStateCycles
            self.txRollupEnable = txRollupEnable
            self.txRollupOriginationSize = txRollupOriginationSize
            self.txRollupHardSizeLimitPerInbox = txRollupHardSizeLimitPerInbox
            self.txRollupHardSizeLimitPerMessage = txRollupHardSizeLimitPerMessage
            self.txRollupMaxWithdrawalsPerBatch = txRollupMaxWithdrawalsPerBatch
            self.txRollupCommitmentBond = txRollupCommitmentBond
            self.txRollupFinalityPeriod = txRollupFinalityPeriod
            self.txRollupWithdrawPeriod = txRollupWithdrawPeriod
            self.txRollupMaxInboxesCount = txRollupMaxInboxesCount
            self.txRollupMaxMessagesPerInbox = txRollupMaxMessagesPerInbox
            self.txRollupMaxCommitmentsCount = txRollupMaxCommitmentsCount
            self.txRollupCostPerByteEmaFactor = txRollupCostPerByteEmaFactor
            self.txRollupMaxTicketPayloadSize = txRollupMaxTicketPayloadSize
            self.txRollupRejectionMaxProofSize = txRollupRejectionMaxProofSize
            self.txRollupSunsetLevel = txRollupSunsetLevel
            self.scRollupEnable = scRollupEnable
            self.scRollupOriginationSize = scRollupOriginationSize
            self.scRollupChallengeWindowInBlocks = scRollupChallengeWindowInBlocks
            self.scRollupMaxAvailableMessages = scRollupMaxAvailableMessages
        }
    
        enum CodingKeys: String, CodingKey {
            case proofOfWorkNonceSize = "proof_of_work_nonce_size"
            case nonceLength = "nonce_length"
            case maxAnonOpsPerBlock = "max_anon_ops_per_block"
            case maxOperationDataLength = "max_operation_data_length"
            case maxProposalsPerDelegate = "max_proposals_per_delegate"
            case maxMichelineNodeCount = "max_micheline_node_count"
            case maxMichelineBytesLimit = "max_micheline_bytes_limit"
            case maxAllowedGlobalConstantsDepth = "max_allowed_global_constants_depth"
            case cacheLayoutSize = "cache_layout_size"
            case michelsonMaximumTypeSize = "michelson_maximum_type_size"
            case preservedCycles = "preserved_cycles"
            case blocksPerCycle = "blocks_per_cycle"
            case blocksPerCommitment = "blocks_per_commitment"
            case blocksPerStakeSnapshot = "blocks_per_stake_snapshot"
            case cyclesPerVotingPeriod = "cycles_per_voting_period"
            case hardGasLimitPerOperation = "hard_gas_limit_per_operation"
            case hardGasLimitPerBlock = "hard_gas_limit_per_block"
            case proofOfWorkThreshold = "proof_of_work_threshold"
            case tokensPerRoll = "tokens_per_roll"
            case seedNonceRevelationTip = "seed_nonce_revelation_tip"
            case originationSize = "origination_size"
            case bakingRewardFixedPortion = "baking_reward_fixed_portion"
            case bakingRewardBonusPerSlot = "baking_reward_bonus_per_slot"
            case endorsingRewardPerSlot = "endorsing_reward_per_slot"
            case costPerByte = "cost_per_byte"
            case hardStorageLimitPerOperation = "hard_storage_limit_per_operation"
            case quorumMin = "quorum_min"
            case quorumMax = "quorum_max"
            case minProposalQuorum = "min_proposal_quorum"
            case liquidityBakingSubsidy = "liquidity_baking_subsidy"
            case liquidityBakingSunsetLevel = "liquidity_baking_sunset_level"
            case liquidityBakingToggleEmaThreshold = "liquidity_baking_toggle_ema_threshold"
            case maxOperationsTimeToLive = "max_operations_time_to_live"
            case minimalBlockDelay = "minimal_block_delay"
            case delayIncrementPerRound = "delay_increment_per_round"
            case consensusCommitteeSize = "consensus_committee_size"
            case consensusThreshold = "consensus_threshold"
            case minimalParticipationRatio = "minimal_participation_ratio"
            case maxSlashingPeriod = "max_slashing_period"
            case frozenDepositsPercentage = "frozen_deposits_percentage"
            case doubleBakingPunishment = "double_baking_punishment"
            case ratioOfFrozenDepositsSlashedPerDoubleEndorsement = "ratio_of_frozen_deposits_slashed_per_double_endorsement"
            case initialSeed = "initial_seed"
            case cacheScriptSize = "cache_script_size"
            case cacheStakeDistributionCycles = "cache_stake_distribution_cycles"
            case cacheSamplerStateCycles = "cache_sampler_state_cycles"
            case txRollupEnable = "tx_rollup_enable"
            case txRollupOriginationSize = "tx_rollup_origination_size"
            case txRollupHardSizeLimitPerInbox = "tx_rollup_hard_size_limit_per_inbox"
            case txRollupHardSizeLimitPerMessage = "tx_rollup_hard_size_limit_per_message"
            case txRollupMaxWithdrawalsPerBatch = "tx_rollup_max_withdrawals_per_batch"
            case txRollupCommitmentBond = "tx_rollup_commitment_bond"
            case txRollupFinalityPeriod = "tx_rollup_finality_period"
            case txRollupWithdrawPeriod = "tx_rollup_withdraw_period"
            case txRollupMaxInboxesCount = "tx_rollup_max_inboxes_count"
            case txRollupMaxMessagesPerInbox = "tx_rollup_max_messages_per_inbox"
            case txRollupMaxCommitmentsCount = "tx_rollup_max_commitments_count"
            case txRollupCostPerByteEmaFactor = "tx_rollup_cost_per_byte_ema_factor"
            case txRollupMaxTicketPayloadSize = "tx_rollup_max_ticket_payload_size"
            case txRollupRejectionMaxProofSize = "tx_rollup_rejection_max_proof_size"
            case txRollupSunsetLevel = "tx_rollup_sunset_level"
            case scRollupEnable = "sc_rollup_enable"
            case scRollupOriginationSize = "sc_rollup_origination_size"
            case scRollupChallengeWindowInBlocks = "sc_rollup_challenge_window_in_blocks"
            case scRollupMaxAvailableMessages = "sc_rollup_max_available_messages"
        }
    }
}
