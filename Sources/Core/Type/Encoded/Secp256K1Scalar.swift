
//
//  Secp256K1Scalar.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct Secp256K1Scalar: EncodedValue {
    public static let base58Prefix: String = "SSp"
    public static let base58Bytes: [UInt8] = [38, 248, 136]
    public static let base58Length: Int = 53
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Secp256K1Scalar base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
