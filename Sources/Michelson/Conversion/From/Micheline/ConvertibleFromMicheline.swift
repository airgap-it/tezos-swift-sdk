//
//  ConvertibleFromMicheline.swift
//  
//
//  Created by Julia Samol on 16.06.22.
//

// MARK: From Micheline

public protocol ConvertibleFromMicheline {
    init(from micheline: Micheline) throws
}

// MARK: From MichelineLiteral

public protocol ConvertibleFromMichelineLiteral {
    init(from micheline: Micheline.Literal) throws
}

// MARK: From MichelinePrimitiveApplication

public protocol ConvertibleFromMichelinePrimitiveApplication {
    init(from micheline: Micheline.PrimitiveApplication) throws
}

// MARK: From MichelineSequence

public protocol ConvertibleFromMichelineSequence {
    init(from micheline: Micheline.Sequence) throws
}
