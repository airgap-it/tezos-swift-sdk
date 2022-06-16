//
//  AddressBytes.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

// MARK: Address

extension Address: BytesCodable {   
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Bytes `\(bytes)` are not valid Tezos address bytes.")
        }
        
        bytes.removeSubrange(0..<tag.value.count)
        
        switch tag {
        case .implicit:
            self = .implicit(try .init(fromConsuming: &bytes))
        case .originated:
            self = .originated(try .init(fromConsuming: &bytes))
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .implicit(let implicit):
            return Tag.implicit + (try implicit.encodeToBytes())
        case .originated(let originated):
            return Tag.originated + (try originated.encodeToBytes())
        }
    }
    
    private enum Tag: BytesTag {
        case implicit
        case originated
        
        var value: [UInt8] {
            switch self {
            case .implicit:
                return [0]
            case .originated:
                return [1]
            }
        }
        
        init?(from bytes: [UInt8]) {
            guard let found = Self.recognize(from: bytes) else {
                return nil
            }
            
            self = found
        }
        
        init?(fromConsuming bytes: inout [UInt8]) {
            guard let found = Self.recognize(fromConsuming: &bytes) else {
                return nil
            }
            
            self = found
        }
    }
}

// MARK: ImplicitAddress

extension Address.Implicit: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Bytes `\(bytes)` are not valid Tezos implicit address bytes.")
        }
        
        bytes.removeSubrange(0..<tag.value.count)
        
        switch tag {
        case .tz1:
            self = .tz1(try .init(fromConsuming: &bytes))
        case .tz2:
            self = .tz2(try .init(fromConsuming: &bytes))
        case .tz3:
            self = .tz3(try .init(fromConsuming: &bytes))
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .tz1(let ed25519PublicKeyHash):
            return Tag.tz1 + (try ed25519PublicKeyHash.encodeToBytes())
        case .tz2(let secp256K1PublicKeyHash):
            return Tag.tz2 + (try secp256K1PublicKeyHash.encodeToBytes())
        case .tz3(let p256PublicKeyHash):
            return Tag.tz3 + (try p256PublicKeyHash.encodeToBytes())
        }
    }
    
    private enum Tag: BytesTag {
        case tz1
        case tz2
        case tz3
        
        var value: [UInt8] {
            switch self {
            case .tz1:
                return [0]
            case .tz2:
                return [1]
            case .tz3:
                return [2]
            }
        }
        
        init?(from bytes: [UInt8]) {
            guard let found = Self.recognize(from: bytes) else {
                return nil
            }
            
            self = found
        }
        
        init?(fromConsuming bytes: inout [UInt8]) {
            guard let found = Self.recognize(fromConsuming: &bytes) else {
                return nil
            }
            
            self = found
        }
    }
}

// MARK: OriginatedAddress

extension Address.Originated: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self = .contract(try .init(fromConsuming: &bytes))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .contract(let contractHash):
            return try contractHash.encodeToBytes()
        }
    }
}
