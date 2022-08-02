//
//  Operation.swift
//  
//
//  Created by Julia Samol on 04.07.22.
//

import TezosCore

public enum TezosOperation: OperationProtocol, Hashable {
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
        common.branch
    }
    
    public var contents: [Content] {
        common.contents
    }
    
    public var signature: Signature? {
        switch self {
        case .unsigned(_):
            return nil
        case .signed(let signed):
            return signed.signature
        }
    }
    
    public func asOperation() -> TezosOperation {
        self
    }
    
    // MARK: Unsigned
    
    public struct Unsigned: `Protocol`, Hashable {
        public let branch: BlockHash
        public let contents: [Content]
        
        public init(branch: BlockHash, contents: [Content]) {
            self.branch = branch
            self.contents = contents
        }
        
        public func asOperation() -> TezosOperation {
            .unsigned(self)
        }
    }
    
    // MARK: Signed
    
    public struct Signed: `Protocol`, Hashable {
        public let branch: BlockHash
        public let contents: [Content]
        public let signature: Signature
        
        public init(branch: BlockHash, contents: [Content], signature: Signature) {
            self.branch = branch
            self.contents = contents
            self.signature = signature
        }
        
        public func asOperation() -> TezosOperation {
            .signed(self)
        }
    }
}

public protocol OperationProtocol {
    var branch: BlockHash { get }
    var contents: [TezosOperation.Content] { get }
    
    func asOperation() -> TezosOperation
}

// MARK: Utility Extensions

private extension TezosOperation {
    var common: `Protocol` {
        switch self {
        case .unsigned(let unsigned):
            return unsigned
        case .signed(let signed):
            return signed
        }
    }
}
