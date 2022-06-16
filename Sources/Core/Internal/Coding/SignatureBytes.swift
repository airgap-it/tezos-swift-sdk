//
//  SignatureBytes.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

import Foundation

extension Signature: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        self = .sig(try .init(fromConsuming: &bytes))
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .edsig(let ed25519Signature):
            return try ed25519Signature.encodeToBytes()
        case .spsig(let secp256K1Signature):
            return try secp256K1Signature.encodeToBytes()
        case .p2sig(let p256Signature):
            return try p256Signature.encodeToBytes()
        case .sig(let genericSignature):
            return try genericSignature.encodeToBytes()
        }
    }
}
