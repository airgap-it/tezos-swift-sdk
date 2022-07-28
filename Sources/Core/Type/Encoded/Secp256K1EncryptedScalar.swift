
//
//  Secp256K1EncryptedScalar.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct Secp256K1EncryptedScalar: EncodedValue {
    public static let base58Prefix: String = "seesk"
    public static let base58Bytes: [UInt8] = [1, 131, 36, 86, 248]
    public static let base58Length: Int = 93
    
    public static let bytesLength: Int = 60
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Secp256K1EncryptedScalar base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
