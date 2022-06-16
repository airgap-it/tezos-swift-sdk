
//
//  GenericSignature.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct GenericSignature: EncodedValue {
    public static let base58Prefix: String = "sig"
    public static let base58Bytes: [UInt8] = [4, 130, 43]
    public static let base58Length: Int = 96
    
    public static let bytesLength: Int = 64
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid GenericSignature base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
