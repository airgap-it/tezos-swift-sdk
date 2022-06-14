//
//  BigNatWrapper.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation

public protocol BigNatWrapper: StringWrapper {}

// MARK: Defaults

public extension BigNatWrapper {
    static var regex: String {
        #"^[0-9]+$"#
    }
    
    init(_ value: UInt) {
        try! self.init(String(value))
    }
}
