//
//  Array.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation

public extension Array {
    
    func firstOf<T>(type: T.Type) -> T? {
        nthOf(type: type, n: 1)
    }
    
    func secondOf<T>(type: T.Type) -> T? {
        nthOf(type: type, n: 2)
    }
    
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

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
