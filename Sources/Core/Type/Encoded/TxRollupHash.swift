//
//  TxRollupHash.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation

public struct TxRollupHash: EncodedValue {
    public static let base58Prefix: String = "txr1"
    public static let base58Bytes: [UInt8] = [1, 128, 120, 31]
    public static let base58Length: Int = 37
    
    public static let bytesLength: Int = 20
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid TxRollupHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
