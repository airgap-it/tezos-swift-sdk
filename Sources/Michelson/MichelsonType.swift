//
//  MichelsonType.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import TezosCore

extension Michelson {
    // TODO: refactor
    public typealias Type_ = `Type`
    
    public indirect enum `Type`: MichelsonTypeProtocol, Hashable {
        public typealias `Protocol` = MichelsonTypeProtocol
        
        case parameter(Parameter)
        case storage(Storage)
        case code(Code)
        case option(Option)
        case list(List)
        case set(Set)
        case operation(Operation)
        case contract(Contract)
        case ticket(Ticket)
        case pair(Pair)
        case or(Or)
        case lambda(Lambda)
        case map(Map)
        case bigMap(BigMap)
        case bls12_381G1(Bls12_381G1)
        case bls12_381G2(Bls12_381G2)
        case bls12_381Fr(Bls12_381Fr)
        case saplingTransaction(SaplingTransaction)
        case saplingState(SaplingState)
        case chest(Chest)
        case chestKey(ChestKey)
        case comparable(ComparableType)
        
        public var metadata: Metadata {
            common.metadata
        }
        
        public func asMichelsonType() -> `Type` {
            self
        }
        
        // MARK: parameter
        
        public struct Parameter: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .parameter(self)
            }
            
            public static let name: String = "parameter"
            public static let tag: [UInt8] = [0]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(type: try args[0].asType(), metadata: .init(from: annots))
            }
        }
        
        // MARK: storage
        
        public struct Storage: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .storage(self)
            }
            
            public static let name: String = "storage"
            public static let tag: [UInt8] = [1]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(type: try args[0].asType(), metadata: .init(from: annots))
            }
        }
        
        // MARK: code
        
        public struct Code: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .code(self)
            }
            
            public static let name: String = "code"
            public static let tag: [UInt8] = [2]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asInstruction()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<instruction>).")
                }
            }
            
            public let code: Instruction
            public let metadata: Metadata
            
            public init(code: Instruction, metadata: Metadata = .init()) {
                self.code = code
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(code: try args[0].asInstruction(), metadata: .init(from: annots))
            }
        }
        
        // MARK: option
        
        public struct Option: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .option(self)
            }
            
            public static let name: String = "option"
            public static let tag: [UInt8] = [99]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(type: try args[0].asType(), metadata: .init(from: annots))
            }
            
            subscript(field: String) -> `Type`? {
                guard type.metadata.fieldName?.matches(field) ?? false else {
                    return nil
                }
                
                return type
            }
        }
        
        // MARK: list
        
        public struct List: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .list(self)
            }
            
            public static let name: String = "list"
            public static let tag: [UInt8] = [95]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(type: try args[0].asType(), metadata: .init(from: annots))
            }
        }
        
        // MARK: set
        
        public struct Set: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .set(self)
            }
            
            public static let name: String = "set"
            public static let tag: [UInt8] = [102]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
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
        }
        
        // MARK: operation
        
        public struct Operation: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .operation(self)
            }
            
            public static let name: String = "operation"
            public static let tag: [UInt8] = [109]
            
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
        
        // MARK: contract
        
        public struct Contract: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .contract(self)
            }
            
            public static let name: String = "contract"
            public static let tag: [UInt8] = [90]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(type: try args[0].asType(), metadata: .init(from: annots))
            }
        }
        
        // MARK: ticket
        
        public struct Ticket: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .ticket(self)
            }
            
            public static let name: String = "ticket"
            public static let tag: [UInt8] = [135]
            
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
        }
        
        // MARK: pair
        
        public struct Pair: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .pair(self)
            }
            
            public static let name: String = "pair"
            public static let tag: [UInt8] = [101]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count >= 2,
                      (try? args.asTypeSequence()) != nil,
                      (try? args.asComparableTypeSequence()) == nil
                else {
                    
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at least 2 arguments (<type>, <type>, ...).")
                }
            }
            
            public let types: [`Type`]
            public let metadata: Metadata
            
            public init(types: [`Type`], metadata: Metadata = .init()) throws {
                guard types.count >= 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at least 2 arguments.")
                }
                
                self.types = types
                self.metadata = metadata
            }
            
            public init(_ types: `Type`...) throws {
                try self.init(types: types)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                try self.init(types: try args.asTypeSequence(), metadata: .init(from: annots))
            }
            
            subscript(field: String) -> `Type`? {
                types.first(where: { $0.metadata.fieldName?.matches(field) ?? false })
            }
        }
        
        // MARK: or
        
        public struct Or: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .or(self)
            }
            
            public static let name: String = "or"
            public static let tag: [UInt8] = [100]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asType()) != nil,
                      (try? args[1].asType()) != nil,
                      (try? args[0].asComparableType()) == nil,
                      (try? args[1].asComparableType()) == nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<type>, <type>).")
                }
            }
            
            public let lhs: `Type`
            public let rhs: `Type`
            public let metadata: Metadata
            
            public init(lhs: `Type`, rhs: `Type`, metadata: Metadata = .init()) {
                self.lhs = lhs
                self.rhs = rhs
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    lhs: try args[0].asType(),
                    rhs: try args[1].asType(),
                    metadata: .init(from: annots)
                )
            }
            
            subscript(field: String) -> `Type`? {
                [lhs, rhs].first(where: { $0.metadata.fieldName?.matches(field) ?? false })
            }
        }
        
        // MARK: lambda
        
        public struct Lambda: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .lambda(self)
            }
            
            public static let name: String = "lambda"
            public static let tag: [UInt8] = [94]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asType()) != nil,
                      (try? args[1].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<type>, <type>).")
                }
            }
            
            public let parameterType: `Type`
            public let returnType: `Type`
            public let metadata: Metadata
            
            public init(parameterType: `Type`, returnType: `Type`, metadata: Metadata = .init()) {
                self.parameterType = parameterType
                self.returnType = returnType
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    parameterType: try args[0].asType(),
                    returnType: try args[1].asType(),
                    metadata: .init(from: annots)
                )
            }
        }
        
        // MARK: map
        
        public struct Map: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .map(self)
            }
            
            public static let name: String = "map"
            public static let tag: [UInt8] = [96]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asComparableType()) != nil,
                      (try? args[1].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<comparable_type>, <type>).")
                }
            }
            
            public let keyType: ComparableType
            public let valueType: `Type`
            public let metadata: Metadata
            
            public init(keyType: ComparableType, valueType: `Type`, metadata: Metadata = .init()) {
                self.keyType = keyType
                self.valueType = valueType
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    keyType: try args[0].asComparableType(),
                    valueType: try args[1].asType(),
                    metadata: .init(from: annots)
                )
            }
        }
        
        // MARK: big_map
        
        public struct BigMap: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .bigMap(self)
            }
            
            public static let name: String = "big_map"
            public static let tag: [UInt8] = [97]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asComparableType()) != nil,
                      (try? args[1].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<comparable_type>, <type>).")
                }
            }
            
            public let keyType: ComparableType
            public let valueType: `Type`
            public let metadata: Metadata
            
            public init(keyType: ComparableType, valueType: `Type`, metadata: Metadata = .init()) {
                self.keyType = keyType
                self.valueType = valueType
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    keyType: try args[0].asComparableType(),
                    valueType: try args[1].asType(),
                    metadata: .init(from: annots)
                )
            }
        }
        
        // MARK: bls12_381_g1
        
        public struct Bls12_381G1: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .bls12_381G1(self)
            }
            
            public static let name: String = "bls12_381_g1"
            public static let tag: [UInt8] = [128]
            
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
        
        // MARK: bls12_381_g2
        
        public struct Bls12_381G2: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .bls12_381G2(self)
            }
            
            public static let name: String = "bls12_381_g2"
            public static let tag: [UInt8] = [129]
            
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
        
        // MARK: bls12_381_fr
        
        public struct Bls12_381Fr: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .bls12_381Fr(self)
            }
            
            public static let name: String = "bls12_381_fr"
            public static let tag: [UInt8] = [130]
            
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
        
        // MARK: sapling_transaction
        
        public struct SaplingTransaction: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .saplingTransaction(self)
            }
            
            public static let name: String = "sapling_transaction"
            public static let tag: [UInt8] = [132]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<natural_number_constant>).")
                }
            }
            
            public let memoSize: Data.NaturalNumberConstant
            public let metadata: Metadata
            
            public init(memoSize: Data.NaturalNumberConstant, metadata: Metadata = .init()) {
                self.memoSize = memoSize
                self.metadata = metadata
            }
            
            public init(memoSize: UInt, metadata: Metadata = .init()) {
                self.init(memoSize: .init(memoSize), metadata: metadata)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    memoSize: try args[0].tryAs(Data.NaturalNumberConstant.self),
                    metadata: .init(from: annots)
                )
            }
        }
        
        // MARK: sapling_state
        
        public struct SaplingState: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .saplingState(self)
            }
            
            public static let name: String = "sapling_state"
            public static let tag: [UInt8] = [131]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<natural_number_constant>).")
                }
            }
            
            public let memoSize: Data.NaturalNumberConstant
            public let metadata: Metadata
            
            public init(memoSize: Data.NaturalNumberConstant, metadata: Metadata = .init()) {
                self.memoSize = memoSize
                self.metadata = metadata
            }
            
            public init(memoSize: UInt, metadata: Metadata = .init()) {
                self.init(memoSize: .init(memoSize), metadata: metadata)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    memoSize: try args[0].tryAs(Data.NaturalNumberConstant.self),
                    metadata: .init(from: annots)
                )
            }
        }
        
        // MARK: chest
        
        public struct Chest: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .chest(self)
            }
            
            public static let name: String = "chest"
            public static let tag: [UInt8] = [141]
            
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
        
        // MARK: chest_key
        
        public struct ChestKey: `Protocol`, Prim, Hashable {
            public func asMichelsonType() -> `Type` {
                .chestKey(self)
            }
            
            public static let name: String = "chest_key"
            public static let tag: [UInt8] = [142]
            
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
    }
}

