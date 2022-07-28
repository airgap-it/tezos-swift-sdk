//
//  MichelinePacking.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import TezosCore

// MARK: Micheline

extension Micheline {

    public init(fromPacked bytes: [UInt8], usingSchema schema: Micheline?) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Invalid Micheline packed bytes.")
        }
        
        switch tag {
        case .node:
            let prePacked = try Micheline(from: Array(bytes[tag.value.count...]))
            if let schema = schema {
                self = try postUnpack(prePacked, usingSchema: schema)
            } else {
                self = prePacked
            }
        }
    }

    public func packToBytes(usingSchema schema: Micheline?) throws -> [UInt8] {
        let prePacked: Micheline = try {
            if let schema = schema {
                return try prePack(self, usingSchema: schema)
            } else {
                return self
            }
        }()
        
        return Tag.node + (try prePacked.encodeToBytes())
    }
}

// MARK: Micheline.Literal

extension Micheline.Literal {
    public init(fromPacked bytes: [UInt8], usingSchema schema: Micheline?) throws {
        guard case let .literal(literal) = try Micheline(fromPacked: bytes, usingSchema: schema) else {
            throw TezosError.invalidValue("Invalid Micheline literal packed bytes.")
        }
        
        self = literal
    }

    public func packToBytes(usingSchema schema: Micheline?) throws -> [UInt8] {
        try Micheline.literal(self).packToBytes(usingSchema: schema)
    }
}

// MARK: Micheline.PrimitiveApplication

extension Micheline.PrimitiveApplication {
    public init(fromPacked bytes: [UInt8], usingSchema schema: Micheline?) throws {
        guard case let .prim(primitiveApplication) = try Micheline(fromPacked: bytes, usingSchema: schema) else {
            throw TezosError.invalidValue("Invalid Micheline primitive application packed bytes.")
        }
        
        self = primitiveApplication
    }

    public func packToBytes(usingSchema schema: Micheline?) throws -> [UInt8] {
        try Micheline.prim(self).packToBytes(usingSchema: schema)
    }
    
    
}

// MARK: Micheline.Sequence

extension Micheline.Sequence {
    public init(fromPacked bytes: [UInt8], usingSchema schema: Micheline?) throws {
        guard case let .sequence(sequence) = try Micheline(fromPacked: bytes, usingSchema: schema) else {
            throw TezosError.invalidValue("Invalid Micheline sequence packed bytes.")
        }
        
        self = sequence
    }

    public func packToBytes(usingSchema schema: Micheline?) throws -> [UInt8] {
        try Micheline.sequence(self).packToBytes(usingSchema: schema)
    }
    
    
}

// MARK: Utilities: Unpack

private func postUnpack(_ value: Micheline, usingSchema schema: Micheline) throws -> Micheline {
    if case let .prim(schema) = schema {
        return try postUnpack(value, usingSchema: schema)
    } else if case let .sequence(schema) = schema, case let .sequence(value) = value {
        guard value.count == schema.count else {
            throw valueSchemaMismatchError(value: .sequence(value), schema: .sequence(schema))
        }
        
        return .sequence(try postUnpack(value, usingSchemas: schema))
    } else {
        throw invalidSchemaError(schema: schema)
    }
}

private func postUnpack(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if let schema = try? schema.asPrim(Michelson._Type.Option.self, Michelson.ComparableType.Option.self) {
        return try postUnpackOptionData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Set.self, Michelson._Type.List.self) {
        return try postUnpackSequenceData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Contract.self, Michelson.ComparableType.Address.self) {
        return try postUnpackAddressData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Pair.self, Michelson.ComparableType.Pair.self) {
        return try postUnpackPairData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Or.self, Michelson.ComparableType.Or.self) {
        return try postUnpackOrData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Lambda.self) {
        return try postUnpackLambdaData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Map.self) {
        return try postUnpackMapData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.BigMap.self) {
        return try postUnpackBigMapData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.ChainID.self) {
        return try postUnpackChainIDData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.KeyHash.self) {
        return try postUnpackKeyHashData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.Key.self) {
        return try postUnpackKeyData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.Signature.self) {
        return try postUnpackSignatureData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.Timestamp.self) {
        return try postUnpackTimestampData(value, usingSchema: schema)
    } else if let _ = try? schema.asPrim(Michelson._Type.allPrims) {
        return value
    } else {
        throw invalidSchemaError(schema: .prim(schema))
    }
}

