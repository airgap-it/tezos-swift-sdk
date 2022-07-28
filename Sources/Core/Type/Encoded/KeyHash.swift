//
//  KeyHash.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

// MARK: KeyHash

public enum KeyHash: EncodedGroup {
    public typealias `Protocol` = KeyHashProtocol
    
    case `public`(Public)
    
    public static func isValid(string: String) -> Bool {
        Public.isValid(string: string)
    }
    
    public static func isValid(bytes: [UInt8]) -> Bool {
        Public.isValid(bytes: bytes)
    }
    
    public var base58: String {
        switch self {
        case .public(let `public`):
            return `public`.base58
            
        }
    }
    
    public init(base58: String) throws {
        if let `public` = try? Public(base58: base58) {
            self = .`public`(`public`)
        } else {
            throw TezosError.invalidValue("Invalid key hash base58 encoded value (\(base58).")
        }
    }
}

public protocol KeyHashProtocol {
    func asKeyHash() -> KeyHash
}

// MARK: PublicKeyHash

extension KeyHash {
    
    public enum Public: EncodedGroup {
        public typealias `Protocol` = PublicKeyHashProtocol
        
        case tz1(Ed25519PublicKeyHash)
        case tz2(Secp256K1PublicKeyHash)
        case tz3(P256PublicKeyHash)
        
        public static func isValid(string: String) -> Bool {
            Ed25519PublicKeyHash.isValid(string: string) ||
                Secp256K1PublicKeyHash.isValid(string: string) ||
                P256PublicKeyHash.isValid(string: string)
        }
        
        public static func isValid(bytes: [UInt8]) -> Bool {
            Ed25519PublicKeyHash.isValid(bytes: bytes) ||
                Secp256K1PublicKeyHash.isValid(bytes: bytes) ||
                P256PublicKeyHash.isValid(bytes: bytes)
        }
        
        public var base58: String {
            switch self {
            case .tz1(let ed25519PublicKeyHash):
                return ed25519PublicKeyHash.base58
            case .tz2(let secp256K1PublicKeyHash):
                return secp256K1PublicKeyHash.base58
            case .tz3(let p256PublicKeyHash):
                return p256PublicKeyHash.base58
            }
        }
        
        public init(base58: String) throws {
            if let ed25519 = try? Ed25519PublicKeyHash(base58: base58) {
                self = .tz1(ed25519)
            } else if let secp256K1 = try? Secp256K1PublicKeyHash(base58: base58) {
                self = .tz2(secp256K1)
            } else if let p256 = try? P256PublicKeyHash(base58: base58) {
                self = .tz3(p256)
            } else {
                throw TezosError.invalidValue("Invalid public key hash base58 encoded value (\(base58).")
            }
        }
    }
}

public protocol PublicKeyHashProtocol: KeyHash.`Protocol` {
    func asPublicKeyHash() -> KeyHash.Public
}

public extension KeyHash.Public.`Protocol` {
    func asKeyHash() -> KeyHash {
        .public(asPublicKeyHash())
    }
}

// MARK: BlindedKeyHash

public enum BlindedKeyHash: EncodedGroup {
    public typealias `Protocol` = BlindedKeyHashProtocol
    
    case `public`(Public)
    
    public static func isValid(string: String) -> Bool {
        Public.isValid(string: string)
    }
    
    public static func isValid(bytes: [UInt8]) -> Bool {
        Public.isValid(bytes: bytes)
    }
    
    public var base58: String {
        switch self {
        case .public(let `public`):
            return `public`.base58
            
        }
    }
    
    public init(base58: String) throws {
        if let `public` = try? Public(base58: base58) {
            self = .`public`(`public`)
        } else {
            throw TezosError.invalidValue("Invalid blinded key hash base58 encoded value (\(base58).")
        }
    }
}

public protocol BlindedKeyHashProtocol {
    func asBlindedKeyHash() -> BlindedKeyHash
}

// MARK: BlindedPublicKeyHash

extension BlindedKeyHash {
    
    public enum Public: EncodedGroup {
        public typealias `Protocol` = PublicBlindedKeyHashProtocol
        
        case btz1(Ed25519BlindedPublicKeyHash)
        
        public static func isValid(string: String) -> Bool {
            Ed25519BlindedPublicKeyHash.isValid(string: string)
        }
        
        public static func isValid(bytes: [UInt8]) -> Bool {
            Ed25519BlindedPublicKeyHash.isValid(bytes: bytes)
        }
        
        public var base58: String {
            switch self {
            case .btz1(let ed25519BlindedPublicKeyHash):
                return ed25519BlindedPublicKeyHash.base58
            }
        }
        
        public init(base58: String) throws {
            if let ed25519 = try? Ed25519BlindedPublicKeyHash(base58: base58) {
                self = .btz1(ed25519)
            } else {
                throw TezosError.invalidValue("Invalid blinded public key hash base58 encoded value (\(base58).")
            }
        }
    }
}

public protocol PublicBlindedKeyHashProtocol: BlindedKeyHash.`Protocol` {
    func asPublicBlindedKeyHash() -> BlindedKeyHash.Public
}

extension BlindedKeyHash.Public.`Protocol` {
    public func asBlindedKeyHash() -> BlindedKeyHash {
        .public(asPublicBlindedKeyHash())
    }
}
