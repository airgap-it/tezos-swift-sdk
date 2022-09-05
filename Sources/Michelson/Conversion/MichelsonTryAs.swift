//
//  MichelsonTryAs.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import TezosCore

public extension Michelson {
    func tryAs<T: `Protocol`>(_ type: T.Type) throws -> T {
        guard let asT = common as? T else {
            throw TezosError.unexpectedType(expected: "\(type.self)", actual: "\(common.self)")
        }
        
        return asT
    }
}

public extension Michelson.Data {
    func tryAs<T: `Protocol`>(_ type: T.Type) throws -> T {
        guard let asT = common as? T else {
            throw TezosError.unexpectedType(expected: "\(type.self)", actual: "\(common.self)")
        }
        
        return asT
    }
}

public extension Michelson.Instruction {
    func tryAs<T: `Protocol`>(_ type: T.Type) throws -> T {
        guard let asT = common as? T else {
            throw TezosError.unexpectedType(expected: "\(type.self)", actual: "\(common.self)")
        }
        
        return asT
    }
}

public extension Michelson.`Type` {
    func tryAs<T: `Protocol`>(_ type: T.Type) throws -> T {
        guard let asT = common as? T else {
            throw TezosError.unexpectedType(expected: "\(type.self)", actual: "\(common.self)")
        }
        
        return asT
    }
}

public extension Michelson.ComparableType {
    func tryAs<T: `Protocol`>(_ type: T.Type) throws -> T {
        guard let asT = common as? T else {
            throw TezosError.unexpectedType(expected: "\(type.self)", actual: "\(common.self)")
        }
        
        return asT
    }
}
