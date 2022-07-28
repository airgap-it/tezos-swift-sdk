//
//  MichelsonData.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import TezosCore

extension Michelson {

    public indirect enum Data: Hashable {
        public typealias `Protocol` = MichelsonDataProtocol
        
        case int(IntConstant)
        case nat(NaturalNumberConstant)
        case string(StringConstant)
        case bytes(ByteSequenceConstant)
        case unit(Unit)
        case `true`(True)
        case `false`(False)
        case pair(Pair)
        case left(Left)
        case right(Right)
        case some(Some)
        case none(None)
        case sequence(Sequence)
        case map(Map)
        case instruction(Instruction)
        
        // MARK: IntConstant
        
        public struct IntConstant: `Protocol`, BigIntWrapper, Hashable {
            public func asData() -> Data {
                .int(self)
            }
            
            public let value: String
            
            public init<S: StringProtocol>(_ value: S) throws {
                guard Self.isValid(value: value) else {
                    throw TezosError.invalidValue("Invalid Michelson IntConstant value.")
                }
                
                self.value = String(value)
            }
        }
        
        // MARK: NaturalNumberConstant
        
        public struct NaturalNumberConstant: `Protocol`, BigNatWrapper, Hashable {
            public func asData() -> Data {
                .nat(self)
            }
            
            public let value: String
            
            public init<S: StringProtocol>(_ value: S) throws {
                guard Self.isValid(value: value) else {
                    throw TezosError.invalidValue("Invalid Michelson NaturalNumberConstant value.")
                }
                
                self.value = String(value)
            }
        }
        
        // MARK: StringConstant
        
        public struct StringConstant: `Protocol`, StringWrapper, Hashable {
            public func asData() -> Data {
                .string(self)
            }
            
            public static let regex: String = #"^(\"|\r|\n|\t|\b|\\|[^\"\\])*$"#
            
            public let value: String
            
            public init<S: StringProtocol>(_ value: S) throws {
                guard Self.isValid(value: value) else {
                    throw TezosError.invalidValue("Invalid Michelson StringConstant value.")
                }
                
                self.value = String(value)
            }
        }
        
        // MARK: ByteSequenceConstant
        
        public struct ByteSequenceConstant: `Protocol`, BytesWrapper, Hashable {
            public func asData() -> Data {
                .bytes(self)
            }
            
            public static let regex: String = HexString.regex(withPrefix: .required)
            
            public let value: String
            
            public init<S: StringProtocol>(_ value: S) throws {
                guard Self.isValid(value: value) else {
                    throw TezosError.invalidValue("Invalid Michelson ByteSequenceConstant value.")
                }
                
                self.value = String(value)
            }
            
            public init(_ value: [UInt8]) {
                self.value = String(HexString(from: value), withPrefix: true)
            }
        }
        
        // MARK: Unit
        
        public struct Unit: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .unit(self)
            }
            
            public static let name: String = "Unit"
            public static let tag: [UInt8] = [11]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }
        
        // MARK: True
        
        public struct True: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .true(self)
            }
            
            public static let name: String = "True"
            public static let tag: [UInt8] = [10]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }
        
        // MARK: False
        
        public struct False: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .false(self)
            }
            
            public static let name: String = "False"
            public static let tag: [UInt8] = [3]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }
        
        // MARK: Pair
        
        public struct Pair: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .pair(self)
            }
            
            public static let name: String = "Pair"
            public static let tag: [UInt8] = [7]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count >= 2,
                      (try? args.asDataSequence()) != nil
                else {
                    
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at least 2 arguments (<data>, <data>, ...).")
                }
            }
            
            public let values: [Data]
            
            public init(values: [Data]) throws {
                guard values.count >= 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at least 2 arguments.")
                }
                
                self.values = values
            }
            
            public init(_ values: Data...) throws {
                try self.init(values: values)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try self.init(values: try args.asDataSequence())
            }
        }
        
        // MARK: Left
        
        public struct Left: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .left(self)
            }
            
            public static let name: String = "Left"
            public static let tag: [UInt8] = [5]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asData()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<data>).")
                }
            }
            
            public let value: Data
            
            public init(value: Data) {
                self.value = value
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(value: try args[0].asData())
            }
        }
        
        // MARK: Right
        
        public struct Right: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .right(self)
            }
            
            public static let name: String = "Right"
            public static let tag: [UInt8] = [8]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asData()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<data>).")
                }
            }
            
            public let value: Data
            
            public init(value: Data) {
                self.value = value
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(value: try args[0].asData())
            }
        }
        
        // MARK: Some
        
        public struct Some: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .some(self)
            }
            
            public static let name: String = "Some"
            public static let tag: [UInt8] = [9]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asData()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<data>).")
                }
            }
            
            public let value: Data
            
            public init(value: Data) {
                self.value = value
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(value: try args[0].asData())
            }
        }
        
        // MARK: None
        
        public struct None: `Protocol`, Prim, Hashable {
            public func asData() -> Data {
                .none(self)
            }
            
            public static let name: String = "None"
            public static let tag: [UInt8] = [6]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }
        
        // MARK: Sequence
        
        public struct Sequence: `Protocol`, Hashable {
            public func asData() -> Data {
                .sequence(self)
            }
            
            public let values: [Data]
            
            public init(values: [Data]) {
                self.values = values
            }
            
            public init(_ values: Data...) {
                self.values = values
            }
        }
        
        // MARK: Map
        
        public struct Map: `Protocol`, Hashable {
            public func asData() -> Data {
                .map(self)
            }
            
            public let values: [Elt]
            
            public init(values: [Elt]) {
                self.values = values
            }
            
            public init(_ values: Elt...) {
                self.values = values
            }
        }
        
        // MARK: Elt
        
        public struct Elt: Prim, Hashable {
            public static let name: String = "Elt"
            public static let tag: [UInt8] = [4]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asData()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 argument (<data>, <data>).")
                }
            }
            
            public let key: Data
            public let value: Data
            
            public init(key: Data, value: Data) {
                self.key = key
                self.value = value
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(key: try args[0].asData(), value: try args[1].asData())
            }
        }
    }
}

public protocol MichelsonDataProtocol: Michelson.`Protocol` {
    func asData() -> Michelson.Data
}

public extension Michelson.Data.`Protocol` {
    func asMichelson() -> Michelson {
        .data(asData())
    }
}

// MARK: Prim

extension Michelson.Data {
    public typealias Prim = MichelsonDataPrimProtocol
    
    public static var allPrims: [Prim.Type] {
        [
            Unit.self,
            True.self,
            False.self,
            Pair.self,
            Left.self,
            Right.self,
            Some.self,
            None.self,
            Elt.self,
        ] + Michelson.Instruction.allPrims
    }
}

public protocol MichelsonDataPrimProtocol: Michelson.Prim {}
