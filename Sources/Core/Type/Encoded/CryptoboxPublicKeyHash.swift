
//
//  CryptoboxPublicKeyHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct CryptoboxPublicKeyHash: EncodedValue {
    public static let base58Prefix: String = "id"
    public static let base58Bytes: [UInt8] = [153, 103]
    public static let base58Length: Int = 30
    
    public static let bytesLength: Int = 16
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid CryptoboxPublicKeyHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
