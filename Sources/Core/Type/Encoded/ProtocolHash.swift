
//
//  ProtocolHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct ProtocolHash: EncodedValue {
    public static let base58Prefix: String = "P"
    public static let base58Bytes: [UInt8] = [2, 170]
    public static let base58Length: Int = 51
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid ProtocolHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
