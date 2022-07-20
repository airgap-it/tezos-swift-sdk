//
//  Mutez.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

public struct Mutez: Hashable, Codable {
    public static var zero: Mutez {
        try! .init(0)
    }
    
    public let value: Int64
    
    public init<I: SignedInteger>(_ value: I) throws {
        guard Self.isValid(value) else {
            throw TezosError.invalidValue("Invalid mutez value (\(value)).")
        }
        
        self.value = .init(value)
    }
    
    public init(_ value: String) throws {
        guard Self.isValid(value), let value = Int64(value) else {
            throw TezosError.invalidValue("Invalid mutez value (\(value)).")
        }
        
        try self.init(value)
    }
    
    public static func isValid<I: SignedInteger>(_ value: I) -> Bool {
        // Mutez (micro-Tez) are internally represented by 64-bit signed integers.
        // These are restricted to prevent creating a negative amount of mutez.
        //
        // (https://tezos.gitlab.io/michelson-reference/#type-mutez)
        
        return value >= 0
    }
    
    public static func isValid(_ value: String) -> Bool {
        value.range(of: #"^[0-9]+$"#, options: .regularExpression) != nil
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let value = try String(from: decoder)
        try self.init(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try String(value).encode(to: encoder)
    }
}
