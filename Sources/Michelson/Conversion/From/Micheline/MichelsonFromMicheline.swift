//
//  MichelsonFromMicheline.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import TezosCore

// MARK: From Micheline

extension Michelson: ConvertibleFromMicheline {
    
    public init(from micheline: Micheline) throws {
        switch micheline {
        case .literal(let literal):
            try self.init(from: literal)
        case .prim(let primitiveApplication):
            try self.init(from: primitiveApplication)
        case .sequence(let sequence):
            try self.init(from: sequence)
        }
    }
}

// MARK: From MichelineLiteral

extension Michelson: ConvertibleFromMichelineLiteral {
    
    public init(from literal: Micheline.Literal) throws {
        switch literal {
        case .integer(let integer):
            self = .data(.int(try .init(integer.value)))
        case .string(let string):
            self = .data(.string(try .init(string.value)))
        case .bytes(let bytes):
            self = .data(.bytes(try .init(bytes.value)))
        }
    }
}

// MARK: From MichelinePrimitiveApplication

extension Michelson: ConvertibleFromMichelinePrimitiveApplication {
    
    public init(from primitiveApplication: Micheline.PrimitiveApplication) throws {
        let prims = Self.recognizePrim(primitiveApplication.prim)
        
        guard !prims.isEmpty else {
            throw TezosError.invalidValue("Unrecognized Micheline primitive application: \(primitiveApplication.prim).")
        }
        
        let args = try primitiveApplication.args.map { try Michelson(from: $0) }
        let annots = primitiveApplication.annots.compactMap { Self.annotation(from: $0) }
        
        let resolvedPrim = Self.resolvePrim(from: prims, forArgs: args)
        
        guard let michelson = try resolvedPrim?.rawValue.init(args: args, annots: annots) as? MichelsonProtocol else {
            throw TezosError.invalidValue("Unrecognized Micheline primitive application: \(primitiveApplication.prim).")
        }
        
        self = michelson.asMichelson()
    }
    
    private static func resolvePrim(from prims: [Prim], forArgs args: [Michelson]) -> Prim? {
        prims.first(where: { (try? $0.rawValue.validateArgs(args)) != nil })
    }
}

// MARK: From MichelineSequence

extension Michelson: ConvertibleFromMichelineSequence {
    
    public init(from sequence: Micheline.Sequence) throws {
        if let eltSequence = try? sequence.asEltSequence() {
            self.init(from: eltSequence)
        } else if let michelsonSequence = try? sequence.asMichelsonSequence() {
            try self.init(from: michelsonSequence)
        } else {
            throw TezosError.invalidValue("Invalid Micheline sequence: \(sequence).") // TODO: use expression
        }
    }
    
    private init(from eltSequence: [Michelson.Data.Elt]) {
        self = .data(.map(.init(values: eltSequence)))
    }
    
    private init(from sequence: [Michelson]) throws {
        if sequence.isEmpty {
            self = .data(.sequence(.init()))
        } else if let instructionSequence = try? sequence.asInstructionSequence() {
            self = .data(.instruction(.sequence(.init(instructions: instructionSequence))))
        } else if let dataSequence = try? sequence.asDataSequence() {
            self = .data(.sequence(.init(values: dataSequence)))
        } else {
            throw TezosError.invalidValue("Unknown Micheline sequence: \(sequence).") // TODO: use expression
        }
    }
}

// MARK: Utility Extensions

private extension Array where Element == Micheline {
    func asEltSequence() throws -> [Michelson.Data.Elt] {
        try map { node in
            let elt = try node.asPrim(.data(.elt))
            return try .init(args: try elt.args.map({ try Michelson(from: $0) }), annots: [])
        }
    }
    
    func asMichelsonSequence() throws -> [Michelson] {
        try map { try Michelson(from: $0) }
    }
}

private extension Michelson {
    
    static func annotation(from string: String) -> Annotation? {
        (try? TypeAnnotation(value: string)) ??
        (try? VariableAnnotation(value: string)) ??
        (try? FieldAnnotation(value: string))
    }
}
