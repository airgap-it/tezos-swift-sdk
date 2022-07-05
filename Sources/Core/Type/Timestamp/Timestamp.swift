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
    
    public func toRFC3339() -> String {
        switch self {
        case .rfc3339(let string):
            return string
        case .millis(let int64):
            let date = Date(timeIntervalSince1970: TimeInterval(int64) / 1000.0)
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            
            return formatter.string(from: date)
        }
    }
    
    public func toMillis() -> Int64 {
        switch self {
        case .rfc3339(let string):
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.insert(.withFractionalSeconds)
            
            let date = formatter.date(from: string)!
            
            return Int64((date.timeIntervalSince1970 * 1000.0).rounded())
        case .millis(let int64):
            return int64
        }
    }
}
