
//
//  Ed25519EncryptedSeed.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct Ed25519EncryptedSeed: EncodedValue {
    public static let base58Prefix: String = "edesk"
    public static let base58Bytes: [UInt8] = [7, 90, 60, 179, 41]
    public static let base58Length: Int = 88
    
    public static let bytesLength: Int = 56
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Ed25519EncryptedSeed base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
