//
//  TezUtils.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosCore
import BigInt

// MARK: Mutez

extension Mutez {
    init(from nanotez: Nanotez) {
        let (quotient, remainder) = nanotez.value.quotientAndRemainder(dividingBy: .init(1_000))
        let mutezValue = remainder.isZero ? quotient : quotient + BigUInt(1)
        
        try! self.init(.init(mutezValue))
    }
    
    static func +(lhs: Mutez, rhs: Mutez) -> Mutez {
        try! .init(lhs.value + rhs.value)
    }
}

// MARK: Nanotez

extension Nanotez {
    static func *(lhs: Nanotez, rhs: BigUInt) -> Nanotez {
        .init(lhs.value * rhs)
    }
    
    static func *(lhs: Nanotez, rhs: Int) -> Nanotez {
        .init(lhs.value * BigUInt(rhs))
    }
}
