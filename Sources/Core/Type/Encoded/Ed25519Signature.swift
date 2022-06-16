
//
//  Ed25519Signature.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct Ed25519Signature: EncodedValue {
    public static let base58Prefix: String = "edsig"
    public static let base58Bytes: [UInt8] = [9, 245, 205, 134, 18]
    public static let base58Length: Int = 99
    
    public static let bytesLength: Int = 64
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Ed25519Signature base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
