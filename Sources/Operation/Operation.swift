//
//  Operation.swift
//  
//
//  Created by Julia Samol on 04.07.22.
//

import Foundation
import TezosCore

public enum TezosOperation: Hashable {
    public typealias `Protocol` = OperationProtocol
    
    case unsigned(Unsigned)
    case signed(Signed)
    
    public var branch: BlockHash {
        switch self {
        case .unsigned(let unsigned):
            return unsigned.branch
        case .signed(let signed):
            return signed.branch
        }
    }
    
    public var content: [Content] {
        switch self {
        case .unsigned(let unsigned):
            return unsigned.content
        case .signed(let signed):
            return signed.content
        }
    }
    
    public var signature: Signature? {
        switch self {
        case .unsigned(_):
            return nil
        case .signed(let signed):
            return signed.signature
        }
    }
    
    // MARK: Unsigned
    
    public struct Unsigned: `Protocol`, Hashable {
        public let branch: BlockHash
        public let content: [Content]
        
        public func asOperation() -> TezosOperation {
            .unsigned(self)
        }
    }
    
    // MARK: Signed
    
    public struct Signed: `Protocol`, Hashable {
        public let branch: BlockHash
        public let content: [Content]
        public let signature: Signature
        
        public func asOperation() -> TezosOperation {
            .signed(self)
        }
    }
}

// MARK: Protocol

public protocol OperationProtocol {
    var branch: BlockHash { get }
    var content: [TezosOperation.Content] { get }
    
    func asOperation() -> TezosOperation
}