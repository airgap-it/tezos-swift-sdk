//
//  MichelineNormalized.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import TezosCore

// MARK: Micheline

public extension Micheline {
    func normalized() throws -> Micheline {
        switch self {
        case .literal(let literal):
            return literal.normalized().asMicheline()
        case .prim(let primitiveApplication):
            return try primitiveApplication.normalized().asMicheline()
        case .sequence(let sequence):
            return try sequence.normalized().asMicheline()
        }
    }
}

// MARK: Micheline.Literal

public extension Micheline.Literal {
    func normalized() -> Micheline.Literal {
        self
    }
}

// MARK: Micheline.PrimitiveApplication

public extension Micheline.PrimitiveApplication {
    func normalized() throws -> Micheline.PrimitiveApplication {
        try .init(prim: prim, args: try normalizedArgs(), annots: annots)
    }
    
    private func normalizedArgs() throws -> [Micheline] {
        guard let pair = try? asPrim(Michelson.Data.Pair.self, Michelson.Type_.Pair.self, Michelson.ComparableType.Pair.self), pair.args.count > 2 else {
            return try args.map({ try $0.normalized() })
        }
        
        return [
            try pair.args[0].normalized(),
            .prim(
                try .init(
                    prim: pair.prim,
                    args: Array(pair.args[1...]),
                    annots: []
                ).normalized()
            )
        ]
    }
}

// MARK: Micheline.Sequence

public extension Micheline.Sequence {
    func normalized() throws -> Micheline.Sequence {
        try map { try $0.normalized() }
    }
}
