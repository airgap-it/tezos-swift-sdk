//
//  StringUtils.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation

public extension String {
    
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        
        return String(dropFirst(prefix.count))
    }
}
