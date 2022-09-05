//
//  Prim, Hashable.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import TezosCore

extension Michelson {
    
    public indirect enum Instruction: MichelsonInsturctionProtocol, Hashable {
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
        
        public var annotations: [Michelson.Annotation] {
            common.annotations
        }
        
        public func asMichelsonInstruction() -> Instruction {
            self
        }
        
        // MARK: Sequence
        
        public struct Sequence: `Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
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
        
        public struct Drop: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .drop(self)
            }
            
            public static let name: String = "DROP"
            public static let tag: [UInt8] = [32]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count <= 1,
                      args.isEmpty || (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument (<natural_number_constant>?).")
                }
            }
            
            public let n: Data.NaturalNumberConstant?
            
            public init(n: Data.NaturalNumberConstant? = nil) {
                self.n = n
            }

            public init(n: UInt) {
                self.init(n: Data.NaturalNumberConstant(n))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(n: try args[safe: 0]?.tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: DUP
        
        public struct Dup: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .dup(self)
            }
            
            public static let name: String = "DUP"
            public static let tag: [UInt8] = [33]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count <= 1,
                      args.isEmpty || (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument (<natural_number_constant>?).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Swap: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .swap(self)
            }
            
            public static let name: String = "SWAP"
            public static let tag: [UInt8] = [76]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: DIG
        
        public struct Dig: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .dig(self)
            }
            
            public static let name: String = "DIG"
            public static let tag: [UInt8] = [112]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<natural_number_constant>).")
                }
            }

            public let n: Data.NaturalNumberConstant
            
            public init(n: Data.NaturalNumberConstant) {
                self.n = n
            }

            public init(n: UInt) {
                self.init(n: .init(n))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(n: try args[0].tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: DUG
        
        public struct Dug: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .dug(self)
            }
            
            public static let name: String = "DUG"
            public static let tag: [UInt8] = [113]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<natural_number_constant>).")
                }
            }

            public let n: Data.NaturalNumberConstant
            
            public init(n: Data.NaturalNumberConstant) {
                self.n = n
            }

            public init(n: UInt) {
                self.init(n: .init(n))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(n: try args[0].tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: PUSH
        
        public struct Push: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .push(self)
            }
            
            public static let name: String = "PUSH"
            public static let tag: [UInt8] = [67]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asType()) != nil,
                      (try? args[1].asData()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<type>, <data>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Some: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .some(self)
            }
            
            public static let name: String = "SOME"
            public static let tag: [UInt8] = [70]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct None: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .none(self)
            }
            
            public static let name: String = "NONE"
            public static let tag: [UInt8] = [62]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Unit: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .unit(self)
            }
            
            public static let name: String = "UNIT"
            public static let tag: [UInt8] = [79]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.typeName, metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Never: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .never(self)
            }
            
            public static let name: String = "NEVER"
            public static let tag: [UInt8] = [121]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: IF_NONE
        
        public struct IfNone: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .ifNone(self)
            }
            
            public static let name: String = "IF_NONE"
            public static let tag: [UInt8] = [47]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].tryAs(Sequence.self)) != nil,
                      (try? args[1].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<instruction_sequence>, <instruction_sequence>).")
                }
            }
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: PAIR
        
        public struct Pair: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .pair(self)
            }
            
            public static let name: String = "PAIR"
            public static let tag: [UInt8] = [66]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count <= 1,
                      args.isEmpty || (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument (<natural_number_constant>?).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Car: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .car(self)
            }
            
            public static let name: String = "CAR"
            public static let tag: [UInt8] = [22]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        public struct Cdr: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .cdr(self)
            }
            
            public static let name: String = "CDR"
            public static let tag: [UInt8] = [23]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Unpair: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .unpair(self)
            }
            
            public static let name: String = "UNPAIR"
            public static let tag: [UInt8] = [122]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count <= 1,
                      args.isEmpty || (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument (<natural_number_constant>?).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Left: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .left(self)
            }
            
            public static let name: String = "LEFT"
            public static let tag: [UInt8] = [51]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Right: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .right(self)
            }
            
            public static let name: String = "RIGHT"
            public static let tag: [UInt8] = [68]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct IfLeft: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .ifLeft(self)
            }
            
            public static let name: String = "IF_LEFT"
            public static let tag: [UInt8] = [46]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].tryAs(Sequence.self)) != nil,
                      (try? args[1].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<instruction_sequence>, <instruction_sequence>).")
                }
            }
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: NIL
        
        public struct Nil: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .`nil`(self)
            }
            
            public static let name: String = "NIL"
            public static let tag: [UInt8] = [61]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Cons: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .cons(self)
            }
            
            public static let name: String = "CONS"
            public static let tag: [UInt8] = [27]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct IfCons: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .ifCons(self)
            }
            
            public static let name: String = "IF_CONS"
            public static let tag: [UInt8] = [45]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].tryAs(Sequence.self)) != nil,
                      (try? args[1].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<instruction_sequence>, <instruction_sequence>).")
                }
            }
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: SIZE
        
        public struct Size: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .size(self)
            }
            
            public static let name: String = "SIZE"
            public static let tag: [UInt8] = [69]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct EmptySet: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .emptySet(self)
            }
            
            public static let name: String = "EMPTY_SET"
            public static let tag: [UInt8] = [36]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asComparableType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct EmptyMap: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .emptyMap(self)
            }
            
            public static let name: String = "EMPTY_MAP"
            public static let tag: [UInt8] = [35]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asComparableType()) != nil,
                      (try? args[1].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<comparable_type>, <type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct EmptyBigMap: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .emptyBigMap(self)
            }
            
            public static let name: String = "EMPTY_BIG_MAP"
            public static let tag: [UInt8] = [114]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].asComparableType()) != nil,
                      (try? args[1].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<comparable_type>, <type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Map: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .map(self)
            }
            
            public static let name: String = "MAP"
            public static let tag: [UInt8] = [56]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<instruction_sequence>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Iter: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .iter(self)
            }
            
            public static let name: String = "ITER"
            public static let tag: [UInt8] = [82]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<instruction_sequence>).")
                }
            }
            
            public let expression: `Sequence`
            
            public init(expression: `Sequence`) {
                self.expression = expression
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(expression: try args[0].tryAs(Sequence.self))
            }
        }

        // MARK: MEM
        
        public struct Mem: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .mem(self)
            }
            
            public static let name: String = "MEM"
            public static let tag: [UInt8] = [57]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Get: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .get(self)
            }
            
            public static let name: String = "GET"
            public static let tag: [UInt8] = [41]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count <= 1,
                      args.isEmpty || (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument (<natural_number_constant>?).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Update: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .update(self)
            }
            
            public static let name: String = "UPDATE"
            public static let tag: [UInt8] = [80]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count <= 1,
                      args.isEmpty || (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 1 argument (<natural_number_constant>?).")
                }
            }
            
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
                try Self.validateArgs(args)
                
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
        
        public struct GetAndUpdate: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .getAndUpdate(self)
            }
            
            public static let name: String = "GET_AND_UPDATE"
            public static let tag: [UInt8] = [140]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: IF
        
        public struct If: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .`if`(self)
            }
            
            public static let name: String = "IF"
            public static let tag: [UInt8] = [44]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 2,
                      (try? args[0].tryAs(Sequence.self)) != nil,
                      (try? args[1].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<instruction_sequence>, <instruction_sequence>).")
                }
            }
            
            public let ifBranch: `Sequence`
            public let elseBranch: `Sequence`
            
            public init(ifBranch: `Sequence`, elseBranch: `Sequence`) {
                self.ifBranch = ifBranch
                self.elseBranch = elseBranch
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(
                    ifBranch: try args[0].tryAs(Sequence.self),
                    elseBranch: try args[1].tryAs(Sequence.self)
                )
            }
        }

        // MARK: LOOP
        
        public struct Loop: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .loop(self)
            }
            
            public static let name: String = "LOOP"
            public static let tag: [UInt8] = [52]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<instruction_sequence>).")
                }
            }
            
            public let body: `Sequence`
            
            public init(body: `Sequence`) {
                self.body = body
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(body: try args[0].tryAs(Sequence.self))
            }
        }
        
        // MARK: LOOP_LEFT
        
        public struct LoopLeft: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .loopLeft(self)
            }
            
            public static let name: String = "LOOP_LEFT"
            public static let tag: [UInt8] = [83]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<instruction_sequence>).")
                }
            }
            
            public let body: `Sequence`
            
            public init(body: `Sequence`) {
                self.body = body
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(body: try args[0].tryAs(Sequence.self))
            }
        }

        // MARK: LAMBDA
        
        public struct Lambda: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .lambda(self)
            }
            
            public static let name: String = "LAMBDA"
            public static let tag: [UInt8] = [49]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 3,
                      (try? args[0].asType()) != nil,
                      (try? args[1].asType()) != nil,
                      (try? args[2].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 2 arguments (<type>, <type>, <instruction_sequence>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct Exec: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .exec(self)
            }
            
            public static let name: String = "EXEC"
            public static let tag: [UInt8] = [38]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Apply: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .apply(self)
            }
            
            public static let name: String = "APPLY"
            public static let tag: [UInt8] = [115]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: DIP
        
        public struct Dip: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .dip(self)
            }
            
            public static let name: String = "DIP"
            public static let tag: [UInt8] = [31]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count <= 2,
                      (
                        args.count == 1 && (try? args[0].tryAs(Sequence.self)) != nil
                      ) || (
                        args.count == 2 &&
                        (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil &&
                        (try? args[1].tryAs(Sequence.self)) != nil
                      )
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have at most 2 arguments (<natural_number_constant>?, <instruction_sequence>).")
                }
            }
            
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
                try Self.validateArgs(args)
                
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
        
        public struct Failwith: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .failwith(self)
            }
            
            public static let name: String = "FAILWITH"
            public static let tag: [UInt8] = [39]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: CAST
        
        public struct Cast: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .cast(self)
            }
            
            public static let name: String = "CAST"
            public static let tag: [UInt8] = [87]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Rename: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .rename(self)
            }
            
            public static let name: String = "RENAME"
            public static let tag: [UInt8] = [88]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Concat: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .concat(self)
            }
            
            public static let name: String = "CONCAT"
            public static let tag: [UInt8] = [26]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Slice: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .slice(self)
            }
            
            public static let name: String = "SLICE"
            public static let tag: [UInt8] = [111]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: PACK
        
        public struct Pack: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .pack(self)
            }
            
            public static let name: String = "PACK"
            public static let tag: [UInt8] = [12]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }

        // MARK: UNPACK
        
        public struct Unpack: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .unpack(self)
            }
            
            public static let name: String = "UNPACK"
            public static let tag: [UInt8] = [13]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }
            
            public let type: `Type`
            
            public init(type: `Type`) {
                self.type = type
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(type: try args[0].asType())
            }
        }

        // MARK: ADD
        
        public struct Add: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .add(self)
            }
            
            public static let name: String = "ADD"
            public static let tag: [UInt8] = [18]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Sub: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .sub(self)
            }
            
            public static let name: String = "SUB"
            public static let tag: [UInt8] = [75]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Mul: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .mul(self)
            }
            
            public static let name: String = "MUL"
            public static let tag: [UInt8] = [58]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Ediv: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .ediv(self)
            }
            
            public static let name: String = "EDIV"
            public static let tag: [UInt8] = [34]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Abs: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .abs(self)
            }
            
            public static let name: String = "ABS"
            public static let tag: [UInt8] = [17]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Isnat: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .isnat(self)
            }
            
            public static let name: String = "ISNAT"
            public static let tag: [UInt8] = [86]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Int: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .int(self)
            }
            
            public static let name: String = "INT"
            public static let tag: [UInt8] = [48]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Neg: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .neg(self)
            }
            
            public static let name: String = "NEG"
            public static let tag: [UInt8] = [59]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Lsl: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .lsl(self)
            }
            
            public static let name: String = "LSL"
            public static let tag: [UInt8] = [53]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Lsr: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .lsr(self)
            }
            
            public static let name: String = "LSR"
            public static let tag: [UInt8] = [54]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Or: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .or(self)
            }
            
            public static let name: String = "OR"
            public static let tag: [UInt8] = [65]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct And: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .and(self)
            }
            
            public static let name: String = "AND"
            public static let tag: [UInt8] = [20]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Xor: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .xor(self)
            }
            
            public static let name: String = "XOR"
            public static let tag: [UInt8] = [81]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Not: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .not(self)
            }
            
            public static let name: String = "NOT"
            public static let tag: [UInt8] = [63]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Compare: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .compare(self)
            }
            
            public static let name: String = "COMPARE"
            public static let tag: [UInt8] = [25]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Eq: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .eq(self)
            }
            
            public static let name: String = "EQ"
            public static let tag: [UInt8] = [37]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Neq: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .neq(self)
            }
            
            public static let name: String = "NEQ"
            public static let tag: [UInt8] = [60]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Lt: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .lt(self)
            }
            
            public static let name: String = "LT"
            public static let tag: [UInt8] = [55]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Gt: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .gt(self)
            }
            
            public static let name: String = "GT"
            public static let tag: [UInt8] = [42]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Le: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .le(self)
            }
            
            public static let name: String = "LE"
            public static let tag: [UInt8] = [50]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Ge: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .ge(self)
            }
            
            public static let name: String = "GE"
            public static let tag: [UInt8] = [40]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct `Self`: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .`self`(self)
            }
            
            public static let name: String = "SELF"
            public static let tag: [UInt8] = [73]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct SelfAddress: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .selfAddress(self)
            }
            
            public static let name: String = "SELF_ADDRESS"
            public static let tag: [UInt8] = [119]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Contract: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .contract(self)
            }
            
            public static let name: String = "CONTRACT"
            public static let tag: [UInt8] = [85]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].asType()) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<type>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct TransferTokens: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .transferTokens(self)
            }
            
            public static let name: String = "TRANSFER_TOKENS"
            public static let tag: [UInt8] = [77]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: SET_DELEGATE
        
        public struct SetDelegate: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .setDelegate(self)
            }
            
            public static let name: String = "SET_DELEGATE"
            public static let tag: [UInt8] = [78]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct CreateContract: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .createContract(self)
            }
            
            public static let name: String = "CREATE_CONTRACT"
            public static let tag: [UInt8] = [29]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 3,
                      (try? args[0].asType()) != nil,
                      (try? args[1].asType()) != nil,
                      (try? args[2].tryAs(Sequence.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 3 arguments (<type>, <type>, <instruction_sequence>).")
                }
            }

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
                try Self.validateArgs(args)
                
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
        
        public struct ImplicitAccount: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .implicitAccount(self)
            }
            
            public static let name: String = "IMPLICIT_ACCOUNT"
            public static let tag: [UInt8] = [30]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct VotingPower: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .votingPower(self)
            }
            
            public static let name: String = "VOTING_POWER"
            public static let tag: [UInt8] = [123]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: NOW
        
        public struct Now: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .now(self)
            }
            
            public static let name: String = "NOW"
            public static let tag: [UInt8] = [64]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Level: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .level(self)
            }
            
            public static let name: String = "LEVEL"
            public static let tag: [UInt8] = [118]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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

        // MARK: AMOUNT
        
        public struct Amount: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .amount(self)
            }
            
            public static let name: String = "AMOUNT"
            public static let tag: [UInt8] = [19]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Balance: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .balance(self)
            }
            
            public static let name: String = "BALANCE"
            public static let tag: [UInt8] = [21]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct CheckSignature: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .checkSignature(self)
            }
            
            public static let name: String = "CHECK_SIGNATURE"
            public static let tag: [UInt8] = [24]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Blake2B: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .blake2b(self)
            }
            
            public static let name: String = "BLAKE2B"
            public static let tag: [UInt8] = [14]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Keccak: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .keccak(self)
            }
            
            public static let name: String = "KECCAK"
            public static let tag: [UInt8] = [125]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Sha3: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .sha3(self)
            }
            
            public static let name: String = "SHA3"
            public static let tag: [UInt8] = [126]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Sha256: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .sha256(self)
            }
            
            public static let name: String = "SHA256"
            public static let tag: [UInt8] = [15]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Sha512: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .sha512(self)
            }
            
            public static let name: String = "SHA512"
            public static let tag: [UInt8] = [16]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct HashKey: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .hashKey(self)
            }
            
            public static let name: String = "HASH_KEY"
            public static let tag: [UInt8] = [43]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Source: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .source(self)
            }
            
            public static let name: String = "SOURCE"
            public static let tag: [UInt8] = [71]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Sender: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .sender(self)
            }
            
            public static let name: String = "SENDER"
            public static let tag: [UInt8] = [72]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct Address: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .address(self)
            }
            
            public static let name: String = "ADDRESS"
            public static let tag: [UInt8] = [84]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct ChainID: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .chainID(self)
            }
            
            public static let name: String = "CHAIN_ID"
            public static let tag: [UInt8] = [117]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }

            public var annotations: [Annotation] {
                let annotations: [Annotation?] = [metadata.variableName]
                return annotations.compactMap { $0 }
            }
            
            public let metadata: Metadata
            
            public init(metadata: Metadata = .init()) {
                self.metadata = metadata
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
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
        
        public struct TotalVotingPower: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .totalVotingPower(self)
            }
            
            public static let name: String = "TOTAL_VOTING_POWER"
            public static let tag: [UInt8] = [124]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: PAIRING_CHECK
        
        public struct PairingCheck: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .pairingCheck(self)
            }
            
            public static let name: String = "PAIRING_CHECK"
            public static let tag: [UInt8] = [127]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }

        // MARK: SAPLING_EMPTY_STATE
        
        public struct SaplingEmptyState: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .saplingEmptyState(self)
            }
            
            public static let name: String = "SAPLING_EMPTY_STATE"
            public static let tag: [UInt8] = [133]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 1,
                      (try? args[0].tryAs(Data.NaturalNumberConstant.self)) != nil
                else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 1 argument (<natural_number_constant>).")
                }
            }

            public let memoSize: Data.NaturalNumberConstant
            
            public init(memoSize: Data.NaturalNumberConstant) {
                self.memoSize = memoSize
            }

            public init(memoSize: UInt) {
                self.init(memoSize: .init(memoSize))
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                
                self.init(memoSize: try args[0].tryAs(Data.NaturalNumberConstant.self))
            }
        }

        // MARK: SAPLING_VERIFY_UPDATE
        
        public struct SaplingVerifyUpdate: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .saplingVerifyUpdate(self)
            }
            
            public static let name: String = "SAPLING_VERIFY_UPDATE"
            public static let tag: [UInt8] = [134]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: TICKET
        
        public struct Ticket: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .ticket(self)
            }
            
            public static let name: String = "TICKET"
            public static let tag: [UInt8] = [136]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }

        // MARK: READ_TICKET
        
        public struct ReadTicket: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .readTicket(self)
            }
            
            public static let name: String = "READ_TICKET"
            public static let tag: [UInt8] = [137]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: SPLIT_TICKET
        
        public struct SplitTicket: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .splitTicket(self)
            }
            
            public static let name: String = "SPLIT_TICKET"
            public static let tag: [UInt8] = [138]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }

        // MARK: JOIN_TICKETS
        
        public struct JoinTickets: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .joinTickets(self)
            }
            
            public static let name: String = "JOIN_TICKETS"
            public static let tag: [UInt8] = [139]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init() {}
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
                self.init()
            }
        }

        // MARK: OPEN_CHEST
        
        public struct OpenChest: `Protocol`, Prim.`Protocol`, Hashable {
            public func asMichelsonInstruction() -> Instruction {
                .openChest(self)
            }
            
            public static let name: String = "OPEN_CHEST"
            public static let tag: [UInt8] = [143]
            
            public static func validateArgs(_ args: [Michelson]) throws {
                guard args.count == 0 else {
                    throw TezosError.invalidValue("Expected Michelson \(Self.name) to have 0 arguments.")
                }
            }
            
            public init(args: [Michelson], annots: [Annotation]) throws {
                try Self.validateArgs(args)
            }
        }
    }
}

public protocol MichelsonInsturctionProtocol: Michelson.Data.`Protocol` {
    func asMichelsonInstruction() -> Michelson.Instruction
}

public extension Michelson.Instruction.`Protocol` {
    func asMichelsonData() -> Michelson.Data {
        .instruction(asMichelsonInstruction())
    }
}

// MARK: Prim

extension Michelson.Instruction {
    public enum Prim: Hashable, RawRepresentable, CaseIterable {
        public typealias `Protocol` = MichelsonInstructionPrimProtocol
        public typealias RawValue = `Protocol`.Type
        
        case drop
        case dup
        case swap
        case dig
        case dug
        case push
        case some
        case none
        case unit
        case never
        case ifNone
        case pair
        case car
        case cdr
        case unpair
        case left
        case right
        case ifLeft
        case `nil`
        case cons
        case ifCons
        case size
        case emptySet
        case emptyMap
        case emptyBigMap
        case map
        case iter
        case mem
        case get
        case update
        case getAndUpdate
        case `if`
        case loop
        case loopLeft
        case lambda
        case exec
        case apply
        case dip
        case failwith
        case cast
        case rename
        case concat
        case slice
        case pack
        case unpack
        case add
        case sub
        case mul
        case ediv
        case abs
        case isnat
        case int
        case neg
        case lsl
        case lsr
        case or
        case and
        case xor
        case not
        case compare
        case eq
        case neq
        case lt
        case gt
        case le
        case ge
        case `self`
        case selfAddress
        case contract
        case transferTokens
        case setDelegate
        case createContract
        case implicitAccount
        case votingPower
        case now
        case level
        case amount
        case balance
        case checkSignature
        case blake2b
        case keccak
        case sha3
        case sha256
        case sha512
        case hashKey
        case source
        case sender
        case address
        case chainID
        case totalVotingPower
        case pairingCheck
        case saplingEmptyState
        case saplingVerifyUpdate
        case ticket
        case readTicket
        case splitTicket
        case joinTickets
        case openChest
        
        public static let allRawValues: [RawValue] = allCases.map { $0.rawValue }
        
        public init?(rawValue: RawValue) {
            switch rawValue {
            case is Drop.Type:
                self = .drop
            case is Dup.Type:
                self = .dup
            case is Swap.Type:
                self = .swap
            case is Dig.Type:
                self = .dig
            case is Dug.Type:
                self = .dug
            case is Push.Type:
                self = .push
            case is Some.Type:
                self = .some
            case is None.Type:
                self = .none
            case is Unit.Type:
                self = .unit
            case is Never.Type:
                self = .never
            case is IfNone.Type:
                self = .ifNone
            case is Pair.Type:
                self = .pair
            case is Car.Type:
                self = .car
            case is Cdr.Type:
                self = .cdr
            case is Unpair.Type:
                self = .unpair
            case is Left.Type:
                self = .left
            case is Right.Type:
                self = .right
            case is IfLeft.Type:
                self = .ifLeft
            case is Nil.Type:
                self = .`nil`
            case is Cons.Type:
                self = .cons
            case is IfCons.Type:
                self = .ifCons
            case is Size.Type:
                self = .size
            case is EmptySet.Type:
                self = .emptySet
            case is EmptyMap.Type:
                self = .emptyMap
            case is EmptyBigMap.Type:
                self = .emptyBigMap
            case is Map.Type:
                self = .map
            case is Iter.Type:
                self = .iter
            case is Mem.Type:
                self = .mem
            case is Get.Type:
                self = .get
            case is Update.Type:
                self = .update
            case is GetAndUpdate.Type:
                self = .getAndUpdate
            case is If.Type:
                self = .`if`
            case is Loop.Type:
                self = .loop
            case is LoopLeft.Type:
                self = .loopLeft
            case is Lambda.Type:
                self = .lambda
            case is Exec.Type:
                self = .exec
            case is Apply.Type:
                self = .apply
            case is Dip.Type:
                self = .dip
            case is Failwith.Type:
                self = .failwith
            case is Cast.Type:
                self = .cast
            case is Rename.Type:
                self = .rename
            case is Concat.Type:
                self = .concat
            case is Slice.Type:
                self = .slice
            case is Pack.Type:
                self = .pack
            case is Unpack.Type:
                self = .unpack
            case is Add.Type:
                self = .add
            case is Sub.Type:
                self = .sub
            case is Mul.Type:
                self = .mul
            case is Ediv.Type:
                self = .ediv
            case is Abs.Type:
                self = .abs
            case is Isnat.Type:
                self = .isnat
            case is Int.Type:
                self = .int
            case is Neg.Type:
                self = .neg
            case is Lsl.Type:
                self = .lsl
            case is Lsr.Type:
                self = .lsr
            case is Or.Type:
                self = .or
            case is And.Type:
                self = .and
            case is Xor.Type:
                self = .xor
            case is Not.Type:
                self = .not
            case is Compare.Type:
                self = .compare
            case is Eq.Type:
                self = .eq
            case is Neq.Type:
                self = .neq
            case is Lt.Type:
                self = .lt
            case is Gt.Type:
                self = .gt
            case is Le.Type:
                self = .le
            case is Ge.Type:
                self = .ge
            case is `Self`.Type:
                self = .`self`
            case is SelfAddress.Type:
                self = .selfAddress
            case is Contract.Type:
                self = .contract
            case is TransferTokens.Type:
                self = .transferTokens
            case is SetDelegate.Type:
                self = .setDelegate
            case is CreateContract.Type:
                self = .createContract
            case is ImplicitAccount.Type:
                self = .implicitAccount
            case is VotingPower.Type:
                self = .votingPower
            case is Now.Type:
                self = .now
            case is Level.Type:
                self = .level
            case is Amount.Type:
                self = .amount
            case is Balance.Type:
                self = .balance
            case is CheckSignature.Type:
                self = .checkSignature
            case is Blake2B.Type:
                self = .blake2b
            case is Keccak.Type:
                self = .keccak
            case is Sha3.Type:
                self = .sha3
            case is Sha256.Type:
                self = .sha256
            case is Sha512.Type:
                self = .sha512
            case is HashKey.Type:
                self = .hashKey
            case is Source.Type:
                self = .source
            case is Sender.Type:
                self = .sender
            case is Address.Type:
                self = .address
            case is ChainID.Type:
                self = .chainID
            case is TotalVotingPower.Type:
                self = .totalVotingPower
            case is PairingCheck.Type:
                self = .pairingCheck
            case is SaplingEmptyState.Type:
                self = .saplingEmptyState
            case is SaplingVerifyUpdate.Type:
                self = .saplingVerifyUpdate
            case is Ticket.Type:
                self = .ticket
            case is ReadTicket.Type:
                self = .readTicket
            case is SplitTicket.Type:
                self = .splitTicket
            case is JoinTickets.Type:
                self = .joinTickets
            case is OpenChest.Type:
                self = .openChest 
            default:
                return nil
            }
        }
        
        public var rawValue: RawValue {
            switch self {
            case .drop:
                return Drop.self
            case .dup:
                return Dup.self
            case .swap:
                return Swap.self
            case .dig:
                return Dig.self
            case .dug:
                return Dug.self
            case .push:
                return Push.self
            case .some:
                return Some.self
            case .none:
                return None.self
            case .unit:
                return Unit.self
            case .never:
                return Never.self
            case .ifNone:
                return IfNone.self
            case .pair:
                return Pair.self
            case .car:
                return Car.self
            case .cdr:
                return Cdr.self
            case .unpair:
                return Unpair.self
            case .left:
                return Left.self
            case .right:
                return Right.self
            case .ifLeft:
                return IfLeft.self
            case .`nil`:
                return Nil.self
            case .cons:
                return Cons.self
            case .ifCons:
                return IfCons.self
            case .size:
                return Size.self
            case .emptySet:
                return EmptySet.self
            case .emptyMap:
                return EmptyMap.self
            case .emptyBigMap:
                return EmptyBigMap.self
            case .map:
                return Map.self
            case .iter:
                return Iter.self
            case .mem:
                return Mem.self
            case .get:
                return Get.self
            case .update:
                return Update.self
            case .getAndUpdate:
                return GetAndUpdate.self
            case .`if`:
                return If.self
            case .loop:
                return Loop.self
            case .loopLeft:
                return LoopLeft.self
            case .lambda:
                return Lambda.self
            case .exec:
                return Exec.self
            case .apply:
                return Apply.self
            case .dip:
                return Dip.self
            case .failwith:
                return Failwith.self
            case .cast:
                return Cast.self
            case .rename:
                return Rename.self
            case .concat:
                return Concat.self
            case .slice:
                return Slice.self
            case .pack:
                return Pack.self
            case .unpack:
                return Unpack.self
            case .add:
                return Add.self
            case .sub:
                return Sub.self
            case .mul:
                return Mul.self
            case .ediv:
                return Ediv.self
            case .abs:
                return Abs.self
            case .isnat:
                return Isnat.self
            case .int:
                return Int.self
            case .neg:
                return Neg.self
            case .lsl:
                return Lsl.self
            case .lsr:
                return Lsr.self
            case .or:
                return Or.self
            case .and:
                return And.self
            case .xor:
                return Xor.self
            case .not:
                return Not.self
            case .compare:
                return Compare.self
            case .eq:
                return Eq.self
            case .neq:
                return Neq.self
            case .lt:
                return Lt.self
            case .gt:
                return Gt.self
            case .le:
                return Le.self
            case .ge:
                return Ge.self
            case .`self`:
                return `Self`.self
            case .selfAddress:
                return SelfAddress.self
            case .contract:
                return Contract.self
            case .transferTokens:
                return TransferTokens.self
            case .setDelegate:
                return SetDelegate.self
            case .createContract:
                return CreateContract.self
            case .implicitAccount:
                return ImplicitAccount.self
            case .votingPower:
                return VotingPower.self
            case .now:
                return Now.self
            case .level:
                return Level.self
            case .amount:
                return Amount.self
            case .balance:
                return Balance.self
            case .checkSignature:
                return CheckSignature.self
            case .blake2b:
                return Blake2B.self
            case .keccak:
                return Keccak.self
            case .sha3:
                return Sha3.self
            case .sha256:
                return Sha256.self
            case .sha512:
                return Sha512.self
            case .hashKey:
                return HashKey.self
            case .source:
                return Source.self
            case .sender:
                return Sender.self
            case .address:
                return Address.self
            case .chainID:
                return ChainID.self
            case .totalVotingPower:
                return TotalVotingPower.self
            case .pairingCheck:
                return PairingCheck.self
            case .saplingEmptyState:
                return SaplingEmptyState.self
            case .saplingVerifyUpdate:
                return SaplingVerifyUpdate.self
            case .ticket:
                return Ticket.self
            case .readTicket:
                return ReadTicket.self
            case .splitTicket:
                return SplitTicket.self
            case .joinTickets:
                return JoinTickets.self
            case .openChest:
                return OpenChest.self
            }
        }
    }
}

public protocol MichelsonInstructionPrimProtocol: Michelson.Data.Prim.`Protocol` {}

// MARK: Utility Extensions

extension Michelson.Instruction {
    var common: `Protocol` {
        switch self {
        case .sequence(let sequence):
            return sequence
        case .drop(let drop):
            return drop
        case .dup(let dup):
            return dup
        case .swap(let swap):
            return swap
        case .dig(let dig):
            return dig
        case .dug(let dug):
            return dug
        case .push(let push):
            return push
        case .some(let some):
            return some
        case .none(let none):
            return none
        case .unit(let unit):
            return unit
        case .never(let never):
            return never
        case .ifNone(let ifNone):
            return ifNone
        case .pair(let pair):
            return pair
        case .car(let car):
            return car
        case .cdr(let cdr):
            return cdr
        case .unpair(let unpair):
            return unpair
        case .left(let left):
            return left
        case .right(let right):
            return right
        case .ifLeft(let ifLeft):
            return ifLeft
        case .nil(let `nil`):
            return `nil`
        case .cons(let cons):
            return cons
        case .ifCons(let ifCons):
            return ifCons
        case .size(let size):
            return size
        case .emptySet(let emptySet):
            return emptySet
        case .emptyMap(let emptyMap):
            return emptyMap
        case .emptyBigMap(let emptyBigMap):
            return emptyBigMap
        case .map(let map):
            return map
        case .iter(let iter):
            return iter
        case .mem(let mem):
            return mem
        case .get(let get):
            return get
        case .update(let update):
            return update
        case .getAndUpdate(let getAndUpdate):
            return getAndUpdate
        case .if(let `if`):
            return `if`
        case .loop(let loop):
            return loop
        case .loopLeft(let loopLeft):
            return loopLeft
        case .lambda(let lambda):
            return lambda
        case .exec(let exec):
            return exec
        case .apply(let apply):
            return apply
        case .dip(let dip):
            return dip
        case .failwith(let failwith):
            return failwith
        case .cast(let cast):
            return cast
        case .rename(let rename):
            return rename
        case .concat(let concat):
            return concat
        case .slice(let slice):
            return slice
        case .pack(let pack):
            return pack
        case .unpack(let unpack):
            return unpack
        case .add(let add):
            return add
        case .sub(let sub):
            return sub
        case .mul(let mul):
            return mul
        case .ediv(let ediv):
            return ediv
        case .abs(let abs):
            return abs
        case .isnat(let isnat):
            return isnat
        case .int(let int):
            return int
        case .neg(let neg):
            return neg
        case .lsl(let lsl):
            return lsl
        case .lsr(let lsr):
            return lsr
        case .or(let or):
            return or
        case .and(let and):
            return and
        case .xor(let xor):
            return xor
        case .not(let not):
            return not
        case .compare(let compare):
            return compare
        case .eq(let eq):
            return eq
        case .neq(let neq):
            return neq
        case .lt(let lt):
            return lt
        case .gt(let gt):
            return gt
        case .le(let le):
            return le
        case .ge(let ge):
            return ge
        case .`self`(let `self`):
            return `self`
        case .selfAddress(let selfAddress):
            return selfAddress
        case .contract(let contract):
            return contract
        case .transferTokens(let transferTokens):
            return transferTokens
        case .setDelegate(let setDelegate):
            return setDelegate
        case .createContract(let createContract):
            return createContract
        case .implicitAccount(let implicitAccount):
            return implicitAccount
        case .votingPower(let votingPower):
            return votingPower
        case .now(let now):
            return now
        case .level(let level):
            return level
        case .amount(let amount):
            return amount
        case .balance(let balance):
            return balance
        case .checkSignature(let checkSignature):
            return checkSignature
        case .blake2b(let blake2b):
            return blake2b
        case .keccak(let keccak):
            return keccak
        case .sha3(let sha3):
            return sha3
        case .sha256(let sha256):
            return sha256
        case .sha512(let sha512):
            return sha512
        case .hashKey(let hashKey):
            return hashKey
        case .source(let source):
            return source
        case .sender(let sender):
            return sender
        case .address(let address):
            return address
        case .chainID(let chainID):
            return chainID
        case .totalVotingPower(let totalVotingPower):
            return totalVotingPower
        case .pairingCheck(let pairingCheck):
            return pairingCheck
        case .saplingEmptyState(let saplingEmptyState):
            return saplingEmptyState
        case .saplingVerifyUpdate(let saplingVerifyUpdate):
            return saplingVerifyUpdate
        case .ticket(let ticket):
            return ticket
        case .readTicket(let readTicket):
            return readTicket
        case .splitTicket(let splitTicket):
            return splitTicket
        case .joinTickets(let joinTickets):
            return joinTickets
        case .openChest(let openChest):
            return openChest
        }
    }
}
