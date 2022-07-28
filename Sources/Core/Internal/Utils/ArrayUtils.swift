//
//  ArrayUtils.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

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
    
    func grouping<K: Hashable>(by selector: (Element) throws -> K) rethrows -> [K: [Element]] {
        var groups = [K: [Element]]()
        for element in self {
            let key = try selector(element)
            let others = groups[key] ?? []
            
            groups[key] = others + [element]
        }
        
        return groups
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
    
    mutating func consume(where predicate: (Element) -> Bool) -> Element? {
        guard let offsetAndElement = enumerated().first(where: { predicate($0.element) }) else {
            return nil
        }
        
        let (offset, element) = offsetAndElement
        remove(at: offset)
        
        return element
    }
    
    mutating func consumeAll(where predicate: (Element) -> Bool) -> [Element] {
        let filtered = enumerated().filter { predicate($0.element) }
        let offsets = Set(filtered.map({ $0.offset }))
        
        self = enumerated()
            .filter { !offsets.contains($0.offset) }
            .map { $0.element }
        
        return filtered.map { $0.element }
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
