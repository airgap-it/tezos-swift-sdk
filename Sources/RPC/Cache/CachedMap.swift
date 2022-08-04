//
//  CachedMap.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

public class CachedMap<K: Hashable, V> {
    private let fetch: (_ key: K, _ headers: [HTTPHeader]) async throws -> V
    private var values: [K: V]
    
    public init(_ fetch: @escaping (_ key: K, _ headers: [HTTPHeader]) async throws -> V) {
        self.fetch = fetch
        self.values = [:]
    }
    
    public func get(forKey key: K, headers: [HTTPHeader] = []) async throws -> V {
        guard let value = values[key] else {
            let value = try await fetch(key, headers)
            values[key] = value
            
            return value
        }
        
        return value
    }
}
