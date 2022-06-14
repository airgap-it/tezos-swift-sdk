//
//  MichelineAsPrim.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation
import TezosCore

// MARK: Micheline

public extension Micheline {
    func asPrim<T: Michelson.Prim>(_ prim: T.Type) throws -> Micheline.PrimitiveApplication {
        guard case let .prim(primitiveApplication) = self else {
            throw TezosError.invalidValue("Micheline value \(self) is not a primitive application.") // TODO: use expression
        }
        
        return try primitiveApplication.asPrim(prim)
    }
}

// MARK: Micheline.PrimitiveApplication

public extension Micheline.PrimitiveApplication {
    func asPrim<T: Michelson.Prim>(_ prim: T.Type) throws -> Micheline.PrimitiveApplication {
        guard self.prim == prim.name else {
            throw TezosError.invalidValue("Micheline primitive application value \(self) is not \(prim.name).") // TODO: use expression
        }
        
        return self
    }
}
