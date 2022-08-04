//
//  RandomHash.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

public struct RandomHash: EncodedValue {
    public static let base58Prefix: String = "rng"
    public static let base58Bytes: [UInt8] = [76, 64, 204]
    public static let base58Length: Int = 53
    
    public static let bytesLength: Int = 32
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid RandomHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
}
