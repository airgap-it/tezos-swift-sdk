
//
//  ContractHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

public struct ContractHash: Address.Originated.`Protocol`, EncodedValue {
    public static let base58Prefix: String = "KT1"
    public static let base58Bytes: [UInt8] = [2, 90, 121]
    public static let base58Length: Int = 36
    
    public static let bytesLength: Int = 20
    
    public let base58: String
    
    public init(base58: String) throws {
        guard Self.isValid(string: base58) else {
            throw TezosError.invalidValue("Invalid ContractHash base58 encoded value (\(base58).")
        }
        
        self.base58 = base58
    }
    
    public func asOriginatedAddress() -> Address.Originated {
        .contract(self)
    }
}
