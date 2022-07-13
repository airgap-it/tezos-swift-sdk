//
//  BlockTypes.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore
import TezosMichelson
import TezosOperation

// MARK: ../<block_id>

public typealias GetBlockResponse = RPCBlock

// MARK: ../<block_id>/context/big_maps/<big_map_id>

public typealias GetBigMapResponse = [Micheline]

// MARK: ../<block_id>/context/big_maps/<big_map_id>/value

public typealias GetBigMapValueResponse = Micheline?

// MARK: ../<block_id>/context/constants

public typealias GetConstantsResponse = EmptyResponse

// MARK: ../<block_id>/context/contracts/<contract_id>

public struct GetContractDetailsResponse: Hashable, Codable {
    public let balance: String
    public let delegate: Address.Implicit?
    public let script: TezosOperation.Script?
    public let counter: String?
    
    public init(balance: String, delegate: Address.Implicit? = nil, script: TezosOperation.Script? = nil, counter: String? = nil) {
        self.balance = balance
        self.delegate = delegate
        self.script = script
        self.counter = counter
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/balance

public typealias GetContractBalanceResponse = String

// MARK: ../<block_id>/context/contracts/<contract_id>/counter

public typealias GetContractCounterResponse = String?

// MARK: ../<block_id>/context/contracts/<contract_id>/delegate

public typealias GetContractDelegateResponse = Address.Implicit?

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints

public typealias GetContractEntrypointsResponse = EmptyResponse

// MARK: ../<block_id>/context/contracts/<contract_id>/entrypoints/<string>

public typealias GetContractEntrypointResponse = Micheline

// MARK: ../<block_id>/context/contracts/<contract_id>/manager_key

public typealias GetContractManagerKeyResponse = Key.Public?

// MARK: ../<block_id>/context/contracts/<contract_id>/script

public typealias GetContractScriptResponse = TezosOperation.Script?

// MARK: ../<block_id>/context/contracts/<contract_id>/script/normalized

public struct GetContractNormalizedScriptRequest: Hashable, Codable {
    public let unparsingMode: RPCScriptParsing
    
    public init(unparsingMode: RPCScriptParsing) {
        self.unparsingMode = unparsingMode
    }
    
    enum CodingKeys: String, CodingKey {
        case unparsingMode = "unparsing_mode"
    }
}

public typealias GetContractNormalizedScriptResponse = TezosOperation.Script?

// MARK: ../<block_id>/context/contracts/<contract_id>/single_sapling_get_diff

public typealias GetContractSaplingStateDiffResponse = EmptyResponse

// MARK: ../<block_id>/context/contracts/<contract_id>/storage

public typealias GetContractStorageResponse = Micheline?

// MARK: ../<block_id>/context/contracts/<contract_id>/storage/normalized

public struct GetContractNormalizedStorageRequest: Hashable, Codable {
    public let unparsingMode: RPCScriptParsing
    
    public init(unparsingMode: RPCScriptParsing) {
        self.unparsingMode = unparsingMode
    }
    
    enum CodingKeys: String, CodingKey {
        case unparsingMode = "unparsing_mode"
    }
}

public typealias GetContractNormalizedStorageResponse = Micheline?

// MARK: ../<block_id>/context/delegates/<pkh>

public struct GetDelegateDetailsResponse: Hashable, Codable {
    public let fullBalance: String
    public let currentFrozenDeposits: String
    public let frozenDeposits: String
    public let stakingBalance: String
    public let frozenDepositsLimit: String
    public let delegatedContracts: [Address]
    public let delegatedBalance: String
    public let deactivated: Bool
    public let gracePeriod: Int32
    public let votingPower: Int32
    
    public init(
        fullBalance: String,
        currentFrozenDeposits: String,
        frozenDeposits: String,
        stakingBalance: String,
        frozenDepositsLimit: String,
        delegatedContracts: [Address],
        delegatedBalance: String,
        deactivated: Bool,
        gracePeriod: Int32,
        votingPower: Int32
    ) {
        self.fullBalance = fullBalance
        self.currentFrozenDeposits = currentFrozenDeposits
        self.frozenDeposits = frozenDeposits
        self.stakingBalance = stakingBalance
        self.frozenDepositsLimit = frozenDepositsLimit
        self.delegatedContracts = delegatedContracts
        self.delegatedBalance = delegatedBalance
        self.deactivated = deactivated
        self.gracePeriod = gracePeriod
        self.votingPower = votingPower
    }
    
    enum CodingKeys: String, CodingKey {
        case fullBalance = "full_balance"
        case currentFrozenDeposits = "current_frozen_deposits"
        case frozenDeposits = "frozen_deposits"
        case stakingBalance = "staking_balance"
        case frozenDepositsLimit = "frozen_deposits_limit"
        case delegatedContracts = "delegated_contracts"
        case delegatedBalance = "delegated_balance"
        case deactivated
        case gracePeriod = "grace_period"
        case votingPower = "voting_power"
    }
}

// MARK: ../<block_id>/context/delegates/current_frozen_deposits

public typealias GetDelegateCurrentFrozenDepositsResponse = String

// MARK: ../<block_id>/context/delegates/deactivated

public typealias GetDelegateDeactivatedStatusResponse = Bool

// MARK: ../<block_id>/context/delegates/delegated_balance

public typealias GetDelegateDelegatedBalanceResponse = String

// MARK: ../<block_id>/context/delegates/delegated_contracts

public typealias GetDelegateDelegatedContractsResponse = [Address]

// MARK: ../<block_id>/context/delegates/frozen_deposits

public typealias GetDelegateFrozenDepositsResponse = String

// MARK: ../<block_id>/context/delegates/frozen_deposits_limit

public typealias GetDelegateFrozenDepositsLimitResponse = String

// MARK: ../<block_id>/context/delegates/full_balance

public typealias GetDelegateFullBalanceResponse = String

// MARK: ../<block_id>/context/delegates/grace_period

public typealias GetDelegateGracePeriodResponse = Int32

// MARK: ../<block_id>/context/delegates/participation

public struct GetDelegateParticipationResponse: Hashable, Codable {
    public let expectedCycleActivity: Int32
    public let minimalCycleActivity: Int32
    public let missedSlots: Int32
    public let missedLevels: Int32
    public let remainingAllowedMissedSlots: Int32
    public let expectedEndorsingRewards: Int32
    
    public init(
        expectedCycleActivity: Int32,
        minimalCycleActivity: Int32,
        missedSlots: Int32,
        missedLevels: Int32,
        remainingAllowedMissedSlots: Int32,
        expectedEndorsingRewards: Int32
    ) {
        self.expectedCycleActivity = expectedCycleActivity
        self.minimalCycleActivity = minimalCycleActivity
        self.missedSlots = missedSlots
        self.missedLevels = missedLevels
        self.remainingAllowedMissedSlots = remainingAllowedMissedSlots
        self.expectedEndorsingRewards = expectedEndorsingRewards
    }
    
    enum CodingKeys: String, CodingKey {
        case expectedCycleActivity = "expected_cycle_activity"
        case minimalCycleActivity = "minimal_cycle_activity"
        case missedSlots = "missed_slots"
        case missedLevels = "missed_levels"
        case remainingAllowedMissedSlots = "remaining_allowed_missed_slots"
        case expectedEndorsingRewards = "expected_endorsing_rewards"
    }
}

// MARK: ../<block_id>/context/delegates/staking_balance

public typealias GetDelegateStakingBalanceResponse = String

// MARK: ../<block_id>/context/delegates/voting_power

public typealias GetDelegateVotingPowerResponse = Int32

// MARK: ../<block_id>/context/sapling/<sapling_state_id>/get_diff

public typealias GetSaplingStateDiffResponse = EmptyResponse

// MARK: ../<block_id>/header

public typealias GetBlockHeaderResponse = EmptyResponse

// MARK: ../<block_id>/helpers/preapply/operations

public typealias PreapplyOperationsRequest = RPCApplicableOperation
public typealias PreapplyOperationsResponse = RPCAppliedOperation

// MARK: ../<block_id>/helpers/scripts/run_operation

public struct RunOperationRequest: Hashable, Codable {
    
    public init(from runnableOperation: RPCRunnableOperation) {
        
    }
}

public typealias RunOperationResponse = EmptyResponse

// MARK: ../<block_id>/operations

public typealias GetBlockOperationsResponse = EmptyResponse
