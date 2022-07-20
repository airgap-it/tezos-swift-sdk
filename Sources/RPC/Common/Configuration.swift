//
//  Configuration.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation

// MARK: BaseConfiguration

public protocol BaseConfiguration {
    var headers: [HTTPHeader] { get }
}

// MARK: HeadersOnlyConfiguration

public struct HeadersOnlyConfiguration: BaseConfiguration {
    public let headers: [HTTPHeader]
    
    public init(headers: [HTTPHeader] = []) {
        self.headers = headers
    }
}
