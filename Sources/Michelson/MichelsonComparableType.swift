//
//  MichelsonComparableType.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import TezosCore

extension Michelson {
    
    public indirect enum ComparableType: MichelsonComparableTypeProtocol, Hashable {
        public typealias `Protocol` = MichelsonComparableTypeProtocol
        
        case unit(Unit)
        case never(Never)
        case bool(Bool)
        case int(Int)
        case nat(Nat)
        case string(String)
        case chainID(ChainID)
        case bytes(Bytes)
        case mutez(Mutez)
        case keyHash(KeyHash)
        case key(Key)
        case signature(Signature)
        case timestamp(Timestamp)
        case address(Address)
        case option(Option)
        case or(Or)
        case pair(Pair)
        
        public var metadata: Metadata {
            common.metadata
        }
        
        public func asMichelsonComparableType() -> ComparableType {
            self
        }
        
        // MARK: unit
        
        public struct Unit: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .unit(self)
            }
            
            public static let name: Swift.String = "unit"
            public static let tag: [UInt8] = [108]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: never
        
        public struct Never: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .never(self)
            }
            
            public static let name: Swift.String = "never"
            public static let tag: [UInt8] = [120]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: bool
        
        public struct Bool: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .bool(self)
            }
            
            public static let name: Swift.String = "bool"
            public static let tag: [UInt8] = [89]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: int
        
        public struct Int: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .int(self)
            }
            
            public static let name: Swift.String = "int"
            public static let tag: [UInt8] = [91]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: nat
        
        public struct Nat: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .nat(self)
            }
            
            public static let name: Swift.String = "nat"
            public static let tag: [UInt8] = [98]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: string
        
        public struct String: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .string(self)
            }
            
            public static let name: Swift.String = "string"
            public static let tag: [UInt8] = [104]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: chain_id
        
        public struct ChainID: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .chainID(self)
            }
            
            public static let name: Swift.String = "chain_id"
            public static let tag: [UInt8] = [116]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: bytes
        
        public struct Bytes: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .bytes(self)
            }
            
            public static let name: Swift.String = "bytes"
            public static let tag: [UInt8] = [105]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: mutez
        
        public struct Mutez: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .mutez(self)
            }
            
            public static let name: Swift.String = "mutez"
            public static let tag: [UInt8] = [106]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: keyhash
        
        public struct KeyHash: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .keyHash(self)
            }
            
            public static let name: Swift.String = "key_hash"
            public static let tag: [UInt8] = [93]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: key
        
        public struct Key: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .key(self)
            }
            
            public static let name: Swift.String = "key"
            public static let tag: [UInt8] = [92]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: signature
        
        public struct Signature: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .signature(self)
            }
            
            public static let name: Swift.String = "signature"
            public static let tag: [UInt8] = [103]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: timestamp
        
        public struct Timestamp: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .timestamp(self)
            }
            
            public static let name: Swift.String = "timestamp"
            public static let tag: [UInt8] = [107]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: address
        
        public struct Address: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .address(self)
            }
            
            public static let name: Swift.String = "address"
            public static let tag: [UInt8] = [110]
            
            public static let entrypointSeparator: Character = "%"
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(metadata: .init(from: annots))
            }
        }
        
        // MARK: option
        
        public struct Option: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .option(self)
            }
            
            public static let name: Swift.String = "option"
            public static let tag: [UInt8] = [99]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asComparableType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<comparable_type>).")
                }
            }
            
            public let type: ComparableType
            public let metadata: Metadata
            
            public init(type: ComparableType, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(type: try args[0].asComparableType(), metadata: .init(from: annots))
            }
            
            subscript(field: Swift.String) -> ComparableType? {
                guard type.metadata.fieldName?.matches(field) ?? false else {
                    return nil
                }
                
                return type
            }
        }
        
        // MARK: or
        
        public struct Or: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .or(self)
            }
            
            public static let name: Swift.String = "or"
            public static let tag: [UInt8] = [100]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asComparableType()) != nil,
                      (try? args[1].asComparableType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<comparable_type>, <comparable_type>).")
                }
            }
            
            public let lhs: ComparableType
            public let rhs: ComparableType
            public let metadata: Metadata
            
            public init(lhs: ComparableType, rhs: ComparableType, metadata: Metadata = .init()) {
                self.lhs = lhs
                self.rhs = rhs
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    lhs: try args[0].asComparableType(),
                    rhs: try args[1].asComparableType(),
                    metadata: .init(from: annots)
                )
            }
            
            subscript(field: Swift.String) -> ComparableType? {
                [lhs, rhs].first(where: { $0.metadata.fieldName?.matches(field) ?? false })
            }
        }
        
        // MARK: pair
        
        public struct Pair: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonComparableType() -> ComparableType {
                .pair(self)
            }
            
            public static let name: Swift.String = "pair"
            public static let tag: [UInt8] = [101]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count >= 2,
                      (try? args.asComparableTypeSequence()) != nil
                else {
                    
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at least 2 arguments (<comparable_type>, <comparable_type>, ...).")
                }
            }
            
            public let types: [ComparableType]
            public let metadata: Metadata
            
            public init(types: [ComparableType], metadata: Metadata = .init()) throws {
                guard types.count >= 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at least 2 arguments.")
                }
                
                self.types = types
                self.metadata = metadata
            }
            
            public init(_ types: ComparableType...) throws {
                try self.init(types: types)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                try self.init(types: try args.asComparableTypeSequence(), metadata: .init(from: annots))
            }
            
            subscript(field: Swift.String) -> ComparableType? {
                types.first(where: { $0.metadata.fieldName?.matches(field) ?? false })
            }
        }
    }
}

