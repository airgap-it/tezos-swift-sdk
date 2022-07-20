//
//  TezUtils.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosCore

// MARK: Mutez

extension Mutez {
    static func +(lhs: Mutez, rhs: Mutez) -> Mutez {
        try! .init(lhs.value + rhs.value)
    }
}
