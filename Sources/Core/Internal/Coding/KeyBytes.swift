//
//  KeyBytes.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

// MARK: PublicKey

extension Key.Public: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Bytes `\(bytes)` are not valid Tezos public key bytes.")
        }
        
        bytes.removeSubrange(0..<tag.value.count)
        
        switch tag {
        case .edpk:
            self = .edpk(try .init(fromConsuming: &bytes))
        case .sppk:
            self = .sppk(try .init(fromConsuming: &bytes))
        case .p2pk:
            self = .p2pk(try .init(fromConsuming: &bytes))
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .edpk(let ed25519PublicKey):
            return Tag.edpk + (try ed25519PublicKey.encodeToBytes())
        case .sppk(let secp256K1PublicKey):
            return Tag.sppk + (try secp256K1PublicKey.encodeToBytes())
        case .p2pk(let p256PublicKey):
            return Tag.p2pk + (try p256PublicKey.encodeToBytes())
        }
    }
    
    private enum Tag: BytesTagIterable {
        case edpk
        case sppk
        case p2pk
        
        var value: [UInt8] {
            switch self {
            case .edpk:
                return [0]
            case .sppk:
                return [1]
            case .p2pk:
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