public protocol MichelsonComparableTypeProtocol: MichelsonTypeProtocol {
    var metadata: Michelson.ComparableType.Metadata { get }
    
    func asMichelsonComparableType() -> Michelson.ComparableType
}

public extension Michelson.ComparableType.`Protocol` {
    func asMichelsonType() -> Michelson.`Type` {
        .comparable(asMichelsonComparableType())
    }
}

// MARK: Prim

extension Michelson.ComparableType {
    
    public enum Prim: Hashable, RawRepresentable, CaseIterable {
        public typealias `Protocol` = MichelsonComparableTypePrimProtocol
        public typealias RawValue = `Protocol`.Type
        
        case unit
        case never
        case bool
        case int
        case nat
        case string
        case chainID
        case bytes
        case mutez
        case keyHash
        case key
        case signature
        case timestamp
        case address
        case option
        case or
        case pair
        
        public static let allRawValues: [RawValue] = allCases.map { $0.rawValue }
        
        public init?(rawValue: RawValue) {
            switch rawValue {
            case is Unit.Type:
                self = .unit
            case is Never.Type:
                self = .never
            case is Bool.Type:
                self = .bool
            case is Int.Type:
                self = .int
            case is Nat.Type:
                self = .nat
            case is String.Type:
                self = .string
            case is ChainID.Type:
                self = .chainID
            case is Bytes.Type:
                self = .bytes
            case is Mutez.Type:
                self = .mutez
            case is KeyHash.Type:
                self = .keyHash
            case is Key.Type:
                self = .key
            case is Signature.Type:
                self = .signature
            case is Timestamp.Type:
                self = .timestamp
            case is Address.Type:
                self = .address
            case is Option.Type:
                self = .option
            case is Or.Type:
                self = .or
            case is Pair.Type:
                self = .pair
            default:
                return nil
            }
        }
        
        public var rawValue: RawValue {
            switch self {
            case .unit:
                return Unit.self
            case .never:
                return Never.self
            case .bool:
                return Bool.self
            case .int:
                return Int.self
            case .nat:
                return Nat.self
            case .string:
                return String.self
            case .chainID:
                return ChainID.self
            case .bytes:
                return Bytes.self
            case .mutez:
                return Mutez.self
            case .keyHash:
                return KeyHash.self
            case .key:
                return Key.self
            case .signature:
                return Signature.self
            case .timestamp:
                return Timestamp.self
            case .address:
                return Address.self
            case .option:
                return Option.self
            case .or:
                return Or.self
            case .pair:
                return Pair.self
            }
        }
    }
}

public protocol MichelsonComparableTypePrimProtocol: Michelson.`Type`.Prim.`Protocol` {}

// MARK: Metadata

extension Michelson.ComparableType {
    public typealias Metadata = Michelson.`Type`.Metadata
}

// MARK: Utility Extensions

extension Michelson.ComparableType {
    var common: `Protocol` {
        switch self {
        case .unit(let unit):
            return unit
        case .never(let never):
            return never
        case .bool(let bool):
            return bool
        case .int(let int):
            return int
        case .nat(let nat):
            return nat
        case .string(let string):
            return string
        case .chainID(let chainID):
            return chainID
        case .bytes(let bytes):
            return bytes
        case .mutez(let mutez):
            return mutez
        case .keyHash(let keyHash):
            return keyHash
        case .key(let key):
            return key
        case .signature(let signature):
            return signature
        case .timestamp(let timestamp):
            return timestamp
        case .address(let address):
            return address
        case .option(let option):
            return option
        case .or(let or):
            return or
        case .pair(let pair):
            return pair
        }
    }
}