private func postUnpackOptionData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if let value = try? value.asPrim(Michelson.Data.Some.self), value.args.count == schema.args.count {
        let postUnpackedArgs = try postUnpack(value.args, usingSchemas: schema.args)
        return .prim(
            try .init(prim: value.prim, args: postUnpackedArgs, annots: value.annots)
        )
    } else if let _ = try? value.asPrim(Michelson.Data.None.self) {
        return value
    } else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
}

private func postUnpackSequenceData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .sequence(value) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    guard schema.args.count == 1 else {
        throw invalidSchemaError(schema: .prim(schema))
    }
    
    return .sequence(try postUnpack(value, usingSchema: schema.args[0]))
}

private func postUnpackAddressData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackBytesToString(value, usingSchema: schema) {
        var bytes = $0
        let address = try Address(fromConsuming: &bytes)
        let entrypoint = try String(fromConsuming: &bytes)
        
        return combineAddress(address, with: entrypoint)
    }
}

private func postUnpackPairData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if case let .sequence(value) = value {
        let pair: Micheline = .prim(
            try .init(prim: Michelson.Data.Pair.self, args: value, annots: []).normalized()
        )
        
        return try postUnpack(pair, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Data.Pair.self) {
        let valueNormalized = try value.normalized()
        let schemaNormalized = try schema.normalized()
        
        guard valueNormalized.args.count == schemaNormalized.args.count else {
            throw valueSchemaMismatchError(value: .prim(value), schema: .prim(schema))
        }
        
        let postUnpackedArgs = try postUnpack(valueNormalized.args, usingSchemas: schemaNormalized.args)
        
        return .prim(
            try .init(prim: valueNormalized.prim, args: postUnpackedArgs, annots: valueNormalized.annots)
        )
    } else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
}

private func postUnpackOrData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .prim(value) = value, value.args.count == 1 else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    guard schema.args.count == 2 else {
        throw invalidSchemaError(schema: .prim(schema))
    }
    
    let type: Micheline = try {
        if let _ = try? value.asPrim(Michelson.Data.Left.self) {
            return schema.args[0]
        } else if let _ = try? value.asPrim(Michelson.Data.Right.self) {
            return schema.args[1]
        } else {
            throw valueSchemaMismatchError(value: .prim(value), schema: .prim(schema))
        }
    }()
    
    return .prim(
        try .init(prim: value.prim, args: [try postUnpack(value.args[0], usingSchema: type)], annots: value.annots)
    )
}

private func postUnpackLambdaData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .sequence(value) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    let postUnpacked: [Micheline] = try value.map { node in
        switch node {
        case .literal(_):
            throw valueSchemaMismatchError(value: node, schema: .prim(schema))
        case .prim(let primitiveApplication):
            return try postUnpackInstruction(primitiveApplication, usingSchema: schema)
        case .sequence(_):
            return try postUnpackLambdaData(node, usingSchema: schema)
        }
    }
    
    return .sequence(postUnpacked)
}

private func postUnpackMapData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .sequence(value) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    let postUnpacked: [Micheline] = try value.map { node in
        guard let elt = try? node.asPrim(Michelson.Data.Elt.self), elt.args.count == schema.args.count else {
            throw valueSchemaMismatchError(value: .sequence(value), schema: .prim(schema))
        }
        
        let postUnpackedArgs = try postUnpack(elt.args, usingSchemas: schema.args)
        
        return .prim(
            try .init(prim: elt.prim, args: postUnpackedArgs, annots: elt.annots)
        )
    }
    
    return .sequence(postUnpacked)
}

private func postUnpackBigMapData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .literal(literal) = value, case .integer = literal else {
        return try postUnpackMapData(value, usingSchema: schema)
    }
    
    return value
}

private func postUnpackChainIDData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackBytesToString(value, usingSchema: schema) { try ChainID(from: $0).base58 }
}

