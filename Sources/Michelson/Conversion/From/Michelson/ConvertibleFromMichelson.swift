//
//  ConvertibleFromMichelson.swift
//  
//
//  Created by Julia Samol on 16.06.22.
//

// MARK: From Michelson

public protocol ConvertibleFromMichelson {
    init(from michelson: Michelson) throws
}

// MARK: From MichelsonData

public protocol ConvertibleFromMichelsonData {
    init(from michelson: Michelson.Data) throws
}

// MARK: From MichelsonInstruction

public protocol ConvertibleFromMichelsonInstruction {
    init(from michelson: Michelson.Instruction) throws
}

// MARK: From MichelsonType

public protocol ConvertibleFromMichelsonType {
    init(from michelson: Michelson.`Type`) throws
}

// MARK: From MichelsonComparableType

public protocol ConvertibleFromMichelsonComparableType {
    init(from michelson: Michelson.ComparableType) throws
}

