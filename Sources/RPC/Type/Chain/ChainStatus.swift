//
//  ChainStatus.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation
import TezosCore

// MARK: RPCChainBootstrappedStatus

public struct RPCChainBootstrappedStatus: Hashable, Codable {
    public let bootstrapped: Bool
    public let syncState: RPCChainStatus
    
    public init(bootstrapped: Bool, syncState: RPCChainStatus) {
        self.bootstrapped = bootstrapped
        self.syncState = syncState
    }
    
    enum CodingKeys: String, CodingKey {
        case bootstrapped
        case syncState = "sync_state"
    }
}

// MARK: RPCTestChainStatus

public enum RPCTestChainStatus: Hashable, Codable {
    case notRunning
    case forking(Forking)
    case running(Running)
    
    public struct Forking: Hashable, Codable {
        private let status: Kind
        public let `protocol`: ProtocolHash
        public let expiration: Timestamp
        
        public init(`protocol`: ProtocolHash, expiration: Timestamp) {
            self.status = .forking
            self.protocol = `protocol`
            self.expiration = expiration
        }
    }
    
    public struct Running: Hashable, Codable {
        private let status: Kind
        public let chainID: ChainID
        public let genesis: BlockHash
        public let `protocol`: ProtocolHash
        public let expiration: Timestamp
        
        public init(chainID: ChainID, genesis: BlockHash, `protocol`: ProtocolHash, expiration: Timestamp) {
            self.status = .running
            self.chainID = chainID
            self.genesis = genesis
            self.protocol = `protocol`
            self.expiration = expiration
        }
        
        enum CodingKeys: String, CodingKey {
            case status
            case chainID = "chain_id"
            case genesis
            case `protocol`
            case expiration
        }
    }
    
    private enum Kind: String, Codable {
        case notRunning = "not_running"
        case forking
        case running
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        guard let kind = Kind(rawValue: status) else {
            throw TezosError.invalidValue("Unknown TestChainStatus kind.")
        }
        
        switch kind {
        case .notRunning:
            self = .notRunning
        case .forking:
            self = .forking(try .init(from: decoder))
        case .running:
            self = .running(try .init(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .notRunning:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(Kind.notRunning.rawValue, forKey: .status)
        case .forking(let forking):
            try forking.encode(to: encoder)
        case .running(let running):
            try running.encode(to: encoder)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case status
    }
}
