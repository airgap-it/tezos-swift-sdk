//
//  BytesFromHexString.swift
//  
//
//  Created by Julia Samol on 02.08.22.
//

public extension Array where Element == UInt8 {
    init(from source: HexString) {
        var bytes = [UInt8]()
        bytes.reserveCapacity(source.value.count / 2)
        
        for (position, index) in source.value.indices.enumerated() {
            guard position % 2 == 0 else { continue }
            
            let byteRange = index..<source.value.index(index, offsetBy: 2)
            let byteSlice = source.value[byteRange]
            let byte = UInt8(byteSlice, radix: 16)! // `value` has been already tested for a valid hex string
            bytes.append(byte)
        }
        
        self = bytes
    }
}
