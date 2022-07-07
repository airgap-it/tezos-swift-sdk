//
//  Address.swift
//
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

// MARK: Address

public enum Address: EncodedGroup {
    public typealias `Protocol` = AddressProtocol
    
    case implicit(Implicit)
    case originated(Originated)
    
    public static func isValid(string: String) -> Bool {
        Implicit.isValid(string: string) || Originated.isValid(string: string)
    }
    
    public static func isValid(bytes: [UInt8]) -> Bool {
        Implicit.isValid(bytes: bytes) || Originated.isValid(bytes: bytes)
    }
    
    public var base58: String {
        switch self {
        case .implicit(let implicit):
            return implicit.base58
        case .originated(let originated):
            return originated.base58
        }
    }
    
    public init(base58: String) throws {
        if let implicit = try? Implicit(base58: base58) {
            self = .implicit(implicit)
        } else if let originated = try? Originated(base58: base58) {
            self = .originated(originated)
        } else {
            throw TezosError.invalidValue("Invalid address base58 encoded value (\(base58).")
        }
    }
}

public protocol AddressProtocol {
    func asAddress() -> Address
}

// MARK: ImplicitAddress

extension Address {
    
    public enum Implicit: EncodedGroup {
        public typealias `Protocol` = ImplicitAddressProtocol
        
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
            if let tz1 = try? Ed25519PublicKeyHash(base58: base58) {
                self = .tz1(tz1)
            } else if let tz2 = try? Secp256K1PublicKeyHash(base58: base58) {
                self = .tz2(tz2)
            } else if let tz3 = try? P256PublicKeyHash(base58: base58) {
                self = .tz3(tz3)
            } else {
                throw TezosError.invalidValue("Invalid implicit address base58 encoded value (\(base58).")
            }
        }
    }
}

public protocol ImplicitAddressProtocol: Address.`Protocol` {
    func asImplicitAddress() -> Address.Implicit
}

extension Address.Implicit.`Protocol` {
    public func asAddress() -> Address {
        .implicit(asImplicitAddress())
    }
}

// MARK: OriginatedAddress

extension Address {
    
    public enum Originated: EncodedGroup {
        public typealias `Protocol` = OriginatedAddressProtocol
        
        case contract(ContractHash)
        
        public static func isValid(string: String) -> Bool {
            ContractHash.isValid(string: string)
        }
        
        public static func isValid(bytes: [UInt8]) -> Bool {
            ContractHash.isValid(bytes: bytes)
        }
        
        public var base58: String {
            switch self {
            case .contract(let contractHash):
                return contractHash.base58
            }
        }
        
        public init(base58: String) throws {
            if let contract = try? ContractHash(base58: base58) {
                self = .contract(contract)
            } else {
                throw TezosError.invalidValue("Invalid originated address base58 encoded value (\(base58).")
            }
        }
    }
}

public protocol OriginatedAddressProtocol: Address.`Protocol` {
    func asOriginatedAddress() -> Address.Originated
}

extension Address.Originated.`Protocol` {
    public func asAddress() -> Address {
        .originated(asOriginatedAddress())
    }
}
