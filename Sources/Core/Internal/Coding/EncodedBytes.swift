//
//  EncodedBytes.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation
import Base58Swift

extension EncodedValue {
    public init(from bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromConsuming: &bytes)
    }
    
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let encoded = Base58.base58CheckEncode(Self.base58Bytes + bytes)
        try self.init(base58: encoded)
    }
    
    public func encodeToBytes(keepingPrefix keepPrefix: Bool = false) throws -> [UInt8] {
        guard let decoded = Base58.base58CheckDecode(base58) else {
            throw TezosError.invalidValue("Invalid base58 encoded value (\(base58).")
        }
        
        let bytesStart = keepPrefix ? 0 : Self.base58Bytes.count
        
        return Array(decoded[bytesStart...])
    }
}
