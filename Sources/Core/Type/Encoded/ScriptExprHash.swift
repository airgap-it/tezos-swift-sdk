
//
//  ScriptExprHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct ScriptExprHash: EncodedValue {
    public static let base58Prefix: String = "expr"
    public static let base58Bytes: [UInt8] = [13, 44, 64, 27]
    public static let base58Length: Int = 54
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid ScriptExprHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
