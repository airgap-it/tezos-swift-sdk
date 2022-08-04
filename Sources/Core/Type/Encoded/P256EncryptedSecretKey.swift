
//
//  P256EncryptedSecretKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//
public struct P256EncryptedSecretKey: EncodedValue {
    public static let base58Prefix: String = "p2esk"
    public static let base58Bytes: [UInt8] = [9, 48, 57, 115, 171]
    public static let base58Length: Int = 88
    
    public static let bytesLength: Int = 56
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid P256EncryptedSecretKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
