//
//  ArrayUtils.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation

// MARK: Non-mutating

public extension Array {
    
    func firstOf<T>(type: T.Type) -> T? {
        nthOf(type: type, n: 1)
    }
    
    func secondOf<T>(type: T.Type) -> T? {
        nthOf(type: type, n: 2)
    }
    
    func replacing(_ element: Element, at index: Index) -> Self {
        Array(self[0..<index] + [element] + self[(index + 1)...])
    }
}

// MARK: Mutating

public extension Array {
    mutating func consume(at index: Index) -> Element? {
        guard let element = self[safe: index] else {
            return nil
        }
        remove(at: index)
        
        return element
    }
    
    mutating func consumeSubrange(_ bounds: Range<Index>) -> Self {
        let safeBounds = bounds.upperBound <= self.indices.upperBound ? bounds : bounds.lowerBound..<self.count
        let subarray = self[safeBounds]
        removeSubrange(safeBounds)
        
        return Array(subarray)
    }
}

// MARK: Subscript

public extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: Element == UInt8 [Non-mutating]

public extension Array where Element == UInt8 {
    func padEnd(targetSize: Int, fillWith fillValue: UInt8 = 0) -> [Element] {
        guard count < targetSize else {
            return self
        }
        
        return self + [UInt8](repeating: fillValue, count: targetSize - count)
    }
}

// MARK: Private

private extension Array {
    func nthOf<T>(type: T.Type, n: Int) -> T? {
        var counter = 0
        for element in self {
            guard let t = element as? T else {
                continue
            }
            
            counter += 1
            guard counter == n else {
                continue
            }
            
            return t
        }
        
        return nil
    }
}
