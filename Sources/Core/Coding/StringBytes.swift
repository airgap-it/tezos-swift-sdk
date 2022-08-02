//
//  StringBytes.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

public extension String {
    init(fromConsuming bytes: inout [UInt8], count: Int? = nil) throws {
        let count = count ?? bytes.count
        guard let string = String(bytes: bytes.consumeSubrange(0..<count), encoding: .utf8) else {
            throw TezosError.invalidValue("Invalid encoded String value.")
        }
        
        self = string
    }
    
    func encodeToBytes() throws -> [UInt8] {
        [UInt8](utf8)
    }
}
