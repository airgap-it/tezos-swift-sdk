//
//  StringFromHexString.swift
//  
//
//  Created by Julia Samol on 02.08.22.
//

public extension String {
    init(_ source: HexString, withPrefix prefixed: Bool = false) {
        self = prefixed ? HexString.prefix + source.value : source.value
    }
}
