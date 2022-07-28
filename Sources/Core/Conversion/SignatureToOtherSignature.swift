//
//  SignatureToOtherSignature.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

// MARK: Signature

extension Signature {
    public func toGenericSignature() throws -> GenericSignature {
        switch self {
        case .edsig(let ed25519Signature):
            return try GenericSignature(from: try ed25519Signature.encodeToBytes())
        case .spsig(let secp256K1Signature):
            return try GenericSignature(from: try secp256K1Signature.encodeToBytes())
        case .p2sig(let p256Signature):
            return try GenericSignature(from: try p256Signature.encodeToBytes())
        case .sig(let genericSignature):
            return genericSignature
        }
    }
}

// MARK: GenericSignature

extension GenericSignature {
    public func toEd25519Signature() throws -> Ed25519Signature {
        try Ed25519Signature(from: try encodeToBytes())
    }
    
    public func toSecp256K1Signature() throws -> Secp256K1Signature {
        try Secp256K1Signature(from: try encodeToBytes())
    }
    
    public func toP256Signature() throws -> P256Signature {
        try P256Signature(from: try encodeToBytes())
    }
}
