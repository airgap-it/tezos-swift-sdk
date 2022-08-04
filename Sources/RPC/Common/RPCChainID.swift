//
//  RPCChainID.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore

public enum RPCChainID: RawRepresentable, Hashable {
    private static let mainRawValue: String = "main"
    private static let testRawValue: String = "test"
    
    case main
    case test
    case id(ChainID)
    
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        switch rawValue {
        case Self.mainRawValue:
            self = .main
        case Self.testRawValue:
            self = .test
        default:
            guard let id = try? ChainID(base58: rawValue) else {
                return nil
            }
            
            self = .id(id)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .main:
            return Self.mainRawValue
        case .test:
            return Self.testRawValue
        case .id(let chainID):
            return chainID.base58
        }
    }
}
