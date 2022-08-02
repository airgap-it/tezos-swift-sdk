//
//  BytesCodable.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

// MARK: Decodable

public protocol BytesDecodable {
    init(from bytes: [UInt8]) throws
    init(fromConsuming bytes: inout [UInt8]) throws
}

public extension BytesDecodable {
    init(from bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromConsuming: &bytes)
    }
}

// MARK: Encodable

public protocol BytesEncodable {
    func encodeToBytes() throws -> [UInt8]
}

// MARK: Codable

public typealias BytesCodable = BytesDecodable & BytesEncodable
