
//
//  Ed25519BlindedPublicKeyHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct Ed25519BlindedPublicKeyHash: BlindedKeyHash.Public.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "btz1"
    public static let base58Bytes: [UInt8] = [1, 2, 49, 223]
    public static let base58Length: Int = 37
    
    public static let bytesLength: Int = 20
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Ed25519BlindedPublicKeyHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asPublicBlindedKeyHash() -> BlindedKeyHash.Public {
        .btz1(self)
    }
}
