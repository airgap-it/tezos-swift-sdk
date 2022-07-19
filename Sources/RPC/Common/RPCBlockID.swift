//
//  RPCBlockID.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import Foundation
import TezosCore

public enum RPCBlockID: RawRepresentable, Hashable {
    private static let headRawValue: String = "head"
    
    case head
    case hash(BlockHash)
    case id(Int)
    
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        if rawValue == Self.headRawValue {
            self = .head
        } else if let id = Int(rawValue) {
            self = .id(id)
        } else if let hash = try? BlockHash(base58: rawValue) {
            self = .hash(hash)
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .head:
            return Self.headRawValue
        case .hash(let blockHash):
            return blockHash.base58
        case .id(let int):
            return .init(int)
        }
    }
}
