//
//  BigIntWrapper.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation

public protocol BigIntWrapper: StringWrapper {}

// MARK: Defaults

public extension BigIntWrapper {
    static var regex: String {
        #"^-?[0-9]+$"#
    }
    
    init(_ value: Int) {
        try! self.init(String(value))
    }
}
