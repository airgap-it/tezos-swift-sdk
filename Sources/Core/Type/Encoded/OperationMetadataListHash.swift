
//
//  OperationMetadataListHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct OperationMetadataListHash: EncodedValue {
    public static let base58Prefix: String = "Lr"
    public static let base58Bytes: [UInt8] = [134, 39]
    public static let base58Length: Int = 52
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid OperationMetadataListHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
