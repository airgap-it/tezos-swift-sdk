//
//  StorageDiff.swift
//  
//
//  Created by Julia Samol on 18.07.22.
//

import Foundation
import TezosCore
import TezosMichelson

// MARK: RPCLazyStorageDiff

public enum RPCLazyStorageDiff: Hashable, Codable {
    case bigMap(BigMap)
    case saplingState(SaplingState)
    
    public var id: String {
        switch self {
        case .bigMap(let bigMap):
            return bigMap.id
        case .saplingState(let saplingState):
            return saplingState.id
        }
    }
    
    private enum Kind: String, Codable {
        case bigMap = "big_map"
        case saplingState = "sapling_state"
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .bigMap:
            self = .bigMap(try .init(from: decoder))
        case .saplingState:
            self = .saplingState(try .init(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .bigMap(let bigMap):
            try bigMap.encode(to: encoder)
        case .saplingState(let saplingState):
            try saplingState.encode(to: encoder)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case kind
    }
}

// MARK: RPCLazyStorageDiff.BigMap

extension RPCLazyStorageDiff {
    
    public struct BigMap: Hashable, Codable {
        public let id: String
        public let diff: Diff
        
        public enum Diff: Hashable, Codable {
            case update(Update)
            case remove(Remove)
            case copy(Copy)
            case alloc(Alloc)
            
            public var updates: [UpdateDetails]? {
                switch self {
                case .update(let update):
                    return update.updates
                case .remove(_):
                    return nil
                case .copy(let copy):
                    return copy.updates
                case .alloc(let alloc):
                    return alloc.updates
                }
            }
            
            public var source: String? {
                switch self {
                case .update(_):
                    return nil
                case .remove(_):
                    return nil
                case .copy(let copy):
                    return copy.source
                case .alloc(_):
                    return nil
                }
            }
            
            public var keyType: Micheline? {
                switch self {
                case .update(_):
                    return nil
                case .remove(_):
                    return nil
                case .copy(_):
                    return nil
                case .alloc(let alloc):
                    return alloc.keyType
                }
            }
            
            public var valueType: Micheline? {
                switch self {
                case .update(_):
                    return nil
                case .remove(_):
                    return nil
                case .copy(_):
                    return nil
                case .alloc(let alloc):
                    return alloc.valueType
                }
            }
            
            private enum Action: String, Codable {
                case update
                case remove
                case copy
                case alloc
            }
        }
    }
}

extension RPCLazyStorageDiff.BigMap.Diff {
    
    public struct Update: Hashable, Codable {
        private let action: Action
        public let updates: [UpdateDetails]
        
        public init(updates: [UpdateDetails]) {
            self.action = .update
            self.updates = updates
        }
    }
}

extension RPCLazyStorageDiff.BigMap.Diff {
    
    public struct Remove: Hashable, Codable {
        private let action: Action
        
        public init() {
            self.action = .remove
        }
    }
}

extension RPCLazyStorageDiff.BigMap.Diff {
    
    public struct Copy: Hashable, Codable {
        private let action: Action
        public let source: String
        public let updates: [UpdateDetails]
        
        public init(source: String, updates: [UpdateDetails]) {
            self.action = .copy
            self.source = source
            self.updates = updates
        }
    }
}

extension RPCLazyStorageDiff.BigMap.Diff {
    
    public struct Alloc: Hashable, Codable {
        private let action: Action
        public let updates: [UpdateDetails]
        public let keyType: Micheline
        public let valueType: Micheline
        
        public init(updates: [UpdateDetails], keyType: Micheline, valueType: Micheline) {
            self.action = .alloc
            self.updates = updates
            self.keyType = keyType
            self.valueType = valueType
        }
        
        enum CodingKeys: String, CodingKey {
            case action
            case updates
            case keyType = "key_type"
            case valueType = "value_type"
        }
    }
}

extension RPCLazyStorageDiff.BigMap.Diff {
    
    public struct UpdateDetails: Hashable, Codable {
        public let keyHash: ScriptExprHash
        public let key: Micheline
        public let value: Micheline?
        
        enum CodingKeys: String, CodingKey {
            case keyHash = "key_hash"
            case key
            case value
        }
    }
}

// MARK: RPCLazyStorageDiff.SaplingState

extension RPCLazyStorageDiff {
    
    public struct SaplingState: Hashable, Codable {
        public let id: String
        public let diff: Diff
        
        public enum Diff: Hashable, Codable {
            case update(Update)
            case remove(Remove)
            case copy(Copy)
            case alloc(Alloc)
            
            public var updates: [UpdateDetails]? {
                switch self {
                case .update(let update):
                    return update.updates
                case .remove(_):
                    return nil
                case .copy(let copy):
                    return copy.updates
                case .alloc(let alloc):
                    return alloc.updates
                }
            }
            
            public var source: String? {
                switch self {
                case .update(_):
                    return nil
                case .remove(_):
                    return nil
                case .copy(let copy):
                    return copy.source
                case .alloc(_):
                    return nil
                }
            }
            
            public var memoSize: UInt16? {
                switch self {
                case .update(_):
                    return nil
                case .remove(_):
                    return nil
                case .copy(_):
                    return nil
                case .alloc(let alloc):
                    return alloc.memoSize
                }
            }
            
            private enum Action: String, Codable {
                case update
                case remove
                case copy
                case alloc
            }
        }
    }
}

extension RPCLazyStorageDiff.SaplingState.Diff {
    
    public struct Update: Hashable, Codable {
        private let action: Action
        public let updates: [UpdateDetails]
        
        public init(updates: [UpdateDetails]) {
            self.action = .update
            self.updates = updates
        }
    }
}

extension RPCLazyStorageDiff.SaplingState.Diff {
    
    public struct Remove: Hashable, Codable {
        private let action: Action
        
        public init() {
            self.action = .remove
        }
    }
}

extension RPCLazyStorageDiff.SaplingState.Diff {
    
    public struct Copy: Hashable, Codable {
        private let action: Action
        public let source: String
        public let updates: [UpdateDetails]
        
        public init(source: String, updates: [UpdateDetails]) {
            self.action = .copy
            self.source = source
            self.updates = updates
        }
    }
}

extension RPCLazyStorageDiff.SaplingState.Diff {
    
    public struct Alloc: Hashable, Codable {
        private let action: Action
        public let updates: [UpdateDetails]
        public let memoSize: UInt16
        
        public init(updates: [UpdateDetails], memoSize: UInt16) {
            self.action = .alloc
            self.updates = updates
            self.memoSize = memoSize
        }
        
        enum CodingKeys: String, CodingKey {
            case action
            case updates
            case memoSize = "memo_size"
        }
    }
}

extension RPCLazyStorageDiff.SaplingState.Diff {
    
    public struct UpdateDetails: Hashable, Codable {
        public let commitmentsAndCiphertexts: [Tuple<HexString, RPCSaplingCiphertext>]
        public let nullifiers: HexString
        
        enum CodingKeys: String, CodingKey {
            case commitmentsAndCiphertexts = "commitments_and_ciphertexts"
            case nullifiers
        }
    }
}
