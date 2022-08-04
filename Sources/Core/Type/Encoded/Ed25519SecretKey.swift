
//
//  Ed25519SecretKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct Ed25519SecretKey: Key.Secret.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "edsk"
    public static let base58Bytes: [UInt8] = [43, 246, 78, 7]
    public static let base58Length: Int = 98
    
    public static let bytesLength: Int = 64
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Ed25519SecretKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asSecretKey() -> Key.Secret {
        .edsk(self)
    }
}
