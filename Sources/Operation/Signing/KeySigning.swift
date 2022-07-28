//
//  KeySigning.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import TezosCore

// MARK: Key.Secret

extension Key.Secret {
    public func sign(_ operation: TezosOperation) throws -> Signature {
        fatalError("TODO: Inject crypto")
    }
    
    func sign<Provider: CryptoProvider>(_ operation: TezosOperation, using crypto: Crypto<Provider>) throws -> Signature {
        try signOperation(try operation.forge(), with: self, using: crypto)
    }
}

// MARK: Ed25519SecretKey

extension Ed25519SecretKey {
    public func sign(_ operation: TezosOperation) throws -> Ed25519Signature {
        fatalError("TODO: Inject crypto")
    }
    
    func sign<Provider: CryptoProvider>(_ operation: TezosOperation, using crypto: Crypto<Provider>) throws -> Ed25519Signature {
        try signOperationEd25519(try operation.forge(), with: self, using: crypto)
    }
}

// MARK: Secp256K1SecretKey

extension Secp256K1SecretKey {
    public func sign(_ operation: TezosOperation) throws -> Secp256K1Signature {
        fatalError("TODO: Inject crypto")
    }
    
    func sign<Provider: CryptoProvider>(_ operation: TezosOperation, using crypto: Crypto<Provider>) throws -> Secp256K1Signature {
        try signOperationSecp256K1(try operation.forge(), with: self, using: crypto)
    }
}

// MARK: P256K1SecretKey

extension P256SecretKey {
    public func sign(_ operation: TezosOperation) throws -> P256Signature {
        fatalError("TODO: Inject crypto")
    }
    
    func sign<Provider: CryptoProvider>(_ operation: TezosOperation, using crypto: Crypto<Provider>) throws -> P256Signature {
        try signOperationP256(try operation.forge(), with: self, using: crypto)
    }
}

// MARK: Key.Public

extension Key.Public {
    public func verify(_ operation: TezosOperation.Signed) throws -> Bool {
        fatalError("TODO: Inject crypto")
    }
    
    func verify<Provider: CryptoProvider>(_ operation: TezosOperation.Signed, using crypto: Crypto<Provider>) throws -> Bool {
        try verifySignature(operation.signature, forOperation: operation.forge(), with: self, using: crypto)
    }
}

// MARK: Ed25519PublicKey

extension Ed25519PublicKey {
    public func verify(_ operation: TezosOperation.Signed) throws -> Bool {
        fatalError("TODO: Inject crypto")
    }
    
    func verify<Provider: CryptoProvider>(_ operation: TezosOperation.Signed, using crypto: Crypto<Provider>) throws -> Bool {
        try verifySignature(operation.signature, forOperation: operation.forge(), with: asPublicKey(), using: crypto)
    }
}

// MARK: Secp256K1PublicKey

extension Secp256K1PublicKey {
    public func verify(_ operation: TezosOperation.Signed) throws -> Bool {
        fatalError("TODO: Inject crypto")
    }
    
    func verify<Provider: CryptoProvider>(_ operation: TezosOperation.Signed, using crypto: Crypto<Provider>) throws -> Bool {
        try verifySignature(operation.signature, forOperation: operation.forge(), with: asPublicKey(), using: crypto)
    }
}

// MARK: P256K1PublicKey

extension P256PublicKey {
    public func verify(_ operation: TezosOperation.Signed) throws -> Bool {
        fatalError("TODO: Inject crypto")
    }
    
    func verify<Provider: CryptoProvider>(_ operation: TezosOperation.Signed, using crypto: Crypto<Provider>) throws -> Bool {
        try verifySignature(operation.signature, forOperation: operation.forge(), with: asPublicKey(), using: crypto)
    }
}

// MARK: Utilities: Sign

private func signOperation<Provider: CryptoProvider>(_ operation: [UInt8], with key: Key.Secret, using crypto: Crypto<Provider>) throws -> Signature {
    switch key {
    case .edsk(let ed25519SecretKey):
        return try signOperationEd25519(operation, with: ed25519SecretKey, using: crypto).asSignature()
    case .spsk(let secp256K1SecretKey):
        return try signOperationSecp256K1(operation, with: secp256K1SecretKey, using: crypto).asSignature()
    case .p2sk(let p256SecretKey):
        return try signOperationP256(operation, with: p256SecretKey, using: crypto).asSignature()
    }
}

private func signOperationEd25519<Provider: CryptoProvider>(_ operation: [UInt8], with key: Ed25519SecretKey, using crypto: Crypto<Provider>) throws -> Ed25519Signature {
    let signatureBytes = try signOperation(operation, withKey: try key.encodeToBytes(), using: crypto, and: crypto.signEd25519(_:with:))
    return try Ed25519Signature(from: signatureBytes)
}

