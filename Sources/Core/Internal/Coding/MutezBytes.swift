//
//  MutezBytes.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation
import BigInt

extension Mutez: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let bigUInt = try BigUInt(fromConsuming: &bytes)
        try self.init(Int64(bigUInt))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        let bigUInt = BigUInt(value)
        return bigUInt.encodeToBytes()
    }
}
