//
//  MichelineFromMichelson.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import Foundation

// MARK: From Michelson

extension Micheline: ConvertibleFromMichelson {
    public init(from michelson: Michelson) throws {
        switch michelson {
        case .data(let data):
            try self.init(from: data)
        case .type(let type):
            try self.init(from: type)
        }
    }
}

// MARK: From MichelsonData

extension Micheline: ConvertibleFromMichelsonData {
    
    public init(from data: Michelson.Data) throws {
        switch data {
        case .int(let content):
            self = .literal(.integer(try .init(content.value)))
        case .nat(let content):
            self = .literal(.integer(try .init(content.value)))
        case .string(let content):
            self = .literal(.string(try .init(content.value)))
        case .bytes(let content):
            self = .literal(.bytes(try .init(content.value)))
        case .unit(let content):
            self = .prim(try .init(from: content))
        case .true(let content):
            self = .prim(try .init(from: content))
        case .false(let content):
            self = .prim(try .init(from: content))
        case .pair(let content):
            self = .prim(try .init(
                from: content,
                args: try content.values.map { try Micheline(from: $0) }
            ))
        case .left(let content):
            self = .prim(try .init(
                from: content,
                args: [Micheline(from: content.value)]
            ))
        case .right(let content):
            self = .prim(try .init(
                from: content,
                args: [Micheline(from: content.value)]
            ))
        case .some(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.value)]
            ))
        case .none(let content):
            self = .prim(try .init(from: content))
        case .sequence(let content):
            self = .sequence(try content.values.map({ try Micheline(from: $0 )}))
        case .map(let content):
            self = .sequence(try content.values.map({ elt in
                .prim(try .init(
                    prim: Michelson.Data.Elt.self,
                    args: [
                        try Micheline(from: elt.key),
                        try Micheline(from: elt.value)
                    ],
                    annots: [String]()
                ))
            }))
        case .instruction(let instruction):
            try self.init(from: instruction)
        }
    }
}

// MARK: From MichelsonInstruction

extension Micheline: ConvertibleFromMichelsonInstruction {
    
