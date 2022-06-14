//
//  Prim, Hashable.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation
import TezosCore

extension Michelson {
    
    public indirect enum Instruction: Hashable {
        public typealias `Protocol` = MichelsonInsturctionProtocol
        
        case sequence(`Sequence`)
        case drop(Drop)
        case dup(Dup)
        case swap(Swap)
        case dig(Dig)
        case dug(Dug)
        case push(Push)
        case some(Some)
        case none(None)
        case unit(Unit)
        case never(Never)
        case ifNone(IfNone)
        case pair(Pair)
        case car(Car)
        case cdr(Cdr)
        case unpair(Unpair)
        case left(Left)
        case right(Right)
        case ifLeft(IfLeft)
        case `nil`(Nil)
        case cons(Cons)
        case ifCons(IfCons)
        case size(Size)
        case emptySet(EmptySet)
        case emptyMap(EmptyMap)
        case emptyBigMap(EmptyBigMap)
        case map(Map)
        case iter(Iter)
        case mem(Mem)
        case get(Get)
        case update(Update)
        case getAndUpdate(GetAndUpdate)
        case `if`(If)
        case loop(Loop)
        case loopLeft(LoopLeft)
        case lambda(Lambda)
        case exec(Exec)
        case apply(Apply)
        case dip(Dip)
        case failwith(Failwith)
        case cast(Cast)
        case rename(Rename)
        case concat(Concat)
        case slice(Slice)
        case pack(Pack)
        case unpack(Unpack)
        case add(Add)
        case sub(Sub)
        case mul(Mul)
        case ediv(Ediv)
        case abs(Abs)
        case isnat(Isnat)
        case int(Int)
        case neg(Neg)
        case lsl(Lsl)
        case lsr(Lsr)
        case or(Or)
        case and(And)
        case xor(Xor)
        case not(Not)
        case compare(Compare)
        case eq(Eq)
        case neq(Neq)
        case lt(Lt)
        case gt(Gt)
        case le(Le)
        case ge(Ge)
        case `self`(`Self`)
        case selfAddress(SelfAddress)
        case contract(Contract)
        case transferTokens(TransferTokens)
        case setDelegate(SetDelegate)
        case createContract(CreateContract)
        case implicitAccount(ImplicitAccount)
        case votingPower(VotingPower)
        case now(Now)
        case level(Level)
        case amount(Amount)
        case balance(Balance)
        case checkSignature(CheckSignature)
        case blake2b(Blake2B)
        case keccak(Keccak)
        case sha3(Sha3)
        case sha256(Sha256)
        case sha512(Sha512)
        case hashKey(HashKey)
        case source(Source)
        case sender(Sender)
        case address(Address)
        case chainID(ChainID)
        case totalVotingPower(TotalVotingPower)
        case pairingCheck(PairingCheck)
        case saplingEmptyState(SaplingEmptyState)
        case saplingVerifyUpdate(SaplingVerifyUpdate)
        case ticket(Ticket)
        case readTicket(ReadTicket)
        case splitTicket(SplitTicket)
        case joinTickets(JoinTickets)
        case openChest(OpenChest)
        
        // MARK: Sequence
        
        public struct Sequence: `Protocol`, Hashable {
            public func asInstruction() -> Instruction {
                .sequence(self)
            }
            
            public let instructions: [Instruction]
            
            public init(instructions: [Instruction]) {
                self.instructions = instructions
            }
            
            public init(_ instructions: Instruction...) {
                self.instructions = instructions
            }
        }

        // MARK: DROP
        
        public struct Drop: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .drop(self)
            }
            
            public static let name: String = "DROP"
            public static let tag: [UInt8] = [32]
            
            public let n: Data.NaturalNumberConstant?
            
            public init(n: Data.NaturalNumberConstant? = nil) {
                self.n = n
            }

            public init(n: UInt) {
                self.init(n: Data.NaturalNumberConstant(n))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count <= 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument.")
                }
                
                self.init(n: try args[safe: 0]?.tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: DUP
        
        public struct Dup: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .dup(self)
            }
            
