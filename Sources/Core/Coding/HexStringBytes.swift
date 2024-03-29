//
//  HexStringBytes.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

public extension HexString {
    init(fromConsuming bytes: inout [UInt8], count: Int? = nil) throws {
        let count = count ?? bytes.count
        self.init(from: bytes.consumeSubrange(0..<count))
    }
    
    func encodeToBytes() throws -> [UInt8] {
        [UInt8](from: self)
    }
}
