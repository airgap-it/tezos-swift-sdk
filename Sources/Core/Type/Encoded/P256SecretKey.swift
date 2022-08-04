
//
//  P256SecretKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct P256SecretKey: Key.Secret.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "p2sk"
    public static let base58Bytes: [UInt8] = [16, 81, 238, 189]
    public static let base58Length: Int = 54
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid P256SecretKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asSecretKey() -> Key.Secret {
        .p2sk(self)
    }
}
