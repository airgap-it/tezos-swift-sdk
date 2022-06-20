//
//  TezosError.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation

public enum TezosError: Swift.Error {
    case invalidValue(_ description: String? = nil)
    case unexpectedType(expected: String, actual: String)
}
