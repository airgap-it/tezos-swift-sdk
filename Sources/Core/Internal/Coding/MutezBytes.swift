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
        let bigInt = try BigInt(fromConsuming: &bytes)
        try self.init(Int64(bigInt))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        let bigInt = BigInt(value)
        return bigInt.encodeToBytes()
    }
}
