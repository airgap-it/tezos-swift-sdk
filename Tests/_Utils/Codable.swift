//
//  Codable.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import Foundation

// MARK: Encodable

public extension Encodable {
    
    func toJSONObject() -> Any? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data)
    }
}

// MARK: Decodable

public extension Decodable {
    
    init?(fromJSONObject jsonObject: Any) {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject) else {
            return nil
        }
        
        guard let value = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        
        self = value
    }
}
