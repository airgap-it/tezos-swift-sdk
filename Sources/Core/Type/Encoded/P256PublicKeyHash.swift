
//
//  P256PublicKeyHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct P256PublicKeyHash: Address.Implicit.`Protocol`, KeyHash.Public.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "tz3"
    public static let base58Bytes: [UInt8] = [6, 161, 164]
    public static let base58Length: Int = 36
    
    public static let bytesLength: Int = 20
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid P256PublicKeyHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asImplicitAddress() -> Address.Implicit {
        .tz3(self)
    }
    
    public func asPublicKeyHash() -> KeyHash.Public {
        .tz3(self)
    }
}