private func postUnpackKeyHashData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackBytesToString(value, usingSchema: schema) { try Address.Implicit(from: $0).base58 }
}

private func postUnpackKeyData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackBytesToString(value, usingSchema: schema) { try Key.Public(from: $0).base58 }
}

private func postUnpackSignatureData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackBytesToString(value, usingSchema: schema) { try Signature(from: $0).base58 }
}

private func postUnpackTimestampData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackIntToString(value, usingSchema: schema) {
        Timestamp.millis(Int64($0)).toRFC3339()
    }
}

private func postUnpackInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if let value = try? value.asPrim(Michelson.Instruction.Map.self, Michelson.Instruction.Iter.self) {
        return try postUnpackIteratingInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Loop.self, Michelson.Instruction.LoopLeft.self) {
        return try postUnpackLoopInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Lambda.self) {
        return try postUnpackLambdaInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Dip.self) {
        return try postUnpackDipInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.IfNone.self, Michelson.Instruction.IfCons.self, Michelson.Instruction.If.self) {
        return try postUnpackIfInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Push.self) {
        return try postUnpackPushInstruction(value)
    } else if let value = try? value.asPrim(Michelson.Instruction.CreateContract.self) {
        return try postUnpackCreateContractInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.allPrims) {
        return .prim(value)
    } else {
        throw valueSchemaMismatchError(value: .prim(value), schema: .prim(schema))
    }
}

private func postUnpackIteratingInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackInstructionArgument(value, usingSchema: schema, at: 0)
}

private func postUnpackLoopInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackInstructionArgument(value, usingSchema: schema, at: 0)
}

private func postUnpackLambdaInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackInstructionArgument(value, usingSchema: schema, at: 2)
}

private func postUnpackDipInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackInstructionArgument(value, usingSchema: schema, at: value.args.count - 1)
}

private func postUnpackCreateContractInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try postUnpackInstructionArgument(value, usingSchema: schema, at: 2)
}

private func postUnpackIfInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard value.args.count == 2 else {
        throw invalidValueError(value: .prim(value))
    }
    
    let postUnpackedArgs = try value.args.map { arg in
        try postUnpackLambdaData(arg, usingSchema: schema)
    }
    
    return .prim(
        try .init(prim: value.prim, args: postUnpackedArgs, annots: value.annots)
    )
}

private func postUnpackPushInstruction(_ value: Micheline.PrimitiveApplication) throws -> Micheline {
    guard value.args.count == 2 else {
        throw invalidValueError(value: .prim(value))
    }

    let schema = value.args[0]
    let data = value.args[1]

    return .prim(
        try .init(prim: value.prim, args: [schema, try postUnpack(data, usingSchema: schema)], annots: value.annots)
    )
}

private func postUnpackBytesToString(
    _ value: Micheline,
    usingSchema schema: Micheline.PrimitiveApplication,
    postUnpackingWith postUnpack: ([UInt8]) throws -> String
) throws -> Micheline {
    guard case let .literal(literal) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    switch literal {
    case .integer(_):
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    case .string(let string):
        return .literal(.string(string))
    case .bytes(let bytes):
        return .literal(.string(try .init(try postUnpack([UInt8](from: bytes)))))
    }
}

