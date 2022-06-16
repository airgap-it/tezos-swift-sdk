//
//  ArrayBytes.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation

public extension Array {
    init(fromConsuming bytes: inout [UInt8], decodingWith decoder: (inout [UInt8]) throws -> Element) rethrows {
        self = try decodeArray(fromConsuming: &bytes, decoded: [], decodingWith: decoder)
    }
    
    func encodeToBytes(encodingWith encoder: (Element) throws -> [UInt8]) rethrows -> [UInt8] {
        try reduce([UInt8]()) { (acc, next) in
            acc + (try encoder(next))
        }
    }
}

private func decodeArray<T>(
    fromConsuming bytes: inout [UInt8],
    decoded: [T],
    decodingWith decoder: (inout [UInt8]) throws -> T
) rethrows -> [T] {
    guard !bytes.isEmpty else {
        return decoded
    }
    
    let element = try decoder(&bytes)
    
    return try decodeArray(fromConsuming: &bytes, decoded: decoded + [element], decodingWith: decoder)
}
