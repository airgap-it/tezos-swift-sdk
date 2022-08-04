//
//  BlockLevel.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

// MARK: RPCLevelInfo

public struct RPCLevelInfo: Hashable, Codable {
    public let level: Int32
    public let levelPosition: Int32
    public let cycle: Int32
    public let cyclePosition: Int32
    public let expectedCommitment: Bool
    
    public init(level: Int32, levelPosition: Int32, cycle: Int32, cyclePosition: Int32, expectedCommitment: Bool) {
        self.level = level
        self.levelPosition = levelPosition
        self.cycle = cycle
        self.cyclePosition = cyclePosition
        self.expectedCommitment = expectedCommitment
    }
    
    enum CodingKeys: String, CodingKey {
        case level
        case levelPosition = "level_position"
        case cycle
        case cyclePosition = "cycle_position"
        case expectedCommitment = "expected_commitment"
    }
}
