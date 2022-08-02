//
//  BoolBytes.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

extension Bool: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let byte = bytes.consume(at: 0)
        switch byte {
        case 255:
            self = true
        case 0:
            self = false
        default:
            throw TezosError.invalidValue("Invalid encoded Bool.")
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
