
//
//  Secp256K1Signature.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct Secp256K1Signature: Signature.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "spsig1"
    public static let base58Bytes: [UInt8] = [13, 115, 101, 19, 63]
    public static let base58Length: Int = 99
    
    public static let bytesLength: Int = 64
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Secp256K1Signature base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asSignature() -> Signature {
        .spsig(self)
    }
}
