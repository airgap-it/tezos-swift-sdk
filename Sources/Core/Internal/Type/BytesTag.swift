//
//  BytesTag.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation

public protocol BytesTag: CaseIterable {
    var value: [UInt8] { get }
}

public extension BytesTag {
    static func +(lhs: Self, rhs: [UInt8]) -> [UInt8] {
        lhs.value + rhs
    }
    
    static func recognize(from bytes: [UInt8]) -> Self? {
        guard !bytes.isEmpty else {
            return nil
        }
        
        guard let found = Self.allCases.first(where: { bytes.starts(with: $0.value) }) else {
            return nil
        }
        
        return found
    }
    
    static func recognize(fromConsuming bytes: inout [UInt8]) -> Self? {
        guard let found = Self.recognize(from: bytes) else {
            return nil
        }
        
        bytes.removeSubrange(0..<found.value.count)
        
        return found
    }
}
