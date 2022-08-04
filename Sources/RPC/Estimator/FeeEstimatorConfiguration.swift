//
//  File.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

public struct MinFeeConfiguration {
    public let limits: Limits
    public let headers: [HTTPHeader]
    
    public init(limits: Limits = .init(), headers: [HTTPHeader] = []) {
        self.limits = limits
        self.headers = headers
    }
}