    public init(from instruction: Michelson.Instruction) throws {
        switch instruction {
        case .sequence(let content):
            self = .sequence(try content.instructions.map({ try Micheline(from: $0 )}))
        case .drop(let content):
            self = .prim(try .init(
                from: content,
                args: [content.n].compactMap { $0 }.map { try Micheline(from: Michelson.Data.nat($0)) }
            ))
        case .dup(let content):
            self = .prim(try .init(
                from: content,
                args: [content.n].compactMap { $0 }.map { try Micheline(from: Michelson.Data.nat($0)) }
            ))
        case .swap(let content):
            self = .prim(try .init(from: content))
        case .dig(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Data.nat(content.n))]
            ))
        case .dug(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Data.nat(content.n))]
            ))
        case .push(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.type),
                    try Micheline(from: content.value),
                ]
            ))
        case .some(let content):
            self = .prim(try .init(from: content))
        case .none(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .unit(let content):
            self = .prim(try .init(from: content))
        case .never(let content):
            self = .prim(try .init(from: content))
        case .ifNone(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: Michelson.Instruction.sequence(content.ifBranch)),
                    try Micheline(from: Michelson.Instruction.sequence(content.elseBranch)),
                ]
            ))
        case .pair(let content):
            self = .prim(try .init(
                from: content,
                args: [content.n].compactMap { $0 }.map { try Micheline(from: Michelson.Data.nat($0)) }
            ))
        case .car(let content):
            self = .prim(try .init(from: content))
        case .cdr(let content):
            self = .prim(try .init(from: content))
        case .unpair(let content):
            self = .prim(try .init(
                from: content,
                args: [content.n].compactMap { $0 }.map { try Micheline(from: Michelson.Data.nat($0)) }
            ))
        case .left(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .right(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .ifLeft(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: Michelson.Instruction.sequence(content.ifBranch)),
                    try Micheline(from: Michelson.Instruction.sequence(content.elseBranch)),
                ]
            ))
        case .nil(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .cons(let content):
            self = .prim(try .init(from: content))
        case .ifCons(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: Michelson.Instruction.sequence(content.ifBranch)),
                    try Micheline(from: Michelson.Instruction.sequence(content.elseBranch)),
                ]
            ))
        case .size(let content):
            self = .prim(try .init(from: content))
        case .emptySet(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .emptyMap(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.keyType),
                    try Micheline(from: content.valueType)
                ]
            ))
        case .emptyBigMap(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.keyType),
                    try Micheline(from: content.valueType)
                ]
            ))
        case .map(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Instruction.sequence(content.expression))]
            ))
        case .iter(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Instruction.sequence(content.expression))]
            ))
        case .mem(let content):
            self = .prim(try .init(from: content))
        case .get(let content):
            self = .prim(try .init(
                from: content,
                args: [content.n].compactMap { $0 }.map { try Micheline(from: Michelson.Data.nat($0)) }
            ))
        case .update(let content):
            self = .prim(try .init(
                from: content,
                args: [content.n].compactMap { $0 }.map { try Micheline(from: Michelson.Data.nat($0)) }
            ))
        case .getAndUpdate(let content):
            self = .prim(try .init(from: content))
        case .if(let content):
            self = .prim(try .init(from: content))
        case .loop(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Instruction.sequence(content.body))]
            ))
        case .loopLeft(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Instruction.sequence(content.body))]
            ))
        case .lambda(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.parameterType),
                    try Micheline(from: content.returnType),
                    try Micheline(from: Michelson.Instruction.sequence(content.body))
                ]
            ))
        case .exec(let content):
            self = .prim(try .init(from: content))
        case .apply(let content):
            self = .prim(try .init(from: content))
        case .dip(let content):
            self = .prim(try .init(
                from: content,
                args: [content.n].compactMap { $0 }.map { try Micheline(from: Michelson.Data.nat($0)) }
                    + [try Micheline(from: Michelson.Instruction.sequence(content.instruction))]
            ))
        case .failwith(let content):
            self = .prim(try .init(from: content))
        case .cast(let content):
            self = .prim(try .init(from: content))
        case .rename(let content):
            self = .prim(try .init(from: content))
        case .concat(let content):
            self = .prim(try .init(from: content))
        case .slice(let content):
            self = .prim(try .init(from: content))
        case .pack(let content):
            self = .prim(try .init(from: content))
        case .unpack(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .add(let content):
            self = .prim(try .init(from: content))
        case .sub(let content):
            self = .prim(try .init(from: content))
        case .mul(let content):
            self = .prim(try .init(from: content))
        case .ediv(let content):
            self = .prim(try .init(from: content))
        case .abs(let content):
            self = .prim(try .init(from: content))
        case .isnat(let content):
            self = .prim(try .init(from: content))
        case .int(let content):
            self = .prim(try .init(from: content))
        case .neg(let content):
            self = .prim(try .init(from: content))
        case .lsl(let content):
            self = .prim(try .init(from: content))
        case .lsr(let content):
            self = .prim(try .init(from: content))
        case .or(let content):
            self = .prim(try .init(from: content))
        case .and(let content):
            self = .prim(try .init(from: content))
        case .xor(let content):
            self = .prim(try .init(from: content))
        case .not(let content):
            self = .prim(try .init(from: content))
        case .compare(let content):
            self = .prim(try .init(from: content))
        case .eq(let content):
            self = .prim(try .init(from: content))
        case .neq(let content):
            self = .prim(try .init(from: content))
        case .lt(let content):
            self = .prim(try .init(from: content))
        case .gt(let content):
            self = .prim(try .init(from: content))
        case .le(let content):
            self = .prim(try .init(from: content))
        case .ge(let content):
            self = .prim(try .init(from: content))
        case .`self`(let content):
            self = .prim(try .init(from: content))
        case .selfAddress(let content):
            self = .prim(try .init(from: content))
        case .contract(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .transferTokens(let content):
            self = .prim(try .init(from: content))
        case .setDelegate(let content):
            self = .prim(try .init(from: content))
        case .createContract(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.parameterType),
                    try Micheline(from: content.storageType),
                    try Micheline(from: Michelson.Instruction.sequence(content.code))
                ]
            ))
        case .implicitAccount(let content):
            self = .prim(try .init(from: content))
        case .votingPower(let content):
            self = .prim(try .init(from: content))
        case .now(let content):
            self = .prim(try .init(from: content))
        case .level(let content):
            self = .prim(try .init(from: content))
        case .amount(let content):
            self = .prim(try .init(from: content))
        case .balance(let content):
            self = .prim(try .init(from: content))
        case .checkSignature(let content):
            self = .prim(try .init(from: content))
        case .blake2b(let content):
            self = .prim(try .init(from: content))
        case .keccak(let content):
            self = .prim(try .init(from: content))
        case .sha3(let content):
            self = .prim(try .init(from: content))
        case .sha256(let content):
            self = .prim(try .init(from: content))
        case .sha512(let content):
            self = .prim(try .init(from: content))
        case .hashKey(let content):
            self = .prim(try .init(from: content))
        case .source(let content):
            self = .prim(try .init(from: content))
        case .sender(let content):
            self = .prim(try .init(from: content))
        case .address(let content):
            self = .prim(try .init(from: content))
        case .chainID(let content):
            self = .prim(try .init(from: content))
        case .totalVotingPower(let content):
            self = .prim(try .init(from: content))
        case .pairingCheck(let content):
            self = .prim(try .init(from: content))
        case .saplingEmptyState(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Data.nat(content.memoSize))]
            ))
        case .saplingVerifyUpdate(let content):
            self = .prim(try .init(from: content))
        case .ticket(let content):
            self = .prim(try .init(from: content))
        case .readTicket(let content):
            self = .prim(try .init(from: content))
        case .splitTicket(let content):
            self = .prim(try .init(from: content))
        case .joinTickets(let content):
            self = .prim(try .init(from: content))
        case .openChest(let content):
            self = .prim(try .init(from: content))
        }
    }
}

