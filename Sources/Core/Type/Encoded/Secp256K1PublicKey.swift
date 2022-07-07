
//
//  Secp256K1PublicKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct Secp256K1PublicKey: Key.Public.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "sppk"
    public static let base58Bytes: [UInt8] = [3, 254, 226, 86]
    public static let base58Length: Int = 55
    
    public static let bytesLength: Int = 33
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Secp256K1PublicKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asPublicKey() -> Key.Public {
        .sppk(self)
    }
}
