//
//  IntBytes.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation

// MARK: Int8

extension Int8: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let bytes = bytes.consumeSubrange(0..<1)
        self.init(bytes.withUnsafeBytes { $0.load(as: Int8.self) })
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        withUnsafeBytes(of: bigEndian, Array.init)
    }
}

// MARK: Int16

extension Int16: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let bytes = bytes.consumeSubrange(0..<2)
        self.init(bytes.withUnsafeBytes { $0.load(as: Int16.self) })
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        withUnsafeBytes(of: bigEndian, Array.init)
    }
}

// MARK: Int32

extension Int32: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let bytes = bytes.consumeSubrange(0..<4)
        self.init(bigEndian: bytes.withUnsafeBytes { $0.load(as: Int32.self) })
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        withUnsafeBytes(of: bigEndian, Array.init)
    }
}

// MARK: Int64

extension Int64: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let bytes = bytes.consumeSubrange(0..<8)
        self.init(bigEndian: bytes.withUnsafeBytes { $0.load(as: Int64.self) })
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        withUnsafeBytes(of: bigEndian, Array.init)
    }
}
