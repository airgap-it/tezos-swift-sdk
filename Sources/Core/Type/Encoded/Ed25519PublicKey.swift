
//
//  Ed25519PublicKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct Ed25519PublicKey: Key.Public.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "edpk"
    public static let base58Bytes: [UInt8] = [13, 15, 37, 217]
    public static let base58Length: Int = 54
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Ed25519PublicKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asPublicKey() -> Key.Public {
        .edpk(self)
    }
}
