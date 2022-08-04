//
//  MichelineAsPrim.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import TezosCore

// MARK: Micheline

public extension Micheline {
    func asPrim(_ prims: Michelson.Prim...) throws -> Micheline.PrimitiveApplication {
        try asPrim(prims)
    }
    
    func asPrim(_ prims: [Michelson.Prim]) throws -> Micheline.PrimitiveApplication {
        guard case let .prim(primitiveApplication) = self else {
            throw TezosError.invalidValue("Micheline value \(self) is not a primitive application.") // TODO: use expression
        }
        
        return try primitiveApplication.asPrim(prims)
    }
    
    func asPrim(_ prims: [Michelson.Prim.RawValue]) throws -> Micheline.PrimitiveApplication {
        let prims = prims.compactMap { Michelson.Prim(rawValue: $0) }
        return try asPrim(prims)
    }
}

// MARK: Micheline.PrimitiveApplication

public extension Micheline.PrimitiveApplication {
    func asPrim(_ prims: Michelson.Prim...) throws -> Micheline.PrimitiveApplication {
        try asPrim(prims)
    }
    
    func asPrim(_ prims: [Michelson.Prim]) throws -> Micheline.PrimitiveApplication {
        guard prims.isEmpty || prims.contains(where: { $0.rawValue.name == prim }) else {
            throw TezosError.invalidValue("Micheline primitive application value \(self) is not any of \(prims.map({ $0.rawValue.name })).") // TODO: use expression
        }
        
        return self
    }
    
    func asPrim(_ prims: [Michelson.Prim.RawValue]) throws -> Micheline.PrimitiveApplication {
        let prims = prims.compactMap { Michelson.Prim(rawValue: $0) }
        return try asPrim(prims)
    }
}
