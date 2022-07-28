
//
//  OperationListHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct OperationListHash: EncodedValue {
    public static let base58Prefix: String = "Lo"
    public static let base58Bytes: [UInt8] = [133, 233]
    public static let base58Length: Int = 52
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid OperationListHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
