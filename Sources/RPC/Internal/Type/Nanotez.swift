//
//  Nanotez.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import BigInt

struct Nanotez: Hashable {
    let value: BigUInt
    
    init<I: UnsignedInteger>(_ value: I) {
        self.value = BigUInt(value)
    }
}