public protocol MichelsonTypeProtocol: Michelson.`Protocol` {
    var metadata: Michelson.`Type`.Metadata { get }
    
    func asMichelsonType() -> Michelson.`Type`
}

public extension Michelson.`Type`.`Protocol` {
    var annotations: [Michelson.Annotation] {
        let annotations: [Michelson.Annotation?] = [metadata.typeName, metadata.fieldName]
        return annotations.compactMap { $0 }
    }
    
    func asMichelson() -> Michelson {
        .type(asMichelsonType())
    }
}

// MARK: Prim

extension Michelson.`Type` {
    public typealias Prim = MichelsonTypePrimProtocol
    
    public static var allPrims: [Prim.Type] {
        [
            Parameter.self,
            Storage.self,
            Code.self,
            Option.self,
            List.self,
            Set.self,
            Operation.self,
            Contract.self,
            Ticket.self,
            Pair.self,
            Or.self,
            Lambda.self,
            Map.self,
            BigMap.self,
            Bls12_381G1.self,
            Bls12_381G2.self,
            Bls12_381Fr.self,
            SaplingTransaction.self,
            SaplingState.self,
            Chest.self,
            ChestKey.self,
        ] + Michelson.ComparableType.allPrims
    }
}

public protocol MichelsonTypePrimProtocol: Michelson.Prim {}

