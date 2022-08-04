//
//  Ratio.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

// MARK: RPCRatio

public struct RPCRatio: Hashable, Codable {
    public let numerator: UInt16
    public let denominator: UInt16
    
    public init(numerator: UInt16, denominator: UInt16) {
        self.numerator = numerator
        self.denominator = denominator
    }
}
