//
//  BigIntBytes.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation
import BigInt

public extension BigIntWrapper {
    init(from bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromConsuming: &bytes)
    }
    
    init(fromConsuming bytes: inout [UInt8]) throws {
        guard let byte = bytes.consume(at: 0) else {
            throw TezosError.invalidValue("Invalid encoded big integer value.")
        }
        
        let part = BigUInt(byte & 0b0011_1111)
        let sign = byte & 0b0100_0000 == 0b0100_0000 ? -1 : 1
        let hasNext = byte & 0b1000_0000 == 0b1000_0000
        
        let abs = hasNext ? part + (try BigUInt(fromConsuming: &bytes) << 6) : part
        let int = BigInt(abs) * BigInt(sign)
        
        try self.init(int.description)
    }
    
    func encodeToBytes() -> [UInt8] {
        let int = BigInt(value)!
        let abs = int.magnitude
        
        let byte = abs & 0b0011_1111
        let nextValue = abs >> 6
        
        let sequenceMask = BigUInt(nextValue.isZero ? 0b0000_0000 : 0b1000_0000)
        let signMask = BigUInt(int.sign == .minus ? 0b0100_0000 : 0b0000_0000)
        let encodedeByte = UInt8(byte | sequenceMask | signMask)
        
        let nextValueEncoded = nextValue > BigUInt.zero ? nextValue.encodeToBytes() : []
        
        return [encodedeByte] + nextValueEncoded
    }
}
