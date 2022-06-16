//
//  MichelsonAsCase.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation
import TezosCore

// MARK: Michelson

extension Michelson {
    
    func asData() throws -> Michelson.Data {
        guard case let .data(data) = self else {
            throw TezosError.invalidValue("Michelson value is not a data value.")
        }
        
        return data
    }
    
    func asInstruction() throws -> Michelson.Instruction {
        let data = try asData()
        guard case let .instruction(instruction) = data else {
            throw TezosError.invalidValue("Michelson value is not an instruction value.")
        }
            
        return instruction
    }
    
    func asType() throws -> Michelson.`Type` {
        guard case let .type(type) = self else {
            throw TezosError.invalidValue("Michelson value is not a type value.")
        }
        
        return type
    }
    
    func asComparableType() throws -> Michelson.ComparableType {
        let type = try asType()
        guard case let .comparable(comparableType) = type else {
            throw TezosError.invalidValue("Michelson value is not a comparable type value.")
        }
            
        return comparableType
    }
}

// MARK: [Michelson]

extension Array where Element == Michelson {
    func asDataSequence() throws -> [Michelson.Data] {
        try map { try $0.asData() }
    }
    
    func asInstructionSequence() throws -> [Michelson.Instruction] {
        try map { try $0.asInstruction() }
    }
    
    func asTypeSequence() throws -> [Michelson.`Type`] {
        try map { try $0.asType() }
    }
    
    func asComparableTypeSequence() throws -> [Michelson.ComparableType] {
        try map { try $0.asComparableType() }
    }
}
