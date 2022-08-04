//
//  Delegate.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore

// MARK: RPCDelegateDetails

public struct RPCDelegateDetails: Hashable, Codable {
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
