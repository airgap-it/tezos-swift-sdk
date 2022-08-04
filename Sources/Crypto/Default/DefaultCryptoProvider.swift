//
//  DefaultCryptoProvider.swift
//  
//
//  Created by Julia Samol on 03.08.22.
//

import Clibsodium
import Crypto
import secp256k1

import TezosCore

public struct DefaultCryptoProvider: CryptoProvider {
    
    public init() {
        
    }
    
    // MARK: BLAKE2b
    
    public func blake2b(message: [UInt8], ofSize size: Int) throws -> [UInt8] {
        var result = [UInt8](repeating: 0, count: size)
        let status = crypto_generichash(&result, size, message, UInt64(message.count), nil, 0)
        guard status == 0 else {
            throw TezosCryptoSodiumError.sodium(Int(status))
        }
        
        return result
    }
    
    // MARK: Ed25519
    
    public func signEd25519(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
        var result = [UInt8](repeating: 0, count: crypto_sign_bytes())
        let status = crypto_sign_ed25519_detached(&result, nil, message, UInt64(message.count), key)
        guard status == 0 else {
            throw TezosCryptoSodiumError.sodium(Int(status))
        }
        
        return result
    }
    
    public func verifyEd25519(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        let status = crypto_sign_ed25519_verify_detached(signature, message, UInt64(message.count), key)
        return status == 0
    }
    
    // MARK: secp256k1
    
    // TODO: test implementation
    
    public func signSecp256K1(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
        let key = try secp256k1.Signing.PrivateKey(rawRepresentation: key)
        let signature = try key.ecdsa.signature(for: message)

        return signature.bytes
    }
    
    public func verifySecp256K1(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        let key = try secp256k1.Signing.PublicKey(rawRepresentation: key, format: .compressed)
        let signature = try secp256k1.Signing.ECDSASignature(rawRepresentation: signature)

        return key.ecdsa.isValidSignature(signature, for: message)
    }
    
    // MARK: P256
    
    // TODO: test implementation
    
    public func signP256(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
        let key = try P256.Signing.PrivateKey(rawRepresentation: key)
        let signature = try key.signature(for: message)
        
        return signature.bytes
    }
    
    public func verifyP256(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        let key: P256.Signing.PublicKey = try {
            switch key.count {
            case 33:
                return try P256.Signing.PublicKey(compactRepresentation: key[1...])
            case 32:
                return try P256.Signing.PublicKey(compactRepresentation: key)
            default:
                return try P256.Signing.PublicKey(rawRepresentation: key)
            }
        }()
        let signature = try P256.Signing.ECDSASignature(rawRepresentation: signature)
        
        return key.isValidSignature(signature, for: message)
    }
}
