//
//  Key.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

// MARK: Key

public enum Key: EncodedGroup {
    case secret(Secret)
    case `public`(Public)
    
    public static func isValid(string: String) -> Bool {
        Secret.isValid(string: string) || Public.isValid(string: string)
    }
    
    public static func isValid(bytes: [UInt8]) -> Bool {
        Secret.isValid(bytes: bytes) || Public.isValid(bytes: bytes)
    }
    
    public var base58: String {
        switch self {
        case .secret(let secret):
            return secret.base58
        case .public(let `public`):
            return `public`.base58
            
        }
    }
    
    public init(base58: String) throws {
        if let secret = try? Secret(base58: base58) {
            self = .secret(secret)
        } else if let `public` = try? Public(base58: base58) {
            self = .`public`(`public`)
        } else {
            throw TezosError.invalidValue("Invalid key base58 encoded value (\(base58).")
        }
    }
}

// MARK: SecretKey

extension Key {
    
    public enum Secret: EncodedGroup {
        case edsk(Ed25519SecretKey)
        case spsk(Secp256K1SecretKey)
        case p2sk(P256SecretKey)
        
        public static func isValid(string: String) -> Bool {
            Ed25519SecretKey.isValid(string: string) ||
                Secp256K1SecretKey.isValid(string: string) ||
                P256SecretKey.isValid(string: string)
        }
        
        public static func isValid(bytes: [UInt8]) -> Bool {
            Ed25519SecretKey.isValid(bytes: bytes) ||
                Secp256K1SecretKey.isValid(bytes: bytes) ||
                P256SecretKey.isValid(bytes: bytes)
        }
        
        public var base58: String {
            switch self {
            case .edsk(let ed25519SecretKey):
                return ed25519SecretKey.base58
            case .spsk(let secp256K1SecretKey):
                return secp256K1SecretKey.base58
            case .p2sk(let p256SecretKey):
                return p256SecretKey.base58
            }
        }
        
        public init(base58: String) throws {
            if let ed25519 = try? Ed25519SecretKey(base58: base58) {
                self = .edsk(ed25519)
            } else if let secp256K1 = try? Secp256K1SecretKey(base58: base58) {
                self = .spsk(secp256K1)
            } else if let p256 = try? P256SecretKey(base58: base58) {
                self = .p2sk(p256)
            } else {
                throw TezosError.invalidValue("Invalid secret key base58 encoded value (\(base58).")
            }
        }
    }
}

// MARK: PublicKey

extension Key {
    
    public enum Public: EncodedGroup {
        case edpk(Ed25519PublicKey)
        case sppk(Secp256K1PublicKey)
        case p2pk(P256PublicKey)
        
        public static func isValid(string: String) -> Bool {
            Ed25519PublicKey.isValid(string: string) ||
                Secp256K1PublicKey.isValid(string: string) ||
                P256PublicKey.isValid(string: string)
        }
        
        public static func isValid(bytes: [UInt8]) -> Bool {
            Ed25519PublicKey.isValid(bytes: bytes) ||
                Secp256K1PublicKey.isValid(bytes: bytes) ||
                P256PublicKey.isValid(bytes: bytes)
        }
        
        public var base58: String {
            switch self {
            case .edpk(let ed25519PublicKey):
                return ed25519PublicKey.base58
            case .sppk(let secp256K1PublicKey):
                return secp256K1PublicKey.base58
            case .p2pk(let p256PublicKey):
                return p256PublicKey.base58
            }
        }
        
        public init(base58: String) throws {
            if let ed25519 = try? Ed25519PublicKey(base58: base58) {
                self = .edpk(ed25519)
            } else if let secp256K1 = try? Secp256K1PublicKey(base58: base58) {
                self = .sppk(secp256K1)
            } else if let p256 = try? P256PublicKey(base58: base58) {
                self = .p2pk(p256)
            } else {
                throw TezosError.invalidValue("Invalid public key base58 encoded value (\(base58).")
            }
        }
    }
}
