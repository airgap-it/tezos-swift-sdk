
//
//  P256PublicKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct P256PublicKey: Key.Public.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "p2pk"
    public static let base58Bytes: [UInt8] = [3, 178, 139, 127]
    public static let base58Length: Int = 55
    
    public static let bytesLength: Int = 33
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid P256PublicKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asPublicKey() -> Key.Public {
        .p2pk(self)
    }
}
