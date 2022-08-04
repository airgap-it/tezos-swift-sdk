//
//  VotingPeriod.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

// MARK: RPCVotingPeriodInfo

public struct RPCVotingPeriodInfo: Hashable, Codable {
    public let votingPeriod: RPCVotingPeriod
    public let position: Int32
    public let remaining: Int32
    
    enum CodingKeys: String, CodingKey {
        case votingPeriod = "voting_period"
        case position
        case remaining
    }
}

// MARK: RPCVotingPeriod

public struct RPCVotingPeriod: Hashable, Codable {
    public let index: Int32
    public let kind: Kind
    public let startPosition: Int32
    
    public enum Kind: String, Codable {
        case proposal
        case exploration
        case cooldown
        case promotion
        case adoption
    }
    
    enum CodingKeys: String, CodingKey {
        case index
        case kind
        case startPosition = "start_position"
    }
}