// MARK: Metadata

extension Michelson.`Type` {
    public struct Metadata: Hashable {
        public let typeName: Michelson.TypeAnnotation?
        public let fieldName: Michelson.FieldAnnotation?
        
        public init(typeName: Michelson.TypeAnnotation? = nil, fieldName: Michelson.FieldAnnotation? = nil) {
            self.typeName = typeName
            self.fieldName = fieldName
        }
    }
}

// MARK: Utility Extensions

extension Michelson.`Type` {
    var common: `Protocol` {
        switch self {
        case .parameter(let parameter):
            return parameter
        case .storage(let storage):
            return storage
        case .code(let code):
            return code
        case .option(let option):
            return option
        case .list(let list):
            return list
        case .set(let set):
            return set
        case .operation(let operation):
            return operation
        case .contract(let contract):
            return contract
        case .ticket(let ticket):
            return ticket
        case .pair(let pair):
            return pair
        case .or(let or):
            return or
        case .lambda(let lambda):
            return lambda
        case .map(let map):
            return map
        case .bigMap(let bigMap):
            return bigMap
        case .bls12_381G1(let bls12_381G1):
            return bls12_381G1
        case .bls12_381G2(let bls12_381G2):
            return bls12_381G2
        case .bls12_381Fr(let bls12_381Fr):
            return bls12_381Fr
        case .saplingTransaction(let saplingTransaction):
            return saplingTransaction
        case .saplingState(let saplingState):
            return saplingState
        case .chest(let chest):
            return chest
        case .chestKey(let chestKey):
            return chestKey
        case .comparable(let comparableType):
            return comparableType.common
        }
    }
}

extension Michelson.`Type`.Metadata {
    init(from annots: [Michelson.Annotation]) {
        self.init(
            typeName: annots.firstOf(type: Michelson.TypeAnnotation.self),
            fieldName: annots.firstOf(type: Michelson.FieldAnnotation.self)
        )
    }
}
