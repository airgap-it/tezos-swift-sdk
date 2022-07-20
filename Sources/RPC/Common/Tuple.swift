//
//  Tuple.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation

public struct Tuple<T: Hashable & Codable, S: Hashable & Codable>: Hashable, Codable {
    public let first: T
    public let second: S
    
    public init(_ first: T, _ second: S) {
        self.first = first
        self.second = second
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let first = try container.decode(T.self)
        let second = try container.decode(S.self)
        
        self.init(first, second)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(first)
        try container.encode(second)
    }
}
