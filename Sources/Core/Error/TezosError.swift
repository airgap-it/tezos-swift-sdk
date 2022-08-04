//
//  TezosError.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

public enum TezosError: Error {
    case invalidValue(_ description: String? = nil)
    case unexpectedType(expected: String, actual: String)
}
