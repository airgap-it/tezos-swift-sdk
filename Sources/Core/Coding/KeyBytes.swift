//
//  KeyBytes.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

// MARK: PublicKey

extension Key.Public: BytesTaggedCodable {
    func encodeRawToBytes() throws -> [UInt8] {
        switch self {
        case .edpk(let ed25519PublicKey):
            return try ed25519PublicKey.encodeToBytes()
        case .sppk(let secp256K1PublicKey):
            return try secp256K1PublicKey.encodeToBytes()
        case .p2pk(let p256PublicKey):
            return try p256PublicKey.encodeToBytes()
        }
    }
    
    enum Tag: BytesCodableTag {
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
        
        init(from value: Key.Public) {
            switch value {
            case .edpk(_):
                self = .edpk
            case .sppk(_):
                self = .sppk
            case .p2pk(_):
                self = .p2pk
            }
        }
        
        func create(fromConsuming bytes: inout [UInt8]) throws -> Key.Public {
            switch self {
            case .edpk:
                return .edpk(try .init(fromConsuming: &bytes))
            case .sppk:
                return .sppk(try .init(fromConsuming: &bytes))
            case .p2pk:
                return .p2pk(try .init(fromConsuming: &bytes))
            }
        }
    }
}
