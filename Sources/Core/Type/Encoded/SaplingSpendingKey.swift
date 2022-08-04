
//
//  SaplingSpendingKey.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct SaplingSpendingKey: EncodedValue {
    public static let base58Prefix: String = "sask"
    public static let base58Bytes: [UInt8] = [11, 237, 20, 92]
    public static let base58Length: Int = 41
    
    public static let bytesLength: Int = 169
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid SaplingSpendingKey base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
