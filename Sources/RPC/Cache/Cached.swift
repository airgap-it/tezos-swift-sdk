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
    
    public func map<R>(_ transform: @escaping (T) throws -> R) -> Cached<R> {
        let value = value
        let fetch = fetch
        
        return .init {
            let value = try await getValue(valueOrNil: value, fetch: fetch, headers: $0)
            return try transform(value)
        }
    }
    
    public func combine<S>(with other: Cached<S>) -> Cached<(T, S)> {
        let selfValue = value
        let selfFetch = fetch
        
        let otherValue = other.value
        let otherFetch = other.fetch
        
        return .init {
            let first: T = try await getValue(valueOrNil: selfValue, fetch: selfFetch, headers: $0)
            let second: S = try await getValue(valueOrNil: otherValue, fetch: otherFetch, headers: $0)
            
            return (first, second)
        }
    }
}

private func getValue<T>(valueOrNil: T?, fetch: (_ headers: [HTTPHeader]) async throws -> T, headers: [HTTPHeader]) async throws -> T {
    if let value = valueOrNil {
        return value
    } else {
        return try await fetch(headers)
    }
}
