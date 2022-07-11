//
//  Chain.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation

// MARK: ChainStatus

public enum RPCChainStatus: String, Hashable, Codable {
    case stuck
    case synced
    case unsynced
}
