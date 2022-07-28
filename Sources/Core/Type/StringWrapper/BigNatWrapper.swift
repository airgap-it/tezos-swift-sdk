//
//  BigNatWrapper.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import BigInt

public protocol BigNatWrapper: StringWrapper {}

// MARK: Defaults

public extension BigNatWrapper {
    static var regex: String {
        #"^[0-9]+$"#
    }
    
    init<I: UnsignedInteger>(_ value: I) {
        try! self.init(String(value))
    }
}

// MARK: Inheritance

extension BigUInt: BigNatWrapper {
    public init<S: StringProtocol>(_ value: S) throws {
        guard let value = BigUInt(value, radix: 10) else {
            throw TezosError.invalidValue("Invalid BigUInt value (\(value).")
        }
        
        self = value
    }
    
    public var value: String { description }
}
