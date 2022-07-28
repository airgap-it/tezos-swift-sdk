//
//  OperationSigningTest.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

import XCTest
import Clibsodium
import TezosTestUtils

@testable import TezosCore
@testable import TezosOperation

class OperationSigningTest: XCTestCase {
    private var crypto: Crypto<SodiumCryptoProvider>!
    
    override func setUpWithError() throws {
        crypto = .init(provider: SodiumCryptoProvider())
    }

    override func tearDownWithError() throws {
        crypto = nil
    }
    
    func testSignOperation() throws {
        try operationsWithEd25519Signatures.forEach {
            let (operation, signature) = $0
            let key = ed25519KeyPair.0
            
            let signedWithCurrentKey = TezosOperation.Signed(
                branch: operation.branch,
                contents: operation.contents,
                signature: signature.asSignature()
            )
            let signedWithOtherKey = TezosOperation.Signed(
                branch: operation.branch,
                contents: operation.contents,
                signature: .edsig(try! .init(base58: "edsigtsnqaaNExgKjVyp4J5pphV4GvmEWh9T5hXyfLn1Bs2rLubib9htT8hy575R733UrmTc65cgjuNYKXQxGS2dR9BW98kKw8m"))
            )
            
            XCTAssertEqual(signature, try key.sign(operation, using: crypto))
            XCTAssertEqual(signature, try key.sign(.signed(signedWithCurrentKey), using: crypto))
            XCTAssertEqual(signature, try key.sign(.signed(signedWithOtherKey), using: crypto))
            
            XCTAssertEqual(signedWithCurrentKey, try operation.sign(with: key.asSecretKey(), using: crypto))
            XCTAssertEqual(signedWithCurrentKey, try signedWithCurrentKey.sign(with: key.asSecretKey(), using: crypto))
            XCTAssertEqual(signedWithCurrentKey, try signedWithOtherKey.sign(with: key.asSecretKey(), using: crypto))
        }
        
//        try operationsWithSecp256K1Signatures.forEach {
//            let (operation, signature) = $0
//            let key = secp256K1KeyPair.0
//
//            let signedWithCurrentKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: signature.asSignature()
//            )
//            let signedWithOtherKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .spsig(try! .init(base58: "spsig19ZLL6dzEryZ8sPp7ggaqK6p7P6oC4Zc24BTFYNZykuiuVA9KuNzfuoNETzPpqEzN16cLiHMfrfys8TTDV1ycyDgPL8wvm"))
//            )
//
//            XCTAssertEqual(signature, try key.sign(operation, using: crypto))
//            XCTAssertEqual(signature, try key.sign(.signed(signedWithCurrentKey), using: crypto))
//            XCTAssertEqual(signature, try key.sign(.signed(signedWithOtherKey), using: crypto))
//
//            XCTAssertEqual(signedWithCurrentKey, try operation.sign(with: key.asSecretKey(), using: crypto))
//            XCTAssertEqual(signedWithCurrentKey, try signedWithCurrentKey.sign(with: key.asSecretKey(), using: crypto))
//            XCTAssertEqual(signedWithCurrentKey, try signedWithOtherKey.sign(with: key.asSecretKey(), using: crypto))
//        }
        
//        try operationsWithP256Signatures.forEach {
//            let (operation, signature) = $0
//            let key = p256KeyPair.0
//            
//            let signedWithCurrentKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: signature.asSignature()
//            )
//            let signedWithOtherKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .p2sig(try! .init(base58: "p2sigTrmxRGhckRaai4vVSDBeRwUfuPhHzJZmQtnX9MxaUsRBE9KMgNe1nwA2BWWZdH8qUtcE5nr8H5XjD8VtcJsabqGpNDRgx"))
//            )
//            
//            XCTAssertEqual(signature, try key.sign(operation, using: crypto))
//            XCTAssertEqual(signature, try key.sign(.signed(signedWithCurrentKey), using: crypto))
//            XCTAssertEqual(signature, try key.sign(.signed(signedWithOtherKey), using: crypto))
//            
//            XCTAssertEqual(signedWithCurrentKey, try operation.sign(with: key.asSecretKey(), using: crypto))
//            XCTAssertEqual(signedWithCurrentKey, try signedWithCurrentKey.sign(with: key.asSecretKey(), using: crypto))
//            XCTAssertEqual(signedWithCurrentKey, try signedWithOtherKey.sign(with: key.asSecretKey(), using: crypto))
//        }
    }
    