            public static let name: String = "DUP"
            public static let tag: [UInt8] = [33]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let n: Data.NaturalNumberConstant?
            public let metadata: Metadata
            
            public init(n: Data.NaturalNumberConstant? = nil, metadata: Metadata = Metadata()) {
                self.n = n
                self.metadata = metadata
            }

            public init(n: UInt, metadata: Metadata = Metadata()) {
                self.init(n: Data.NaturalNumberConstant(n), metadata: metadata)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count <= 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument.")
                }
                
                self.init(
                    n: try args[safe: 0]?.tryAs(Data.NaturalNumberConstant.self),
                    metadata: .init(from: annots)
                )
            }
            
            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SWAP
        
        public struct Swap: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .swap(self)
            }
            
            public static let name: String = "SWAP"
            public static let tag: [UInt8] = [76]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: DIG
        
        public struct Dig: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .dig(self)
            }
            
            public static let name: String = "DIG"
            public static let tag: [UInt8] = [112]

            public let n: Data.NaturalNumberConstant
            
            public init(n: Data.NaturalNumberConstant) {
                self.n = n
            }

            public init(n: UInt) {
                self.init(n: .init(n))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(n: try args[0].tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: DUG
        
        public struct Dug: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .dug(self)
            }
            
            public static let name: String = "DUG"
            public static let tag: [UInt8] = [113]

            public let n: Data.NaturalNumberConstant
            
            public init(n: Data.NaturalNumberConstant) {
                self.n = n
            }

            public init(n: UInt) {
                self.init(n: .init(n))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(n: try args[0].tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: PUSH
        
        public struct Push: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .push(self)
            }
            
            public static let name: String = "PUSH"
            public static let tag: [UInt8] = [67]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let type: `Type`
            public let value: Data
            public let metadata: Metadata
            
            public init(type: `Type`, value: Data, metadata: Metadata = .init()) {
                self.type = type
                self.value = value
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments.")
                }
                
                self.init(
                    type: try args[0].asType(),
                    value: try args[1].asData(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SOME
        
        public struct Some: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .some(self)
            }
            
            public static let name: String = "SOME"
            public static let tag: [UInt8] = [70]
            
            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: NONE
        
        public struct None: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .none(self)
            }
            
            public static let name: String = "NONE"
            public static let tag: [UInt8] = [62]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(
                    type: try args[0].asType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: UNIT
        
        public struct Unit: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .unit(self)
            }
            
            public static let name: String = "UNIT"
            public static let tag: [UInt8] = [79]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: NEVER
        
        public struct Never: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .never(self)
            }
            
            public static let name: String = "NEVER"
            public static let tag: [UInt8] = [121]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: IF_NONE
        
        public struct IfNone: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .ifNone(self)
            }
            
            public static let name: String = "IF_NONE"
            public static let tag: [UInt8] = [47]
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments.")
                }
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: PAIR
        
        public struct Pair: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .pair(self)
            }
            
            public static let name: String = "PAIR"
            public static let tag: [UInt8] = [66]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let n: Data.NaturalNumberConstant?
            public let metadata: Metadata
            
            public init(n: Data.NaturalNumberConstant? = nil, metadata: Metadata = Metadata()) {
                self.n = n
                self.metadata = metadata
            }

            public init(n: UInt, metadata: Metadata = Metadata()) {
                self.init(n: Data.NaturalNumberConstant(n), metadata: metadata)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count <= 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument.")
                }
                
                self.init(
                    n: try args[safe: 0]?.tryAs(Data.NaturalNumberConstant.self),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: CAR
        
        public struct Car: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .car(self)
            }
            
            public static let name: String = "CAR"
            public static let tag: [UInt8] = [22]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        
            // MARK: CDR
        }
        public struct Cdr: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .cdr(self)
            }
            
            public static let name: String = "CDR"
            public static let tag: [UInt8] = [23]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: UNPAIR
        
        public struct Unpair: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .unpair(self)
            }
            
            public static let name: String = "UNPAIR"
            public static let tag: [UInt8] = [122]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.firstVariableName, metadata.secondVariableName]
                return annotations.compactMap { $0 }
            }
            
            public let n: Data.NaturalNumberConstant?
            public let metadata: Metadata
            
            public init(n: Data.NaturalNumberConstant? = nil, metadata: Metadata = Metadata()) {
                self.n = n
                self.metadata = metadata
            }

            public init(n: UInt, metadata: Metadata = Metadata()) {
                self.init(n: Data.NaturalNumberConstant(n), metadata: metadata)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count <= 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument.")
                }
                
                self.init(
                    n: try args[safe: 0]?.tryAs(Data.NaturalNumberConstant.self),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let firstVariableName: VariableAnnotation?
                public let secondVariableName: VariableAnnotation?
                
                public init(firstVariableName: VariableAnnotation? = nil, secondVariableName: VariableAnnotation? = nil) {
                    self.firstVariableName = firstVariableName
                    self.secondVariableName = secondVariableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        firstVariableName: annots.firstOf(type: VariableAnnotation.self),
                        secondVariableName: annots.secondOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: LEFT
        
        public struct Left: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .left(self)
            }
            
            public static let name: String = "LEFT"
            public static let tag: [UInt8] = [51]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(
                    type: try args[0].asType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: RIGHT
        
        public struct Right: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .right(self)
            }
            
            public static let name: String = "RIGHT"
            public static let tag: [UInt8] = [68]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(
                    type: try args[0].asType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: IF_LEFT
        
        public struct IfLeft: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .ifLeft(self)
            }
            
            public static let name: String = "IF_LEFT"
            public static let tag: [UInt8] = [46]
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments.")
                }
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: NIL
        
        public struct Nil: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .`nil`(self)
            }
            
            public static let name: String = "NIL"
            public static let tag: [UInt8] = [61]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(
                    type: try args[0].asType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: CONS
        
        public struct Cons: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .cons(self)
            }
            
            public static let name: String = "CONS"
            public static let tag: [UInt8] = [27]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: IF_CONS
        
        public struct IfCons: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .ifCons(self)
            }
            
            public static let name: String = "IF_CONS"
            public static let tag: [UInt8] = [45]
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments.")
                }
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: SIZE
        
        public struct Size: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .size(self)
            }
            
            public static let name: String = "SIZE"
            public static let tag: [UInt8] = [69]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: EMPTY_SET
        
        public struct EmptySet: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .emptySet(self)
            }
            
            public static let name: String = "EMPTY_SET"
            public static let tag: [UInt8] = [36]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let type: ComparableType
            public let metadata: Metadata
            
            public init(type: ComparableType, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(
                    type: try args[0].asComparableType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: EMPTY_MAP
        
        public struct EmptyMap: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .emptyMap(self)
            }
            
            public static let name: String = "EMPTY_MAP"
            public static let tag: [UInt8] = [35]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
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
                guard args.count == 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments.")
                }
                
                self.init(
                    keyType: try args[0].asComparableType(),
                    valueType: try args[1].asType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: EMPTY_BIG_MAP
        
        public struct EmptyBigMap: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .emptyBigMap(self)
            }
            
            public static let name: String = "EMPTY_BIG_MAP"
            public static let tag: [UInt8] = [114]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
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
                guard args.count == 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments.")
                }
                
                self.init(
                    keyType: try args[0].asComparableType(),
                    valueType: try args[1].asType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let typeName: TypeAnnotation?
                public let variableName: VariableAnnotation?
                
                public init(typeName: TypeAnnotation? = nil, variableName: VariableAnnotation? = nil) {
                    self.typeName = typeName
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        typeName: annots.firstOf(type: TypeAnnotation.self),
                        variableName: annots.firstOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: MAP
        
        public struct Map: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .map(self)
            }
            
            public static let name: String = "MAP"
            public static let tag: [UInt8] = [56]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let expression: `Sequence`
            public let metadata: Metadata
            
            public init(expression: `Sequence`, metadata: Metadata = .init()) {
                self.expression = expression
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(
                    expression: try args[0].tryAs(Sequence.self),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: ITER
        
        public struct Iter: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .iter(self)
            }
            
            public static let name: String = "ITER"
            public static let tag: [UInt8] = [82]
            
            public let expression: `Sequence`
            
            public init(expression: `Sequence`) {
                self.expression = expression
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(expression: try args[0].tryAs(Sequence.self))
            }
        }

        // MARK: MEM
        
        public struct Mem: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .mem(self)
            }
            
            public static let name: String = "MEM"
            public static let tag: [UInt8] = [57]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: GET
        
        public struct Get: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .get(self)
            }
            
            public static let name: String = "GET"
            public static let tag: [UInt8] = [41]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let n: Data.NaturalNumberConstant?
            public let metadata: Metadata
            
            public init(n: Data.NaturalNumberConstant? = nil, metadata: Metadata = Metadata()) {
                self.n = n
                self.metadata = metadata
            }

            public init(n: UInt, metadata: Metadata = Metadata()) {
                self.init(n: Data.NaturalNumberConstant(n), metadata: metadata)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count <= 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument.")
                }
                
                self.init(
                    n: try args[safe: 0]?.tryAs(Data.NaturalNumberConstant.self),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: UPDATE
        
        public struct Update: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .update(self)
            }
            
            public static let name: String = "UPDATE"
            public static let tag: [UInt8] = [80]
            
            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let n: Data.NaturalNumberConstant?
            public let metadata: Metadata
            
            public init(n: Data.NaturalNumberConstant? = nil, metadata: Metadata = Metadata()) {
                self.n = n
                self.metadata = metadata
            }

            public init(n: UInt, metadata: Metadata = Metadata()) {
                self.init(n: Data.NaturalNumberConstant(n), metadata: metadata)
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count <= 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument.")
                }
                
                self.init(
                    n: try args[safe: 0]?.tryAs(Data.NaturalNumberConstant.self),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: GET_AND_UPDATE
        
        public struct GetAndUpdate: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .getAndUpdate(self)
            }
            
            public static let name: String = "GET_AND_UPDATE"
            public static let tag: [UInt8] = [140]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: IF
        
        public struct If: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .`if`(self)
            }
            
            public static let name: String = "IF"
            public static let tag: [UInt8] = [44]
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments.")
                }
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: LOOP
        
        public struct Loop: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .loop(self)
            }
            
            public static let name: String = "LOOP"
            public static let tag: [UInt8] = [52]
            
            public let body: `Sequence`
            
            public init(body: `Sequence`) {
                self.body = body
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(body: try args[0].tryAs(Sequence.self))
            }
        }
        
        // MARK: LOOP_LEFT
        
        public struct LoopLeft: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .loopLeft(self)
            }
            
            public static let name: String = "LOOP_LEFT"
            public static let tag: [UInt8] = [83]
            
            public let body: `Sequence`
            
            public init(body: `Sequence`) {
                self.body = body
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(body: try args[0].tryAs(Sequence.self))
            }
        }

        // MARK: LAMBDA
        
        public struct Lambda: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .lambda(self)
            }
            
            public static let name: String = "LAMBDA"
            public static let tag: [UInt8] = [49]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let parameterType: `Type`
            public let returnType: `Type`
            public let body: `Sequence`
            public let metadata: Metadata
            
            public init(parameterType: `Type`, returnType: `Type`, body: `Sequence`, metadata: Metadata = .init()) {
                self.parameterType = parameterType
                self.returnType = returnType
                self.body = body
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 3 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 3 arguments.")
                }
                
                self.init(
                    parameterType: try args[0].asType(),
                    returnType: try args[1].asType(),
                    body: try args[2].tryAs(Sequence.self),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: EXEC
        
        public struct Exec: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .exec(self)
            }
            
            public static let name: String = "EXEC"
            public static let tag: [UInt8] = [38]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: APPLY
        
        public struct Apply: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .apply(self)
            }
            
            public static let name: String = "APPLY"
            public static let tag: [UInt8] = [115]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: DIP
        
        public struct Dip: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .dip(self)
            }
            
            public static let name: String = "DIP"
            public static let tag: [UInt8] = [31]
            
            public let instruction: `Sequence`
            public let n: Data.NaturalNumberConstant?
            
            public init(instruction: `Sequence`, n: Data.NaturalNumberConstant? = nil) {
                self.instruction = instruction
                self.n = n
            }

            public init(instruction: `Sequence`, n: UInt) {
                self.init(instruction: instruction, n: Data.NaturalNumberConstant(n))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count <= 2 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 2 arguments.")
                }
                
                if args.count == 2 {
                    self.init(
                        instruction: try args[1].tryAs(Sequence.self),
                        n: try args[0].tryAs(Data.NaturalNumberConstant.self)
                    )
                } else {
                    self.init(instruction: try args[0].tryAs(Sequence.self))
                }
            }
        }

        // MARK: FAILWITH
        
        public struct Failwith: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .failwith(self)
            }
            
            public static let name: String = "FAILWITH"
            public static let tag: [UInt8] = [39]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: CAST
        
        public struct Cast: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .cast(self)
            }
            
            public static let name: String = "CAST"
            public static let tag: [UInt8] = [87]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: RENAME
        
        public struct Rename: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .rename(self)
            }
            
            public static let name: String = "RENAME"
            public static let tag: [UInt8] = [88]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: CONCAT
        
        public struct Concat: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .concat(self)
            }
            
            public static let name: String = "CONCAT"
            public static let tag: [UInt8] = [26]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SLICE
        
        public struct Slice: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .slice(self)
            }
            
            public static let name: String = "SLICE"
            public static let tag: [UInt8] = [111]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: PACK
        
        public struct Pack: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .pack(self)
            }
            
            public static let name: String = "PACK"
            public static let tag: [UInt8] = [12]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: UNPACK
        
        public struct Unpack: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .unpack(self)
            }
            
            public static let name: String = "UNPACK"
            public static let tag: [UInt8] = [13]
            
            public let type: `Type`
            
            public init(type: `Type`) {
                self.type = type
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(type: try args[0].asType())
            }
        }

        // MARK: ADD
        
        public struct Add: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .add(self)
            }
            
            public static let name: String = "ADD"
            public static let tag: [UInt8] = [18]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SUB
        
        public struct Sub: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .sub(self)
            }
            
            public static let name: String = "SUB"
            public static let tag: [UInt8] = [75]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: MUL
        
        public struct Mul: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .mul(self)
            }
            
            public static let name: String = "MUL"
            public static let tag: [UInt8] = [58]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: EDIV
        
        public struct Ediv: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .ediv(self)
            }
            
            public static let name: String = "EDIV"
            public static let tag: [UInt8] = [34]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: ABS
        
        public struct Abs: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .abs(self)
            }
            
            public static let name: String = "ABS"
            public static let tag: [UInt8] = [17]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: ISNAT
        
        public struct Isnat: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .isnat(self)
            }
            
            public static let name: String = "ISNAT"
            public static let tag: [UInt8] = [86]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: INT
        
        public struct Int: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .int(self)
            }
            
            public static let name: String = "INT"
            public static let tag: [UInt8] = [48]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: NEG
        
        public struct Neg: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .neg(self)
            }
            
            public static let name: String = "NEG"
            public static let tag: [UInt8] = [59]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: LSL
        
        public struct Lsl: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .lsl(self)
            }
            
            public static let name: String = "LSL"
            public static let tag: [UInt8] = [53]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: LSR
        
        public struct Lsr: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .lsr(self)
            }
            
            public static let name: String = "LSR"
            public static let tag: [UInt8] = [54]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: OR
        
        public struct Or: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .or(self)
            }
            
            public static let name: String = "OR"
            public static let tag: [UInt8] = [65]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: AND
        
        public struct And: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .and(self)
            }
            
            public static let name: String = "AND"
            public static let tag: [UInt8] = [20]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: XOR
        
        public struct Xor: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .xor(self)
            }
            
            public static let name: String = "XOR"
            public static let tag: [UInt8] = [81]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: NOT
        
        public struct Not: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .not(self)
            }
            
            public static let name: String = "NOT"
            public static let tag: [UInt8] = [63]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: COMPARE
        
        public struct Compare: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .compare(self)
            }
            
            public static let name: String = "COMPARE"
            public static let tag: [UInt8] = [25]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: EQ
        
        public struct Eq: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .eq(self)
            }
            
            public static let name: String = "EQ"
            public static let tag: [UInt8] = [37]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: NEQ
        
        public struct Neq: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .neq(self)
            }
            
            public static let name: String = "NEQ"
            public static let tag: [UInt8] = [60]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: LT
        
        public struct Lt: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .lt(self)
            }
            
            public static let name: String = "LT"
            public static let tag: [UInt8] = [55]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: GT
        
        public struct Gt: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .gt(self)
            }
            
            public static let name: String = "GT"
            public static let tag: [UInt8] = [42]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: LE
        
        public struct Le: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .le(self)
            }
            
            public static let name: String = "LE"
            public static let tag: [UInt8] = [50]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: GE
        
        public struct Ge: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .ge(self)
            }
            
            public static let name: String = "GE"
            public static let tag: [UInt8] = [40]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }
            
            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SELF
        
        public struct `Self`: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .`self`(self)
            }
            
            public static let name: String = "SELF"
            public static let tag: [UInt8] = [73]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SELF_ADDRESS
        
        public struct SelfAddress: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .selfAddress(self)
            }
            
            public static let name: String = "SELF_ADDRESS"
            public static let tag: [UInt8] = [119]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: CONTRACT
        
        public struct Contract: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .contract(self)
            }
            
            public static let name: String = "CONTRACT"
            public static let tag: [UInt8] = [85]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let type: `Type`
            public let metadata: Metadata
            
            public init(type: `Type`, metadata: Metadata = .init()) {
                self.type = type
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(
                    type: try args[0].asType(),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: TRANSFER_TOKENS
        
        public struct TransferTokens: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .transferTokens(self)
            }
            
            public static let name: String = "TRANSFER_TOKENS"
            public static let tag: [UInt8] = [77]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: SET_DELEGATE
        
        public struct SetDelegate: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .setDelegate(self)
            }
            
            public static let name: String = "SET_DELEGATE"
            public static let tag: [UInt8] = [78]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: CREATE_CONTRACT
        
        public struct CreateContract: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .createContract(self)
            }
            
            public static let name: String = "CREATE_CONTRACT"
            public static let tag: [UInt8] = [29]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.firstVariableName, metadata.secondVariableName]
                return annotations.compactMap { $0 }
            }
            
            public let parameterType: `Type`
            public let storageType: `Type`
            public let code: `Sequence`
            public let metadata: Metadata
            
            public init(parameterType: `Type`, storageType: `Type`, code: `Sequence`, metadata: Metadata = .init()) {
                self.parameterType = parameterType
                self.storageType = storageType
                self.code = code
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 3 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 3 arguments.")
                }
                
                self.init(
                    parameterType: try args[0].asType(),
                    storageType: try args[1].asType(),
                    code: try args[2].tryAs(Sequence.self),
                    metadata: .init(from: annots)
                )
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let firstVariableName: VariableAnnotation?
                public let secondVariableName: VariableAnnotation?
                
                public init(firstVariableName: VariableAnnotation? = nil, secondVariableName: VariableAnnotation? = nil) {
                    self.firstVariableName = firstVariableName
                    self.secondVariableName = secondVariableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(
                        firstVariableName: annots.firstOf(type: VariableAnnotation.self),
                        secondVariableName: annots.secondOf(type: VariableAnnotation.self)
                    )
                }
            }
        }

        // MARK: IMPLICIT_ACCOUNT
        
        public struct ImplicitAccount: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .implicitAccount(self)
            }
            
            public static let name: String = "IMPLICIT_ACCOUNT"
            public static let tag: [UInt8] = [30]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: VOTING_POWER
        
        public struct VotingPower: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .votingPower(self)
            }
            
            public static let name: String = "VOTING_POWER"
            public static let tag: [UInt8] = [123]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: NOW
        
        public struct Now: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .now(self)
            }
            
            public static let name: String = "NOW"
            public static let tag: [UInt8] = [64]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: LEVEL
        
        public struct Level: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .level(self)
            }
            
            public static let name: String = "LEVEL"
            public static let tag: [UInt8] = [118]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: BALANCE
        
        public struct Amount: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .amount(self)
            }
            
            public static let name: String = "BALANCE"
            public static let tag: [UInt8] = [21]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: BALANCE
        
        public struct Balance: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .balance(self)
            }
            
            public static let name: String = "BALANCE"
            public static let tag: [UInt8] = [21]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: CHECK_SIGNATURE
        
        public struct CheckSignature: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .checkSignature(self)
            }
            
            public static let name: String = "CHECK_SIGNATURE"
            public static let tag: [UInt8] = [24]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: BLAKE2B
        
        public struct Blake2B: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .blake2b(self)
            }
            
            public static let name: String = "BLAKE2B"
            public static let tag: [UInt8] = [14]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: KECCAK
        
        public struct Keccak: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .keccak(self)
            }
            
            public static let name: String = "KECCAK"
            public static let tag: [UInt8] = [125]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SHA3
        
        public struct Sha3: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .sha3(self)
            }
            
            public static let name: String = "SHA3"
            public static let tag: [UInt8] = [126]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SHA256
        
        public struct Sha256: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .sha256(self)
            }
            
            public static let name: String = "SHA256"
            public static let tag: [UInt8] = [15]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SHA512
        
        public struct Sha512: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .sha512(self)
            }
            
            public static let name: String = "SHA512"
            public static let tag: [UInt8] = [16]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: HASH_KEY
        
        public struct HashKey: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .hashKey(self)
            }
            
            public static let name: String = "HASH_KEY"
            public static let tag: [UInt8] = [43]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SOURCE
        
        public struct Source: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .source(self)
            }
            
            public static let name: String = "SOURCE"
            public static let tag: [UInt8] = [71]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: SENDER
        
        public struct Sender: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .sender(self)
            }
            
            public static let name: String = "SENDER"
            public static let tag: [UInt8] = [72]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: ADDRESS
        
        public struct Address: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .address(self)
            }
            
            public static let name: String = "ADDRESS"
            public static let tag: [UInt8] = [84]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: CHAIN_ID
        
        public struct ChainID: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .chainID(self)
            }
            
            public static let name: String = "CHAIN_ID"
            public static let tag: [UInt8] = [117]

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
                
                self.init(metadata: .init(from: annots))
            }

            // MARK: Metadata
            
            public struct Metadata: Hashable {
                public let variableName: VariableAnnotation?
                
                public init(variableName: VariableAnnotation? = nil) {
                    self.variableName = variableName
                }
                
                init(from annots: [Annotation]) {
                    self.init(variableName: annots.firstOf(type: VariableAnnotation.self))
                }
            }
        }

        // MARK: TOTAL_VOTING_POWER
        
        public struct TotalVotingPower: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .totalVotingPower(self)
            }
            
            public static let name: String = "TOTAL_VOTING_POWER"
            public static let tag: [UInt8] = [124]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: PAIRING_CHECK
        
        public struct PairingCheck: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .pairingCheck(self)
            }
            
            public static let name: String = "PAIRING_CHECK"
            public static let tag: [UInt8] = [127]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: SAPLING_EMPTY_STATE
        
        public struct SaplingEmptyState: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .saplingEmptyState(self)
            }
            
            public static let name: String = "SAPLING_EMPTY_STATE"
            public static let tag: [UInt8] = [133]

            public let memoSize: Data.NaturalNumberConstant
            
            public init(memoSize: Data.NaturalNumberConstant) {
                self.memoSize = memoSize
            }

            public init(memoSize: UInt) {
                self.init(memoSize: .init(memoSize))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 1 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument.")
                }
                
                self.init(memoSize: try args[0].tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: SAPLING_VERIFY_UPDATE
        
        public struct SaplingVerifyUpdate: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .saplingVerifyUpdate(self)
            }
            
            public static let name: String = "SAPLING_VERIFY_UPDATE"
            public static let tag: [UInt8] = [134]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: TICKET
        
        public struct Ticket: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .ticket(self)
            }
            
            public static let name: String = "TICKET"
            public static let tag: [UInt8] = [136]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: READ_TICKET
        
        public struct ReadTicket: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .readTicket(self)
            }
            
            public static let name: String = "READ_TICKET"
            public static let tag: [UInt8] = [137]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: SPLIT_TICKET
        
        public struct SplitTicket: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .splitTicket(self)
            }
            
            public static let name: String = "SPLIT_TICKET"
            public static let tag: [UInt8] = [138]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: JOIN_TICKETS
        
        public struct JoinTickets: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .joinTickets(self)
            }
            
            public static let name: String = "JOIN_TICKETS"
            public static let tag: [UInt8] = [139]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }

        // MARK: OPEN_CHEST
        
        public struct OpenChest: `Protocol`, Prim, Hashable {
            public func asInstruction() -> Instruction {
                .openChest(self)
            }
            
            public static let name: String = "OPEN_CHEST"
            public static let tag: [UInt8] = [143]
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
        }
    }
}

