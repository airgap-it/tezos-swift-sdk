//
//  HTTPType.swift
//  
//
//  Created by Julia Samol on 12.07.22.
//

import Foundation

public struct EmptyResponse: Decodable {}

public typealias HTTPHeader = (String, String?)
public typealias HTTPParameter = (String, String?)
