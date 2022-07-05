//
//  Mutez.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation

public struct Mutez: Hashable {
    public let value: Int64
    
    public init(_ value: Int64) throws {
        guard Self.isValid(value) else {
            throw TezosError.invalidValue("Invalid mutez value (\(value)).")
        }
        
        self.value = value
    }
    
    public init(_ value: String) throws {
        guard Self.isValid(value), let value = Int64(value) else {
            throw TezosError.invalidValue("Invalid mutez value (\(value)).")
        }
        
        try self.init(value)
    }
    
    public static func isValid(_ value: Int64) -> Bool {
        // Mutez (micro-Tez) are internally represented by 64-bit signed integers.
        // These are restricted to prevent creating a negative amount of mutez.
        //
        // (https://tezos.gitlab.io/michelson-reference/#type-mutez)
        
        return value >= 0
    }
    
    public static func isValid(_ value: String) -> Bool {
        value.range(of: #"^[0-9]+$"#, options: .regularExpression) != nil
    }
}
