
//
//  SaplingAddress.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct SaplingAddress: EncodedValue {
    public static let base58Prefix: String = "zet1"
    public static let base58Bytes: [UInt8] = [18, 71, 40, 223]
    public static let base58Length: Int = 69
    
    public static let bytesLength: Int = 43
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid SaplingAddress base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
