
//
//  P256Signature.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct P256Signature: Signature.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "p2sig"
    public static let base58Bytes: [UInt8] = [54, 240, 44, 52]
    public static let base58Length: Int = 98
    
    public static let bytesLength: Int = 64
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid P256Signature base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asSignature() -> Signature {
        .p2sig(self)
    }
}
