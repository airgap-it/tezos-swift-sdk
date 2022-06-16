//
//  Encoded.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

// MARK: Encoded

public protocol Encoded: Hashable {
    var base58: String { get }
    
    init(base58: String) throws
    
    static func isValid(string: String) -> Bool
    static func isValid(bytes: [UInt8]) -> Bool
}

// MARK: EncodedValue

public protocol EncodedValue: Encoded {
    static var base58Prefix: String { get }
    static var base58Bytes: [UInt8] { get }
    static var base58Length: Int { get }
    
    static var bytesLength: Int { get }
}

public extension EncodedValue {
    static func isValid(string: String) -> Bool {
        string.hasPrefix(Self.base58Prefix) && string.count == Self.base58Length
    }
    
    static func isValid(bytes: [UInt8]) -> Bool {
        bytes.count == bytesLength || (bytes.starts(with: base58Bytes) && bytes.count >= Self.bytesLength + Self.base58Bytes.count)
    }
}

// MARK: EncodedGroup

public protocol EncodedGroup: Encoded {}
