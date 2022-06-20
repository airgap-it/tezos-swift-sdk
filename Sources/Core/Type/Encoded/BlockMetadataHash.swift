
//
//  BlockMetadataHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct BlockMetadataHash: EncodedValue {
    public static let base58Prefix: String = "bm"
    public static let base58Bytes: [UInt8] = [234, 249]
    public static let base58Length: Int = 52
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid BlockMetadataHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
