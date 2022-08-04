//
//  Signature.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

// MARK: Signature
    
public enum Signature: SignatureProtocol, EncodedGroup {
    public typealias `Protocol` = SignatureProtocol
    
    case edsig(Ed25519Signature)
    case spsig(Secp256K1Signature)
    case p2sig(P256Signature)
    case sig(GenericSignature)
    
    public static func isValid(string: String) -> Bool {
        Ed25519Signature.isValid(string: string) ||
            Secp256K1Signature.isValid(string: string) ||
            P256Signature.isValid(string: string) ||
            GenericSignature.isValid(string: string)
    }
    
    public static func isValid(bytes: [UInt8]) -> Bool {
        Ed25519Signature.isValid(bytes: bytes) ||
            Secp256K1Signature.isValid(bytes: bytes) ||
            P256Signature.isValid(bytes: bytes) ||
            GenericSignature.isValid(bytes: bytes)
    }
    
    public var base58: String {
        switch self {
        case .edsig(let ed25519Signature):
            return ed25519Signature.base58
        case .spsig(let secp256K1Signature):
            return secp256K1Signature.base58
        case .p2sig(let p256Signature):
            return p256Signature.base58
        case .sig(let genericSignature):
            return genericSignature.base58
        }
    }
    
    public init(base58: String) throws {
        if let ed25519 = try? Ed25519Signature(base58: base58) {
            self = .edsig(ed25519)
        } else if let secp256K1 = try? Secp256K1Signature(base58: base58) {
            self = .spsig(secp256K1)
        } else if let p256 = try? P256Signature(base58: base58) {
            self = .p2sig(p256)
        } else if let generic = try? GenericSignature(base58: base58) {
            self = .sig(generic)
        } else {
            throw TezosError.invalidValue("Invalid signature base58 encoded value (\(base58).")
        }
    }
    
    public func asSignature() -> Signature {
        self
    }
}

public protocol SignatureProtocol {
    func asSignature() -> Signature
}
