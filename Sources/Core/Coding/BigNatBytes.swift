//
//  BigNatBytes.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import BigInt

public extension BigNatWrapper {
    init(from bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromConsuming: &bytes)
    }
    
    init(fromConsuming bytes: inout [UInt8]) throws {
        guard !bytes.isEmpty else {
            throw TezosError.invalidValue("Invalid encoded big natural number value.")
        }
        
        let nat = decodeBigUInt(fromConsuming: &bytes, decoded: BigUInt.zero)
        
        try self.init(nat.description)
    }
    
    func encodeToBytes() -> [UInt8] {
        let nat = BigUInt(value)!
        guard nat > BigUInt.zero else {
            return [0]
        }
        
        return encodeBigUIntToBytes(nat, acc: [])
    }
}

private func decodeBigUInt(fromConsuming bytes: inout [UInt8], decoded: BigUInt, shiftedBy shift: Int = 0) -> BigUInt {
    guard let byte = bytes.consume(at: 0) else {
        return decoded
    }
    
    let part = BigUInt(byte & 0b0111_1111)
    let hasNext = byte & 0b1000_0000 == 0b1000_0000
    let decoded = decoded + (part << shift)
    
    guard hasNext else {
        return decoded
    }
    
    return decodeBigUInt(fromConsuming: &bytes, decoded: decoded, shiftedBy: shift + 7)
}

private func encodeBigUIntToBytes(_ nat: BigUInt, acc: [UInt8]) -> [UInt8] {
    guard nat != BigUInt.zero else {
        return acc
    }
    
    let byte = nat & 0b0111_1111
    let nextValue = nat >> 7
    
    let sequenceMask = BigUInt(nextValue.isZero ? 0b0000_0000 : 0b1000_0000)
    let encodedByte = UInt8(byte | sequenceMask)
    
    return encodeBigUIntToBytes(nextValue, acc: acc + [encodedByte])
}