private func postUnpackIntToString(
    _ value: Micheline,
    usingSchema schema: Micheline.PrimitiveApplication,
    postUnpackingWith postUnpack: (Int) throws -> String
) throws -> Micheline {
    guard case let .literal(literal) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    switch literal {
    case .integer(let integer):
        return .literal(.string(try .init(try postUnpack(Int(integer.value)!))))
    case .string(let string):
        return .literal(.string(string))
    case .bytes(_):
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
}

private func postUnpackInstructionArgument(
    _ value: Micheline.PrimitiveApplication,
    usingSchema schema: Micheline.PrimitiveApplication,
    at index: Int
) throws -> Micheline {
    guard index >= 0, index < value.args.count else {
        throw invalidValueError(value: .prim(value))
    }
    
    let postUnpackedArg = try postUnpackLambdaData(value.args[index], usingSchema: schema)
    return .prim(
        try .init(prim: value.prim, args: value.args.replacing(postUnpackedArg, at: index), annots: value.annots)
    )
}

private func postUnpack(_ values: [Micheline], usingSchemas schemas: [Micheline]) throws -> [Micheline] {
    try zip(values, schemas).map { try postUnpack($0, usingSchema: $1) }
}

private func postUnpack(_ values: [Micheline], usingSchema schema: Micheline) throws -> [Micheline] {
    try values.map { try postUnpack($0, usingSchema: schema) }
}

private func combineAddress(_ address: Address, with entrypoint: String) -> String {
    guard !entrypoint.isEmpty else {
        return address.base58
    }
    
    return "\(address.base58)\(Michelson.ComparableType.Address.entrypointSeparator)\(entrypoint)"
}

// MARK: Utilities: Pack

private func prePack(_ value: Micheline, usingSchema schema: Micheline) throws -> Micheline {
    if case let .prim(schema) = schema {
        return try prePack(value, usingSchema: schema)
    } else if case let .sequence(schema) = schema, case let .sequence(value) = value {
        guard value.count == schema.count else {
            throw valueSchemaMismatchError(value: .sequence(value), schema: .sequence(schema))
        }
        
        return .sequence(try prePack(value, usingSchemas: schema))
    } else {
        throw invalidSchemaError(schema: schema)
    }
}

private func prePack(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if let schema = try? schema.asPrim(Michelson._Type.Option.self, Michelson.ComparableType.Option.self) {
        return try prePackOptionData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Set.self, Michelson._Type.List.self) {
        return try prePackSequenceData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Contract.self, Michelson.ComparableType.Address.self) {
        return try prePackAddressData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Pair.self, Michelson.ComparableType.Pair.self) {
        return try prePackPairData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Or.self, Michelson.ComparableType.Or.self) {
        return try prePackOrData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Lambda.self) {
        return try prePackLambdaData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.Map.self) {
        return try prePackMapData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson._Type.BigMap.self) {
        return try prePackBigMapData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.ChainID.self) {
        return try prePackChainIDData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.KeyHash.self) {
        return try prePackKeyHashData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.Key.self) {
        return try prePackKeyData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.Signature.self) {
        return try prePackSignatureData(value, usingSchema: schema)
    } else if let schema = try? schema.asPrim(Michelson.ComparableType.Timestamp.self) {
        return try prePackTimestampData(value, usingSchema: schema)
    } else if let _ = try? schema.asPrim(Michelson._Type.allPrims) {
        return value
    } else {
        throw invalidSchemaError(schema: .prim(schema))
    }
}

private func prePackOptionData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if let value = try? value.asPrim(Michelson.Data.Some.self), value.args.count == schema.args.count {
        let prePackedArgs = try prePack(value.args, usingSchemas: schema.args)
        return .prim(
            try .init(prim: value.prim, args: prePackedArgs, annots: value.annots)
        )
    } else if let _ = try? value.asPrim(Michelson.Data.None.self) {
        return value
    } else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
}

private func prePackSequenceData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .sequence(value) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    guard schema.args.count == 1 else {
        throw invalidSchemaError(schema: .prim(schema))
    }
    
    return .sequence(try prePack(value, usingSchema: schema.args[0]))
}

private func prePackAddressData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackStringToBytes(value, usingSchema: schema) {
        let (address, entrypoint) = splitAddress($0)
        let addressBytes = try Address(base58: address).encodeToBytes()
        let entrypointBytes = try entrypoint?.encodeToBytes() ?? []
        
        return addressBytes + entrypointBytes
    }
}

private func prePackPairData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if case let .sequence(value) = value {
        let pair: Micheline = .prim(
            try .init(prim: Michelson.Data.Pair.self, args: value, annots: []).normalized()
        )
        
        return try prePack(pair, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Data.Pair.self) {
        let valueNormalized = try value.normalized()
        let schemaNormalized = try schema.normalized()
        
        guard valueNormalized.args.count == schemaNormalized.args.count else {
            throw valueSchemaMismatchError(value: .prim(value), schema: .prim(schema))
        }
        
        let prePackedArgs = try prePack(valueNormalized.args, usingSchemas: schemaNormalized.args)
        
        return .prim(
            try .init(prim: valueNormalized.prim, args: prePackedArgs, annots: valueNormalized.annots)
        )
    } else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
}

