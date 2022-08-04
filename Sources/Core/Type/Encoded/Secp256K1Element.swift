
//
//  Secp256K1Element.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct Secp256K1Element: EncodedValue {
    public static let base58Prefix: String = "GSp"
    public static let base58Bytes: [UInt8] = [5, 92, 0]
    public static let base58Length: Int = 54
    
    public static let bytesLength: Int = 33
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid Secp256K1Element base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
