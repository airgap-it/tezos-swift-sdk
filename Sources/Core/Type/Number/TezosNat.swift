//
//  TezosNat.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation

public struct TezosNat: Hashable, BigNatWrapper {
    public static var zero: TezosNat {
        self.init(UInt(0))
    }
    
    public var value: String
    
    public init<S>(_ value: S) throws where S : StringProtocol {
        guard Self.isValid(value: value) else {
            throw TezosError.invalidValue("Invalid Tezos natural number value.")
        }
        
        self.value = String(value)
    }
}
