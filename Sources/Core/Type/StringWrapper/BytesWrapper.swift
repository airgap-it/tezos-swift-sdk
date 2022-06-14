//
//  BytesWrapper.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation

public protocol BytesWrapper: StringWrapper {}

// MARK: Defaults

public extension BytesWrapper {
    static var regex: String {
        HexString.regex()
    }
}

// MARK: Array <- BytesWrapper

public extension Array where Element == UInt8 {
    init(from bytesWrapper: BytesWrapper) {
        let hexString = try! HexString(from: bytesWrapper.value) // `bytesWrapper.value` has been already tested for valid hex string.
        self = [UInt8](from: hexString)
    }
}
