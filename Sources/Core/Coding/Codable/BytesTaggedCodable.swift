//
//  BytesTaggedCodable.swift
//  
//
//  Created by Julia Samol on 02.08.22.
//

// MARK: Decodable

protocol BytesTaggedDecodable: BytesDecodable {
    associatedtype Tag: BytesDecodableTag where Tag.Value == Self
}

protocol BytesDecodableTag: BytesTagIterable {
    associatedtype Value
    
    init?(from bytes: [UInt8])
    func create(fromConsuming bytes: inout [UInt8]) throws -> Value
}

extension BytesTaggedDecodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Invalid encoded `\(bytes)`.")
        }
        
        bytes.removeSubrange(0..<tag.value.count)
        
        self = try tag.create(fromConsuming: &bytes)
    }
}

// MARK: Encodable

protocol BytesTaggedEncodable: BytesEncodable {
    associatedtype Tag: BytesEncodableTag where Tag.Value == Self
    
    func encodeRawToBytes() throws -> [UInt8]
}

protocol BytesEncodableTag: BytesTagIterable {
    associatedtype Value
    
    init(from value: Value)
}

extension BytesTaggedEncodable {
    public func encodeToBytes() throws -> [UInt8] {
        let tag = Tag(from: self)
        return tag + (try encodeRawToBytes())
    }
}

// MARK: Codable

typealias BytesTaggedCodable = BytesTaggedDecodable & BytesTaggedEncodable

typealias BytesCodableTag = BytesDecodableTag & BytesEncodableTag
