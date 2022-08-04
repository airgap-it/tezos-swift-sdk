
//
//  OperationListListHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct OperationListListHash: EncodedValue {
    public static let base58Prefix: String = "LLo"
    public static let base58Bytes: [UInt8] = [29, 159, 109]
    public static let base58Length: Int = 53
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid OperationListListHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
