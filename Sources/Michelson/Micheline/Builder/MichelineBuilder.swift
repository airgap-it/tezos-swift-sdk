//
//  MichelineBuilder.swift
//  
//
//  Created by Julia Samol on 03.08.22.
//

public extension Micheline {
    
    // MARK: Literal
    
    static func int<S: StringProtocol>(_ value: S) throws -> Micheline {
        .literal(.integer(try .init(value)))
    }
    
    static func int<I: SignedInteger>(_ value: I) -> Micheline {
        .literal(.integer(.init(value)))
    }
    
    static func int<I: UnsignedInteger>(_ value: I) -> Micheline {
        .literal(.integer(.init(value)))
    }
    
    static func string<S: StringProtocol>(_ value: S) throws -> Micheline {
        .literal(.string(try .init(value)))
    }
    
    static func bytes<S: StringProtocol>(_ value: S) throws -> Micheline {
        .literal(.bytes(try .init(value)))
    }
    
    static func bytes(_ value: [UInt8]) -> Micheline {
        .literal(.bytes(.init(value)))
    }
    
    // MARK: PrimitiveApplication
    
    static func data(prim: Michelson.Data.Prim, args: [Micheline] = [], annots: [String]) throws -> Micheline {
        .prim(try .init(prim: .data(prim), args: args, annots: annots))
    }
    
    static func data(prim: Michelson.Data.Prim, args: [Micheline] = []) -> Micheline {
        .prim(.init(prim: .data(prim), args: args))
    }
    
    static func instruction(prim: Michelson.Instruction.Prim, args: [Micheline] = [], annots: [String]) throws -> Micheline {
        .prim(try .init(prim: .data(.instruction(prim)), args: args, annots: annots))
    }
    
    static func instruction(prim: Michelson.Instruction.Prim, args: [Micheline] = []) -> Micheline {
        .prim(.init(prim: .data(.instruction(prim)), args: args))
    }
    
    static func type(prim: Michelson.`Type`.Prim, args: [Micheline] = [], annots: [String]) throws -> Micheline {
        .prim(try .init(prim: .type(prim), args: args, annots: annots))
    }
    
    static func type(prim: Michelson.`Type`.Prim, args: [Micheline] = []) -> Micheline {
        .prim(.init(prim: .type(prim), args: args))
    }
    
    static func comparableType(prim: Michelson.ComparableType.Prim, args: [Micheline] = [], annots: [String]) throws -> Micheline {
        .prim(try .init(prim: .type(.comparable(prim)), args: args, annots: annots))
    }
    
    static func comparableType(prim: Michelson.ComparableType.Prim, args: [Micheline] = []) -> Micheline {
        .prim(.init(prim: .type(.comparable(prim)), args: args))
    }
}
