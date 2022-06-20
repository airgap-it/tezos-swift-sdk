//
//  JSON.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import Foundation

public func normalizeJSON(_ json: String) -> String {
    let data = json.data(using: .utf8)!
    let jsonObject = try! JSONSerialization.jsonObject(with: data)
    let normalizedData = try! JSONSerialization.data(withJSONObject: jsonObject)
    
    return String(data: normalizedData, encoding: .utf8)!
}

public func normalizeJSON(_ data: Data) -> String {
    let jsonObject = try! JSONSerialization.jsonObject(with: data)
    let normalizedData = try! JSONSerialization.data(withJSONObject: jsonObject)
    
    return String(data: normalizedData, encoding: .utf8)!
}