private func prePackOrData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .prim(value) = value, value.args.count == 1 else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    guard schema.args.count == 2 else {
        throw invalidSchemaError(schema: .prim(schema))
    }
    
    let type: Micheline = try {
        if let _ = try? value.asPrim(Michelson.Data.Left.self) {
            return schema.args[0]
        } else if let _ = try? value.asPrim(Michelson.Data.Right.self) {
            return schema.args[1]
        } else {
            throw valueSchemaMismatchError(value: .prim(value), schema: .prim(schema))
        }
    }()
    
    return .prim(
        try .init(prim: value.prim, args: [try prePack(value.args[0], usingSchema: type)], annots: value.annots)
    )
}

private func prePackLambdaData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .sequence(value) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    let prePacked: [Micheline] = try value.map { node in
        switch node {
        case .literal(_):
            throw valueSchemaMismatchError(value: node, schema: .prim(schema))
        case .prim(let primitiveApplication):
            return try prePackInstruction(primitiveApplication, usingSchema: schema)
        case .sequence(_):
            return try prePackLambdaData(node, usingSchema: schema)
        }
    }
    
    return .sequence(prePacked)
}

private func prePackMapData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .sequence(value) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    let prePacked: [Micheline] = try value.map { node in
        guard let elt = try? node.asPrim(Michelson.Data.Elt.self), elt.args.count == schema.args.count else {
            throw valueSchemaMismatchError(value: .sequence(value), schema: .prim(schema))
        }
        
        let prePackedArgs = try prePack(elt.args, usingSchemas: schema.args)
        
        return .prim(
            try .init(prim: elt.prim, args: prePackedArgs, annots: elt.annots)
        )
    }
    
    return .sequence(prePacked)
}

private func prePackBigMapData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard case let .literal(literal) = value, case .integer = literal else {
        return try prePackMapData(value, usingSchema: schema)
    }
    
    return value
}

private func prePackChainIDData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackStringToBytes(value, usingSchema: schema) { try ChainID(base58: $0).encodeToBytes() }
}

private func prePackKeyHashData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackStringToBytes(value, usingSchema: schema) { try Address.Implicit(base58: $0).encodeToBytes() }
}

private func prePackKeyData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackStringToBytes(value, usingSchema: schema) { try Key.Public(base58: $0).encodeToBytes() }
}

private func prePackSignatureData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackStringToBytes(value, usingSchema: schema) { try Signature(base58: $0).encodeToBytes() }
}

private func prePackTimestampData(_ value: Micheline, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackStringToInt(value, usingSchema: schema) {
        Int(Timestamp.rfc3339($0).toMillis())
    }
}

private func prePackInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    if let value = try? value.asPrim(Michelson.Instruction.Map.self, Michelson.Instruction.Iter.self) {
        return try prePackIteratingInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Loop.self, Michelson.Instruction.LoopLeft.self) {
        return try prePackLoopInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Lambda.self) {
        return try prePackLambdaInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Dip.self) {
        return try prePackDipInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.IfNone.self, Michelson.Instruction.IfCons.self, Michelson.Instruction.If.self) {
        return try prePackIfInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.Push.self) {
        return try prePackPushInstruction(value)
    } else if let value = try? value.asPrim(Michelson.Instruction.CreateContract.self) {
        return try prePackCreateContractInstruction(value, usingSchema: schema)
    } else if let value = try? value.asPrim(Michelson.Instruction.allPrims) {
        return .prim(value)
    } else {
        throw valueSchemaMismatchError(value: .prim(value), schema: .prim(schema))
    }
}

private func prePackIteratingInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackInstructionArgument(value, usingSchema: schema, at: 0)
}

private func prePackLoopInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackInstructionArgument(value, usingSchema: schema, at: 0)
}

private func prePackLambdaInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackInstructionArgument(value, usingSchema: schema, at: 2)
}

