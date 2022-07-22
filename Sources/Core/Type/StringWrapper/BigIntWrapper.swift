//
//  BigIntWrapper.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation
import BigInt

public protocol BigIntWrapper: StringWrapper {}

// MARK: Defaults

public extension BigIntWrapper {
    static var regex: String {
        #"^-?[0-9]+$"#
    }
    
    init<I: SignedInteger>(_ value: I) {
        try! self.init(String(value))
    }
    
    init<I: UnsignedInteger>(_ value: I) {
        try! self.init(String(value))
    }
}

// MARK: Inheritance

extension BigInt: BigIntWrapper {
    public init<S: StringProtocol>(_ value: S) throws {
        guard let value = BigInt(value, radix: 10) else {
            throw TezosError.invalidValue("Invalid BigInt value (\(value).")
        }
        
        self = value
    }
    
    public var value: String { description }
}
