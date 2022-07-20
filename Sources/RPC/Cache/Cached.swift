//
//  Cached.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

public class Cached<T> {
    private let fetch: (_ headers: [HTTPHeader]) async throws -> T
    private var value: T?
    
    public init(_ fetch: @escaping (_ headers: [HTTPHeader]) async throws -> T) {
        self.fetch = fetch
        self.value = nil
    }
    
    public func get(headers: [HTTPHeader] = []) async throws -> T {
        guard let value = value else {
            let value = try await fetch(headers)
            self.value = value
            
            return value
        }
        
        return value
    }
    
    public func map<R>(_ transform: @escaping (T) throws -> R) rethrows -> Cached<R> {
        let value = value
        let fetch = fetch
        
        return .init {
            if let value = value {
                return try transform(value)
            } else {
                let value = try await fetch($0)
                return try transform(value)
            }
        }
    }
}