private func prePackDipInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackInstructionArgument(value, usingSchema: schema, at: value.args.count - 1)
}

private func prePackCreateContractInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    try prePackInstructionArgument(value, usingSchema: schema, at: 2)
}

private func prePackIfInstruction(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication) throws -> Micheline {
    guard value.args.count == 2 else {
        throw invalidValueError(value: .prim(value))
    }
    
    let prePackedArgs = try value.args.map { arg in
        try prePackLambdaData(arg, usingSchema: schema)
    }
    
    return .prim(
        try .init(prim: value.prim, args: prePackedArgs, annots: value.annots)
    )
}

private func prePackPushInstruction(_ value: Micheline.PrimitiveApplication) throws -> Micheline {
    guard value.args.count == 2 else {
        throw invalidValueError(value: .prim(value))
    }

    let schema = value.args[0]
    let data = value.args[1]

    return .prim(
        try .init(prim: value.prim, args: [schema, try prePack(data, usingSchema: schema)], annots: value.annots)
    )
}

private func prePackStringToBytes(
    _ value: Micheline,
    usingSchema schema: Micheline.PrimitiveApplication,
    prePackingWith prePack: (String) throws -> [UInt8]
) throws -> Micheline {
    guard case let .literal(literal) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    switch literal {
    case .integer(_):
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    case .string(let string):
        return .literal(.bytes(.init(try prePack(string.value))))
    case .bytes(let bytes):
        return .literal(.bytes(bytes))
    }
}

private func prePackStringToInt(
    _ value: Micheline,
    usingSchema schema: Micheline.PrimitiveApplication,
    prePackingWith prePack: (String) throws -> Int
) throws -> Micheline {
    guard case let .literal(literal) = value else {
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
    
    switch literal {
    case .integer(let integer):
        return .literal(.integer(integer))
    case .string(let string):
        return .literal(.integer(.init(try prePack(string.value))))
    case .bytes(_):
        throw valueSchemaMismatchError(value: value, schema: .prim(schema))
    }
}

private func prePackInstructionArgument(_ value: Micheline.PrimitiveApplication, usingSchema schema: Micheline.PrimitiveApplication, at index: Int) throws -> Micheline {
    guard index >= 0, index < value.args.count else {
        throw invalidValueError(value: .prim(value))
    }
    
    let prePackedArg = try prePackLambdaData(value.args[index], usingSchema: schema)
    return .prim(
        try .init(prim: value.prim, args: value.args.replacing(prePackedArg, at: index), annots: value.annots)
    )
}

private func prePack(_ values: [Micheline], usingSchemas schemas: [Micheline]) throws -> [Micheline] {
    try zip(values, schemas).map { try prePack($0, usingSchema: $1) }
}

private func prePack(_ values: [Micheline], usingSchema schema: Micheline) throws -> [Micheline] {
    try values.map { try prePack($0, usingSchema: schema) }
}

private func splitAddress(_ address: String) -> (String, String?) {
    let split = address.split(separator: Michelson.ComparableType.Address.entrypointSeparator, maxSplits: 2, omittingEmptySubsequences: false)
    
    let address = String(split[0])
    let entrypoint: String? = {
        if let entrypoint = split[safe: 1] {
            return String(entrypoint)
        } else {
            return nil
        }
    }()
    
    return (address, entrypoint)
}

// MARK: Errors

private func invalidValueError(value: Micheline) -> Swift.Error {
    TezosError.invalidValue("Micheline value \(value) is invalid.")
}

private func invalidSchemaError(schema: Micheline) -> Swift.Error {
    TezosError.invalidValue("Micheline schema \(schema) is invalid.")
}

private func valueSchemaMismatchError(value: Micheline, schema: Micheline) -> Swift.Error {
    TezosError.invalidValue("Micheline value \(value) does not match the schema \(schema)")
}

// MARK: Tag

private enum Tag: BytesTagIterable {
    case node
    
    var value: [UInt8] {
        switch self {
        case .node:
            return [5]
        }
    }
    
    init?(from bytes: [UInt8]) {
        guard let found = Self.recognize(from: bytes) else {
            return nil
        }
        
        self = found
    }
}