private func signOperationSecp256K1<Provider: CryptoProvider>(_ operation: [UInt8], with key: Secp256K1SecretKey, using crypto: Crypto<Provider>) throws -> Secp256K1Signature {
    let signatureBytes = try signOperation(operation, withKey: try key.encodeToBytes(), using: crypto, and: crypto.signSecp256K1(_:with:))
    return try Secp256K1Signature(from: signatureBytes)
}

private func signOperationP256<Provider: CryptoProvider>(_ operation: [UInt8], with key: P256SecretKey, using crypto: Crypto<Provider>) throws -> P256Signature {
    let signatureBytes = try signOperation(operation, withKey: try key.encodeToBytes(), using: crypto, and: crypto.signP256(_:with:))
    return try P256Signature(from: signatureBytes)
}

private func signOperation<Provider: CryptoProvider>(
    _ operation: [UInt8],
    withKey key: [UInt8],
    using crypto: Crypto<Provider>,
    and signer: (_ message: [UInt8], _ key: [UInt8]) throws -> [UInt8]
) throws -> [UInt8] {
    try signer(try hashOperation(operation, using: crypto), key)
}

// MARK: Utilities: Verify

private func verifySignature<Provider: CryptoProvider>(_ signature: Signature, forOperation operation: [UInt8], with key: Key.Public, using crypto: Crypto<Provider>) throws -> Bool {
    let signature = try specifySignature(signature, for: key)
    
    switch (signature, key) {
    case (.edsig(let ed25519Signature), .edpk(let ed25519PublicKey)):
        return try verifyEd25519Signature(ed25519Signature, forOperation: operation, with: ed25519PublicKey, using: crypto)
    case (.spsig(let secp256K1Signature), .sppk(let secp256K1PublicKey)):
        return try verifySecp256K1Signature(secp256K1Signature, forOperation: operation, with: secp256K1PublicKey, using: crypto)
    case (.p2sig(let p256Signature), .p2pk(let p256PublicKey)):
        return try verifyP256Signature(p256Signature, forOperation: operation, with: p256PublicKey, using: crypto)
    default:
        return false
    }
}

private func verifyEd25519Signature<Provider: CryptoProvider>(
    _ signature: Ed25519Signature,
    forOperation operation: [UInt8],
    with key: Ed25519PublicKey,
    using crypto: Crypto<Provider>
) throws -> Bool {
    try verifySignature(try signature.encodeToBytes(), forOperation: operation, withKey: try key.encodeToBytes(), using: crypto, and: crypto.verifyEd25519(_:withSignature:using:))
}

private func verifySecp256K1Signature<Provider: CryptoProvider>(
    _ signature: Secp256K1Signature,
    forOperation operation: [UInt8],
    with key: Secp256K1PublicKey,
    using crypto: Crypto<Provider>
) throws -> Bool {
    try verifySignature(try signature.encodeToBytes(), forOperation: operation, withKey: try key.encodeToBytes(), using: crypto, and: crypto.verifySecp256K1(_:withSignature:using:))
}

private func verifyP256Signature<Provider: CryptoProvider>(
    _ signature: P256Signature,
    forOperation operation: [UInt8],
    with key: P256PublicKey,
    using crypto: Crypto<Provider>
) throws -> Bool {
    try verifySignature(try signature.encodeToBytes(), forOperation: operation, withKey: try key.encodeToBytes(), using: crypto, and: crypto.verifyP256(_:withSignature:using:))
}

private func verifySignature<Provider: CryptoProvider>(
    _ signature: [UInt8],
    forOperation operation: [UInt8],
    withKey key: [UInt8],
    using crypto: Crypto<Provider>,
    and verifier: (_ message: [UInt8], _ signature: [UInt8], _ key: [UInt8]) throws -> Bool
) throws -> Bool {
    try verifier(try hashOperation(operation, using: crypto), signature, key)
}

private func specifySignature(_ signature: Signature, for key: Key.Public) throws -> Signature {
    guard case let .sig(genericSignature) = signature else {
        return signature
    }
    
    switch key {
    case .edpk(_):
        return try genericSignature.toEd25519Signature().asSignature()
    case .sppk(_):
        return try genericSignature.toSecp256K1Signature().asSignature()
    case .p2pk(_):
        return try genericSignature.toP256Signature().asSignature()
    }
}

// MARK: Utilities

private func hashOperation<Provider: CryptoProvider>(_ operation: [UInt8], using crypto: Crypto<Provider>) throws -> [UInt8] {
    try crypto.hash(Watermark.genericOperation + operation, ofSize: 32)
}