// MARK: From Michelson.Type

extension Micheline: ConvertibleFromMichelsonType {
    
    public init(from type: Michelson.`Type`) throws {
        switch type {
        case .parameter(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .storage(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .code(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.code)]
            ))
        case .option(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .list(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .set(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .operation(let content):
            self = .prim(try .init(from: content))
        case .contract(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .ticket(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .pair(let content):
            self = .prim(try .init(
                from: content,
                args: try content.types.map { try Micheline(from: $0) }
            ))
        case .or(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.lhs),
                    try Micheline(from: content.rhs),
                ]
            ))
        case .lambda(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.parameterType),
                    try Micheline(from: content.returnType),
                ]
            ))
        case .map(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.keyType),
                    try Micheline(from: content.valueType),
                ]
            ))
        case .bigMap(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.keyType),
                    try Micheline(from: content.valueType),
                ]
            ))
        case .bls12_381G1(let content):
            self = .prim(try .init(from: content))
        case .bls12_381G2(let content):
            self = .prim(try .init(from: content))
        case .bls12_381Fr(let content):
            self = .prim(try .init(from: content))
        case .saplingTransaction(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Data.nat(content.memoSize))]
            ))
        case .saplingState(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: Michelson.Data.nat(content.memoSize))]
            ))
        case .chest(let content):
            self = .prim(try .init(from: content))
        case .chestKey(let content):
            self = .prim(try .init(from: content))
        case .comparable(let comparable):
            try self.init(from: comparable)
        }
    }
}

// MARK: From MichelsonComparableType

extension Micheline: ConvertibleFromMichelsonComparableType {
    
    public init(from comparableType: Michelson.ComparableType) throws {
        switch comparableType {
        case .unit(let content):
            self = .prim(try .init(from: content))
        case .never(let content):
            self = .prim(try .init(from: content))
        case .bool(let content):
            self = .prim(try .init(from: content))
        case .int(let content):
            self = .prim(try .init(from: content))
        case .nat(let content):
            self = .prim(try .init(from: content))
        case .string(let content):
            self = .prim(try .init(from: content))
        case .chainID(let content):
            self = .prim(try .init(from: content))
        case .bytes(let content):
            self = .prim(try .init(from: content))
        case .mutez(let content):
            self = .prim(try .init(from: content))
        case .keyHash(let content):
            self = .prim(try .init(from: content))
        case .key(let content):
            self = .prim(try .init(from: content))
        case .signature(let content):
            self = .prim(try .init(from: content))
        case .timestamp(let content):
            self = .prim(try .init(from: content))
        case .address(let content):
            self = .prim(try .init(from: content))
        case .option(let content):
            self = .prim(try .init(
                from: content,
                args: [try Micheline(from: content.type)]
            ))
        case .or(let content):
            self = .prim(try .init(
                from: content,
                args: [
                    try Micheline(from: content.lhs),
                    try Micheline(from: content.rhs),
                ]
            ))
        case .pair(let content):
            self = .prim(try .init(
                from: content,
                args: try content.types.map { try Micheline(from: $0) }
            ))
        }
    }
}

// MARK: Utility Extensions

private extension Micheline.PrimitiveApplication {
    init<T: Michelson.`Protocol` & Michelson.Prim>(from michelson: T, args: [Micheline] = []) throws {
        try self.init(prim: T.name, args: args, annots: michelson.annotations.map({ $0.value }))
    }
    
    init<T: Michelson.Prim>(prim: T.Type, args: [Micheline] = [], annots: [Michelson.Annotation] = []) throws {
        try self.init(prim: prim, args: args, annots: annots.map({ $0.value }))
    }
}