    func testVerifySignedOperation() throws {
        try operationsWithEd25519Signatures.forEach {
            let (operation, signature) = $0
            let key = ed25519KeyPair.1
            
            let signedWithCurrentKey = TezosOperation.Signed(
                branch: operation.branch,
                contents: operation.contents,
                signature: signature.asSignature()
            )
            let signedWithOtherKey = TezosOperation.Signed(
                branch: operation.branch,
                contents: operation.contents,
                signature: .edsig(try! .init(base58: "edsigtsnqaaNExgKjVyp4J5pphV4GvmEWh9T5hXyfLn1Bs2rLubib9htT8hy575R733UrmTc65cgjuNYKXQxGS2dR9BW98kKw8m"))
            )
            let signedWithSecp256K1Key = TezosOperation.Signed(
                branch: operation.branch,
                contents: operation.contents,
                signature: .spsig(try! .init(base58: "spsig19ZLL6dzEryZ8sPp7ggaqK6p7P6oC4Zc24BTFYNZykuiuVA9KuNzfuoNETzPpqEzN16cLiHMfrfys8TTDV1ycyDgPL8wvm"))
            )
            let signedWithP256Key = TezosOperation.Signed(
                branch: operation.branch,
                contents: operation.contents,
                signature: .p2sig(try! .init(base58: "p2sigTrmxRGhckRaai4vVSDBeRwUfuPhHzJZmQtnX9MxaUsRBE9KMgNe1nwA2BWWZdH8qUtcE5nr8H5XjD8VtcJsabqGpNDRgx"))
            )
            
            XCTAssertTrue(try key.verify(signedWithCurrentKey, using: crypto))
            XCTAssertFalse(try key.verify(signedWithOtherKey, using: crypto))
            XCTAssertFalse(try key.verify(signedWithSecp256K1Key, using: crypto))
            XCTAssertFalse(try key.verify(signedWithP256Key, using: crypto))
            
            XCTAssertTrue(try signedWithCurrentKey.verify(with: key.asPublicKey(), using: crypto))
            XCTAssertFalse(try signedWithOtherKey.verify(with: key.asPublicKey(), using: crypto))
            XCTAssertFalse(try signedWithSecp256K1Key.verify(with: key.asPublicKey(), using: crypto))
            XCTAssertFalse(try signedWithP256Key.verify(with: key.asPublicKey(), using: crypto))
        }
        
//        try operationsWithSecp256K1Signatures.forEach {
//            let (operation, signature) = $0
//            let key = secp256K1KeyPair.1
//
//            let signedWithCurrentKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: signature.asSignature()
//            )
//            let signedWithOtherKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .spsig(try! .init(base58: "spsig19ZLL6dzEryZ8sPp7ggaqK6p7P6oC4Zc24BTFYNZykuiuVA9KuNzfuoNETzPpqEzN16cLiHMfrfys8TTDV1ycyDgPL8wvm"))
//            )
//            let signedWithEd25519Key = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .edsig(try! .init(base58: "edsigtsnqaaNExgKjVyp4J5pphV4GvmEWh9T5hXyfLn1Bs2rLubib9htT8hy575R733UrmTc65cgjuNYKXQxGS2dR9BW98kKw8m"))
//            )
//            let signedWithP256Key = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .p2sig(try! .init(base58: "p2sigTrmxRGhckRaai4vVSDBeRwUfuPhHzJZmQtnX9MxaUsRBE9KMgNe1nwA2BWWZdH8qUtcE5nr8H5XjD8VtcJsabqGpNDRgx"))
//            )
//
//            XCTAssertTrue(try key.verify(signedWithCurrentKey, using: crypto))
//            XCTAssertFalse(try key.verify(signedWithOtherKey, using: crypto))
//            XCTAssertFalse(try key.verify(signedWithEd25519Key, using: crypto))
//            XCTAssertFalse(try key.verify(signedWithP256Key, using: crypto))
//
//            XCTAssertTrue(try signedWithCurrentKey.verify(with: key.asPublicKey(), using: crypto))
//            XCTAssertFalse(try signedWithOtherKey.verify(with: key.asPublicKey(), using: crypto))
//            XCTAssertFalse(try signedWithEd25519Key.verify(with: key.asPublicKey(), using: crypto))
//            XCTAssertFalse(try signedWithP256Key.verify(with: key.asPublicKey(), using: crypto))
//        }
        
//        try operationsWithP256Signatures.forEach {
//            let (operation, signature) = $0
//            let key = p256KeyPair.1
//
//            let signedWithCurrentKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: signature.asSignature()
//            )
//            let signedWithOtherKey = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .p2sig(try! .init(base58: "p2sigTrmxRGhckRaai4vVSDBeRwUfuPhHzJZmQtnX9MxaUsRBE9KMgNe1nwA2BWWZdH8qUtcE5nr8H5XjD8VtcJsabqGpNDRgx"))
//            )
//            let signedWithEd25519Key = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .edsig(try! .init(base58: "edsigtsnqaaNExgKjVyp4J5pphV4GvmEWh9T5hXyfLn1Bs2rLubib9htT8hy575R733UrmTc65cgjuNYKXQxGS2dR9BW98kKw8m"))
//            )
//            let signedWithSecp256K1Key = TezosOperation.Signed(
//                branch: operation.branch,
//                contents: operation.contents,
//                signature: .spsig(try! .init(base58: "spsig19ZLL6dzEryZ8sPp7ggaqK6p7P6oC4Zc24BTFYNZykuiuVA9KuNzfuoNETzPpqEzN16cLiHMfrfys8TTDV1ycyDgPL8wvm"))
//            )
//
//            XCTAssertTrue(try key.verify(signedWithCurrentKey, using: crypto))
//            XCTAssertFalse(try key.verify(signedWithOtherKey, using: crypto))
//            XCTAssertFalse(try key.verify(signedWithEd25519Key, using: crypto))
//            XCTAssertFalse(try key.verify(signedWithSecp256K1Key, using: crypto))
//
//            XCTAssertTrue(try signedWithCurrentKey.verify(with: key.asPublicKey(), using: crypto))
//            XCTAssertFalse(try signedWithOtherKey.verify(with: key.asPublicKey(), using: crypto))
//            XCTAssertFalse(try signedWithEd25519Key.verify(with: key.asPublicKey(), using: crypto))
//            XCTAssertFalse(try signedWithSecp256K1Key.verify(with: key.asPublicKey(), using: crypto))
//        }
    }
    