public protocol MichelsonInsturctionProtocol: Michelson.Data.`Protocol` {
    func asInstruction() -> Michelson.Instruction
}

public extension Michelson.Instruction.`Protocol` {
    func asData() -> Michelson.Data {
        .instruction(asInstruction())
    }
}

// MARK: Prim

extension Michelson.Instruction {
    public typealias Prim = MichelsonInstructionPrimProtocol
    
    public static var allPrims: [Prim.Type] {
        [
            Drop.self,
            Dup.self,
            Swap.self,
            Dig.self,
            Dug.self,
            Push.self,
            Some.self,
            None.self,
            Unit.self,
            Never.self,
            IfNone.self,
            Pair.self,
            Car.self,
            Cdr.self,
            Unpair.self,
            Left.self,
            Right.self,
            IfLeft.self,
            Nil.self,
            Cons.self,
            IfCons.self,
            Size.self,
            EmptySet.self,
            EmptyMap.self,
            EmptyBigMap.self,
            Map.self,
            Iter.self,
            Mem.self,
            Get.self,
            Update.self,
            GetAndUpdate.self,
            If.self,
            Loop.self,
            LoopLeft.self,
            Lambda.self,
            Exec.self,
            Apply.self,
            Dip.self,
            Failwith.self,
            Cast.self,
            Rename.self,
            Concat.self,
            Slice.self,
            Pack.self,
            Unpack.self,
            Add.self,
            Sub.self,
            Mul.self,
            Ediv.self,
            Abs.self,
            Isnat.self,
            Int.self,
            Neg.self,
            Lsl.self,
            Lsr.self,
            Or.self,
            And.self,
            Xor.self,
            Not.self,
            Compare.self,
            Eq.self,
            Neq.self,
            Lt.self,
            Gt.self,
            Le.self,
            Ge.self,
            `Self`.self,
            SelfAddress.self,
            Contract.self,
            TransferTokens.self,
            SetDelegate.self,
            CreateContract.self,
            ImplicitAccount.self,
            VotingPower.self,
            Now.self,
            Level.self,
            Amount.self,
            Balance.self,
            CheckSignature.self,
            Blake2B.self,
            Keccak.self,
            Sha3.self,
            Sha256.self,
            Sha512.self,
            HashKey.self,
            Source.self,
            Sender.self,
            Address.self,
            ChainID.self,
            TotalVotingPower.self,
            PairingCheck.self,
            SaplingEmptyState.self,
            SaplingVerifyUpdate.self,
            Ticket.self,
            ReadTicket.self,
            SplitTicket.self,
            JoinTickets.self,
            OpenChest.self,
        ]
    }
}

public protocol MichelsonInstructionPrimProtocol: Michelson.Data.Prim {}
