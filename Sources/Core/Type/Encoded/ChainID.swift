
//
//  ChainID.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

public struct ChainID: EncodedValue {
    public static let base58Prefix: String = "Net"
    public static let base58Bytes: [UInt8] = [87, 82, 0]
    public static let base58Length: Int = 15
    
    public static let bytesLength: Int = 4
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid ChainID base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
