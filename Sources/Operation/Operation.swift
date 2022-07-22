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
    
    public init(branch: BlockHash, contents: [Content] = [], signature: Signature? = nil) {
        if let signature = signature {
            self = .signed(.init(branch: branch, contents: contents, signature: signature))
        } else {
            self = .unsigned(.init(branch: branch, contents: contents))
        }
    }
    
    public var branch: BlockHash {
        switch self {
        case .unsigned(let unsigned):
            return unsigned.branch
        case .signed(let signed):
            return signed.branch
        }
    }
    
    public var contents: [Content] {
        switch self {
        case .unsigned(let unsigned):
            return unsigned.contents
        case .signed(let signed):
            return signed.contents
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
        public let contents: [Content]
        
        public func asOperation() -> TezosOperation {
            .unsigned(self)
        }
    }
    
    // MARK: Signed
    
    public struct Signed: `Protocol`, Hashable {
        public let branch: BlockHash
        public let contents: [Content]
        public let signature: Signature
        
        public func asOperation() -> TezosOperation {
            .signed(self)
        }
    }
}

// MARK: Protocol

public protocol OperationProtocol {
    var branch: BlockHash { get }
    var contents: [TezosOperation.Content] { get }
    
    func asOperation() -> TezosOperation
}
