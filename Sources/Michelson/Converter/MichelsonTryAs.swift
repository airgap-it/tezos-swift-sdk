//
//  MichelsonConverter.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import Foundation
import TezosCore

public extension Michelson {
    func tryAs<T: `Protocol`>(_ type: T.Type) throws -> T {
        let asProtocol = asProtocol()
        guard let asT = asProtocol as? T else {
            throw TezosError.unexpectedType(expected: "\(type.self)", actual: "\(asProtocol.self)")
        }
        
        return asT
    }
}