    private var operationsWithEd25519Signatures: [(TezosOperation, Ed25519Signature)] {
        [
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: []
                )),
                try! .init(base58: "edsigtfLuR4pGGfJwYgWZbWi9JGzjLA8ThhThxqFGC8V6u4WTdS4fM7VFQKoN9jPDLKiAW75PtG1bykpnRa6ozr8m12iKGYCxNd")
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: [
                        .seedNonceRevelation(.init(
                            level: 1,
                            nonce: try! .init(from: "6cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214")
                        ))
                    ]
                )),
                try! .init(base58: "edsigtyP4ZD5NtBBkAkrmXQZg84xt9uCiHBpjqZj2HE65d4V9dkDapSVJ6jvaA4gEEgksVJzqSxdv2rnMyBzPoAfBQwNEqt8Y1x")
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: [
                        .seedNonceRevelation(.init(
                            level: 1,
                            nonce: try! .init(from: "9d15bcdc0194b327d3cb0dcd05242bc6ff1635da635e38ed7a62b8c413ce6833")
                        )),
                        .seedNonceRevelation(.init(
                            level: 2,
                            nonce: try! .init(from: "921ed0115c7cc1b5dcd07ad66ce4d9b2b0186c93c27a80d70b66b4e309add170")
                        ))
                    ]
                )),
                try! .init(base58: "edsigu5i46oiR9Ye45rUJnPNLkEWkLvvGG5uzHCzPuoNFemNAguHBFn5hXiBivnHHdSzGqsMBc8c5cxAUr8Ue6FUVufbM3hECdU")
            )
        ]
    }
    
    private var operationsWithSecp256K1Signatures: [(TezosOperation, Secp256K1Signature)] {
        [
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: []
                )),
                try! .init(base58: "spsig1LPnrCkaRypLUz3UYdxQGVpxfSAxWwSV2HpaitKWvqRN6CDqqLJwWNn1S9kEWT2ZLrWq7m2361YVMN4LNkc9FVPdxBjYZi")
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: [
                        .seedNonceRevelation(.init(
                            level: 1,
                            nonce: try! .init(from: "6cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214")
                        ))
                    ]
                )),
                try! .init(base58: "spsig1SC5sFkHG4YssRxQJQ5onZ8GNvfQDqk5cz1e6fdPhCNva3baoPCiE9fk6JcyUedEDFAEeMBgC7L6LeYBhFHpVrxjs96iuB")
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: [
                        .seedNonceRevelation(.init(
                            level: 1,
                            nonce: try! .init(from: "9d15bcdc0194b327d3cb0dcd05242bc6ff1635da635e38ed7a62b8c413ce6833")
                        )),
                        .seedNonceRevelation(.init(
                            level: 2,
                            nonce: try! .init(from: "921ed0115c7cc1b5dcd07ad66ce4d9b2b0186c93c27a80d70b66b4e309add170")
                        ))
                    ]
                )),
                try! .init(base58: "spsig1XFTLzrozPJ7Kc9aVNwK4hjpub7cWu8a95LmSKNucsPZjrgq3QRcQWtvo1fbBzpeWPK56XaUiJRN6B59kzueT6LCqTWK8R")
            )
        ]
    }
    
    private var operationsWithP256Signatures: [(TezosOperation, P256Signature)] {
        [
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: []
                )),
                try! .init(base58: "p2sigY5tNCTjyR3w2rbgBHnkcEChmtk43Gt6BKqwX2TsNdpVojk3QgRy9Wf3TMkAyRnagy4LrhC4AfVDFBQK87sqBipsNkCt5N")
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: [
                        .seedNonceRevelation(.init(
                            level: 1,
                            nonce: try! .init(from: "6cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214")
                        ))
                    ]
                )),
                try! .init(base58: "p2sigUMZVy7WyyvYawCt8oW4eMvXCTWtmU6PCfsTbKmAUXuHFCcH8ER7ZwtNqsnwYER9DRKXfao9xhUFfYdxZPFFDi4J7nckvt")
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    contents: [
                        .seedNonceRevelation(.init(
                            level: 1,
                            nonce: try! .init(from: "9d15bcdc0194b327d3cb0dcd05242bc6ff1635da635e38ed7a62b8c413ce6833")
                        )),
                        .seedNonceRevelation(.init(
                            level: 2,
                            nonce: try! .init(from: "921ed0115c7cc1b5dcd07ad66ce4d9b2b0186c93c27a80d70b66b4e309add170")
                        ))
                    ]
                )),
                try! .init(base58: "p2sigrjm1STjRF4ygPiPzd4L34MzCErExERsH79jWwJTdYqdaYbYA29UfE1y8f78268B2xNdT3gzR5tXR7G21DCYyYkGnFe3Dm")
            )
        ]
    }
    
    private var ed25519KeyPair: (Ed25519SecretKey, Ed25519PublicKey) {
        (
            try! .init(base58: "edskRv7VyXGVZb8EsrR7D9XKUbbAQNQGtALP6QeB16ZCD7SmmJpzyeneJVg3Mq56YLbxRA1kSdAXiswwPiaVfR3NHGMCXCziuZ"),
            try! .init(base58: "edpkttZKC51wemRqL2QxwpMnEKxWnbd35pq47Y6xsCHp5M1f7LN8NP")
        )
    }
    
    private var secp256K1KeyPair: (Secp256K1SecretKey, Secp256K1PublicKey) {
        (
            try! .init(base58: "spsk1SsrWCpufeXkNruaG9L3Mf9dRyd4D8HsM8ftqseN1fne3x9LNk"),
            try! .init(base58: "sppk7ZpH5qAjTDZn1o1TW7z2QbQZUcMHRn2wtV4rRfz15eLQrvPkt6k")
        )
    }
    
    private var p256KeyPair: (P256SecretKey, P256PublicKey) {
        (
            try! .init(base58: "p2sk2rVhhi5EfEdhJ3wQGsdc4ZEN3i7Z8f73Bn1xp1JKjETNyJ85oW"),
            try! .init(base58: "p2pk67fo5oy6byruqDtzVixbM7L3cVBDRMcFhA33XD5w2HF4fRXDJhw")
        )
    }
    
    private class SodiumCryptoProvider: CryptoProvider {
        func blake2b(message: [UInt8], ofSize size: Int) throws -> [UInt8] {
            var result = [UInt8](repeating: 0, count: size)
            let status = crypto_generichash(&result, size, message, UInt64(message.count), nil, 0)
            guard status == 0 else {
                throw Error.sodium(Int(status))
            }
            
            return result
        }
        
        func signEd25519(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
            var result = [UInt8](repeating: 0, count: crypto_sign_bytes())
            let status = crypto_sign_ed25519_detached(&result, nil, message, UInt64(message.count), key)
            guard status == 0 else {
                throw Error.sodium(Int(status))
            }
            
            return result
        }
        
        func verifyEd25519(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
            let status = crypto_sign_ed25519_verify_detached(signature, message, UInt64(message.count), key)
            return status == 0
        }
        
        func signSecp256K1(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
            // TODO: implement
            []
        }
        
        func verifySecp256K1(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
            // TODO: implement
            false
        }
        
        func signP256(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8] {
            // TODO: implement
            []
        }
        
        func verifyP256(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool {
            // TODO: implement
            false
        }
        
        enum Error: Swift.Error {
            case sodium(Int)
        }
        
        private var p256KeyPair: (P256SecretKey, P256PublicKey) {
            (
                try! .init(base58: "p2sk2rVhhi5EfEdhJ3wQGsdc4ZEN3i7Z8f73Bn1xp1JKjETNyJ85oW"),
                try! .init(base58: "p2pk67fo5oy6byruqDtzVixbM7L3cVBDRMcFhA33XD5w2HF4fRXDJhw")
            )
        }
    }
}
