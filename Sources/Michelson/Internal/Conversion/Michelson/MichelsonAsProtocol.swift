//
//  MichelsonAsProtocol.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import Foundation

// MARK: Michelson

extension Michelson {
    func asProtocol() -> `Protocol` {
        switch self {
        case .data(let data):
            return data.asProtocol()
        case .type(let type):
            return type.asProtocol()
        }
    }
}

// MARK: Data

extension Michelson.Data {
    func asProtocol() -> `Protocol` {
        switch self {
        case .int(let content):
            return content
        case .nat(let content):
            return content
        case .string(let content):
            return content
        case .bytes(let content):
            return content
        case .unit(let content):
            return content
        case .true(let content):
            return content
        case .false(let content):
            return content
        case .pair(let content):
            return content
        case .left(let content):
            return content
        case .right(let content):
            return content
        case .some(let content):
            return content
        case .none(let content):
            return content
        case .sequence(let content):
            return content
        case .map(let content):
            return content
        case .instruction(let instruction):
            return instruction.asProtocol()
        }
    }
}

// MARK: Instruction

extension Michelson.Instruction {
    func asProtocol() -> `Protocol` {
        switch self {
        case .sequence(let content):
            return content
        case .drop(let content):
            return content
        case .dup(let content):
            return content
        case .swap(let content):
            return content
        case .dig(let content):
            return content
        case .dug(let content):
            return content
        case .push(let content):
            return content
        case .some(let content):
            return content
        case .none(let content):
            return content
        case .unit(let content):
            return content
        case .never(let content):
            return content
        case .ifNone(let content):
            return content
        case .pair(let content):
            return content
        case .car(let content):
            return content
        case .cdr(let content):
            return content
        case .unpair(let content):
            return content
        case .left(let content):
            return content
        case .right(let content):
            return content
        case .ifLeft(let content):
            return content
        case .nil(let content):
            return content
        case .cons(let content):
            return content
        case .ifCons(let content):
            return content
        case .size(let content):
            return content
        case .emptySet(let content):
            return content
        case .emptyMap(let content):
            return content
        case .emptyBigMap(let content):
            return content
        case .map(let content):
            return content
        case .iter(let content):
            return content
        case .mem(let content):
            return content
        case .get(let content):
            return content
        case .update(let content):
            return content
        case .getAndUpdate(let content):
            return content
        case .if(let content):
            return content
        case .loop(let content):
            return content
        case .loopLeft(let content):
            return content
        case .lambda(let content):
            return content
        case .exec(let content):
            return content
        case .apply(let content):
            return content
        case .dip(let content):
            return content
        case .failwith(let content):
            return content
        case .cast(let content):
            return content
        case .rename(let content):
            return content
        case .concat(let content):
            return content
        case .slice(let content):
            return content
        case .pack(let content):
            return content
        case .unpack(let content):
            return content
        case .add(let content):
            return content
        case .sub(let content):
            return content
        case .mul(let content):
            return content
        case .ediv(let content):
            return content
        case .abs(let content):
            return content
        case .isnat(let content):
            return content
        case .int(let content):
            return content
        case .neg(let content):
            return content
        case .lsl(let content):
            return content
        case .lsr(let content):
            return content
        case .or(let content):
            return content
        case .and(let content):
            return content
        case .xor(let content):
            return content
        case .not(let content):
            return content
        case .compare(let content):
            return content
        case .eq(let content):
            return content
        case .neq(let content):
            return content
        case .lt(let content):
            return content
        case .gt(let content):
            return content
        case .le(let content):
            return content
        case .ge(let content):
            return content
        case .`self`(let content):
            return content
        case .selfAddress(let content):
            return content
        case .contract(let content):
            return content
        case .transferTokens(let content):
            return content
        case .setDelegate(let content):
            return content
        case .createContract(let content):
            return content
        case .implicitAccount(let content):
            return content
        case .votingPower(let content):
            return content
        case .now(let content):
            return content
        case .level(let content):
            return content
        case .amount(let content):
            return content
        case .balance(let content):
            return content
        case .checkSignature(let content):
            return content
        case .blake2b(let content):
            return content
        case .keccak(let content):
            return content
        case .sha3(let content):
            return content
        case .sha256(let content):
            return content
        case .sha512(let content):
            return content
        case .hashKey(let content):
            return content
        case .source(let content):
            return content
        case .sender(let content):
            return content
        case .address(let content):
            return content
        case .chainID(let content):
            return content
        case .totalVotingPower(let content):
            return content
        case .pairingCheck(let content):
            return content
        case .saplingEmptyState(let content):
            return content
        case .saplingVerifyUpdate(let content):
            return content
        case .ticket(let content):
            return content
        case .readTicket(let content):
            return content
        case .splitTicket(let content):
            return content
        case .joinTickets(let content):
            return content
        case .openChest(let content):
            return content
        }
    }
}

// MARK: Type

extension Michelson.`Type` {
    func asProtocol() -> `Protocol` {
        switch self {
        case .parameter(let content):
            return content
        case .storage(let content):
            return content
        case .code(let content):
            return content
        case .option(let content):
            return content
        case .list(let content):
            return content
        case .set(let content):
            return content
        case .operation(let content):
            return content
        case .contract(let content):
            return content
        case .ticket(let content):
            return content
        case .pair(let content):
            return content
        case .or(let content):
            return content
        case .lambda(let content):
            return content
        case .map(let content):
            return content
        case .bigMap(let content):
            return content
        case .bls12_381G1(let content):
            return content
        case .bls12_381G2(let content):
            return content
        case .bls12_381Fr(let content):
            return content
        case .saplingTransaction(let content):
            return content
        case .saplingState(let content):
            return content
        case .chest(let content):
            return content
        case .chestKey(let content):
            return content
        case .comparable(let comparableType):
            return comparableType.asProtocol()
        }
    }
}

// MARK: ComparableType

extension Michelson.ComparableType {
    func asProtocol() -> `Protocol` {
        switch self {
        case .unit(let content):
            return content
        case .never(let content):
            return content
        case .bool(let content):
            return content
        case .int(let content):
            return content
        case .nat(let content):
            return content
        case .string(let content):
            return content
        case .chainID(let content):
            return content
        case .bytes(let content):
            return content
        case .mutez(let content):
            return content
        case .keyHash(let content):
            return content
        case .key(let content):
            return content
        case .signature(let content):
            return content
        case .timestamp(let content):
            return content
        case .address(let content):
            return content
        case .option(let content):
            return content
        case .or(let content):
            return content
        case .pair(let content):
            return content
        }
    }
}
