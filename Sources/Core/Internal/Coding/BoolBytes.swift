//
//  BoolBytes.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

extension Bool {
    public init?(fromConsuming bytes: inout [UInt8]) {
        let byte = bytes.consume(at: 0)
        switch byte {
        case 255:
            self = true
        case 0:
            self = false
        default:
            return nil
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        if self {
            return [255]
        } else {
            return [0]
        }
    }
}
