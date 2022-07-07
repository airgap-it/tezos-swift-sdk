
//
//  Secp256K1SecretKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct Secp256K1SecretKey: Key.Secret.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "spsk"
    public static let base58Bytes: [UInt8] = [17, 162, 224, 201]
    public static let base58Length: Int = 54
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Secp256K1SecretKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asSecretKey() -> Key.Secret {
        .spsk(self)
    }
}
