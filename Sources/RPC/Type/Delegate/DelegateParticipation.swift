//
//  DelegateParticipation.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import Foundation

// MARK: RPCDelegateParticipation

public struct RPCDelegateParticipation: Hashable, Codable {
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
