//
//  IntBytes.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

// MARK: Int8

extension Int8: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: Int8.self, andSize: 1))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: UInt8

extension UInt8: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: UInt8.self, andSize: 1))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: Int16

extension Int16: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: Int16.self, andSize: 2))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: UInt16

extension UInt16: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: UInt16.self, andSize: 2))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: Int32

extension Int32: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: Int32.self, andSize: 4))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: UInt32

extension UInt32: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: UInt32.self, andSize: 4))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: Int64

extension Int64: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: Int64.self, andSize: 8))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: UInt64

extension UInt64: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self.init(bigEndian: try decodeBigEndianFromBytes(&bytes, ofType: UInt64.self, andSize: 8))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        try encodeBigEndianToBytes(bigEndian)
    }
}

// MARK: Utilities

private func decodeBigEndianFromBytes<T: BinaryInteger>(_ bytes: inout [UInt8], ofType type: T.Type, andSize size: Int) throws -> T {
    let bytes = bytes.consumeSubrange(0..<size)
    return bytes.withUnsafeBytes { $0.load(as: type) }
}

private func encodeBigEndianToBytes<T: BinaryInteger>(_ bigEndian: T) throws -> [UInt8] {
    withUnsafeBytes(of: bigEndian, Array.init)
}
