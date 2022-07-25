//
//  Crypto.swift
//  
//
//  Created by Julia Samol on 06.07.22.
//

import Foundation

public class Crypto<Provider: CryptoProvider> {
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    public func hash(_ message: HexString, ofSize size: Int) throws -> [UInt8] {
        try hash(.init(from: message), ofSize: size)
    }
    
    public func hash(_ message: [UInt8], ofSize size: Int) throws -> [UInt8] {
        try provider.blake2b(message: message, ofSize: size)
    }
    
    public func signEd25519(_ message: HexString, with key: [UInt8]) throws -> [UInt8] {
        try signEd25519(.init(from: message), with: key)
    }
    
    public func signEd25519(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
        try provider.signEd25519(message, with: key)
    }
    
    public func verifyEd25519(_ message: HexString, withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        try verifyEd25519(.init(from: message), withSignature: signature, using: key)
    }
    
    public func verifyEd25519(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        try provider.verifyEd25519(message, withSignature: signature, using: key)
    }
    
    public func signSecp256K1(_ message: HexString, with key: [UInt8]) throws -> [UInt8] {
        try signSecp256K1(.init(from: message), with: key)
    }
    
    public func signSecp256K1(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
        try provider.signSecp256K1(message, with: key)
    }
    
    public func verifySecp256K1(_ message: HexString, withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        try verifySecp256K1(.init(from: message), withSignature: signature, using: key)
    }
    
    public func verifySecp256K1(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        try provider.verifySecp256K1(message, withSignature: signature, using: key)
    }
    
    public func signP256(_ message: HexString, with key: [UInt8]) throws -> [UInt8] {
        try signP256(.init(from: message), with: key)
    }
    
    public func signP256(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
        try provider.signP256(message, with: key)
    }
    
    public func verifyP256(_ message: HexString, withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        try verifyP256(.init(from: message), withSignature: signature, using: key)
    }
    
    public func verifyP256(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
        try provider.verifyP256(message, withSignature: signature, using: key)
    }
}
