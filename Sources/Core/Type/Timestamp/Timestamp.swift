//
//  Timestamp.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation

public enum Timestamp: Hashable {
    // TODO: validation
    case rfc3339(String)
    case millis(Int64)
}
