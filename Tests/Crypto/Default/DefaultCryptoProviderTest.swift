//
//  DefaultCryptoProviderTest.swift
//  
//
//  Created by Julia Samol on 03.08.22.
//

import XCTest

@testable import TezosCore
@testable import TezosCryptoDefault

class DefaultCryptoProviderTest: XCTestCase {
    private var cryptoProvider: DefaultCryptoProvider!

    override func setUpWithError() throws {
        cryptoProvider = .init()
    }

    override func tearDownWithError() throws {
        cryptoProvider = nil
    }
    
    // MARK: BLAKE2b

    func testHashMessageWithBlake2b() throws {
        let messagesWithExpected = [
            (
                ("05", 14),
                "83c3adbe3df356621ae564f8bbc9"
            ),
            (
                ("e8", 15),
                "ede34bef1d2c6eea55d71e32274ea6"
            ),
            (
                ("c61942f42ed2df", 20),
                "64784d8512a767216a6e1c49da6c1a802f2230fa"
            ),
            (
                ("5b992df7bc5fd0592963", 7),
                "878fd55e5ff578"
            ),
            (
                ("d8c4c50a33c3fd6688e1928df9", 1),
                "fd"
            ),
            (
                ("a20acc96fd827e8a6e76fd7608552d6a", 32),
                "95425e29f8a2b001afa3297b75f5034800c2e73c2f07d47a765f0b621f8ccc40"
            ),
            (
                ("08ed2c535272820eb78453586f6c5cd92876b0", 64),
                "cf2462cfcbb7369d6f044051c3fb3dc1892ce41d4c672e74023880556cfa87c1b6e5a62b0e82cc539ac48f91780dd25d9367ad5888e224cf76c3e2173c461229"
            )
        ]
        
        try messagesWithExpected.forEach {
            let message = [UInt8](from: try! HexString(from: $0.0.0))
            let size = $0.0.1
            let expected = [UInt8](from: try! HexString(from: $0.1))
            
            let actual = try cryptoProvider.blake2b(message: message, ofSize: size)
            
            XCTAssertEqual(expected, actual)
        }
    }
    
    // MARK: Ed25519
    
    func testSignMessageWithEd25519Key() throws {
        let messagesWithExpected = [
            (
                "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
                "f3d7c25a6dd553ee9a558b470e3ebfe607b8e725da946f6984e3a2a9e18050a04fb45dfc27558763a9339e841af21714c9d038b710830975ad92a28fb4b33205"
            ),
            (
                "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
                "581a028d8e637423e32b50b96ff8636e0c0a68d32652c493a4ff3721f50d017b36ead9cf1ac6830fae78981a67a3e509638c308a02b0effd17442eb7690c1a0d"
            )
        ]
        
        let secretKey = [UInt8](from: try! HexString(from: ed25519KeyPair.0))
        
        try messagesWithExpected.forEach {
            let message = [UInt8](from: try! HexString(from: $0.0))
            let expected = [UInt8](from: try! HexString(from: $0.1))
            
            let actual = try cryptoProvider.signEd25519(message, with: secretKey)
            
            XCTAssertEqual(expected, actual)
        }
    }
    
    func testVerifyMessageWithEd25519Key() throws {
        let messagesWithExpected = [
            (
                (
                    "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
                    "f3d7c25a6dd553ee9a558b470e3ebfe607b8e725da946f6984e3a2a9e18050a04fb45dfc27558763a9339e841af21714c9d038b710830975ad92a28fb4b33205"
                ),
                true
            ),
            (
                (
                    "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
                    "581a028d8e637423e32b50b96ff8636e0c0a68d32652c493a4ff3721f50d017b36ead9cf1ac6830fae78981a67a3e509638c308a02b0effd17442eb7690c1a0d"
                ),
                true
            ),
            (
                (
                    "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
                    "581a028d8e637423e32b50b96ff8636e0c0a68d32652c493a4ff3721f50d017b36ead9cf1ac6830fae78981a67a3e509638c308a02b0effd17442eb7690c1a0d"
                ),
                false
            ),
            (
                (
                    "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
                    "f3d7c25a6dd553ee9a558b470e3ebfe607b8e725da946f6984e3a2a9e18050a04fb45dfc27558763a9339e841af21714c9d038b710830975ad92a28fb4b33205"
                ),
                false
            )
        ]
        
        let publicKey = [UInt8](from: try! HexString(from: ed25519KeyPair.1))
        
        try messagesWithExpected.forEach {
            let message = [UInt8](from: try! HexString(from: $0.0.0))
            let signature = [UInt8](from: try! HexString(from: $0.0.1))
            let expected = $0.1
            
            let actual = try cryptoProvider.verifyEd25519(message, withSignature: signature, using: publicKey)
            
            XCTAssertEqual(expected, actual)
        }
    }
    
    // MARK: secp256k1
    
//    func testSignMessageWithSecp256K1Key() throws {
//        let messagesWithExpected = [
//            (
//                "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
//                "c272b5c8f4aba4cbac9a40020639429edb211a3386bf927799ec6324a54239c77583b003b59a7bbc7111230f0530c05d544d570de7bc5ef302dddcbd62281cbe"
//            ),
//            (
//                "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
//                "25984dc84e5c1d33ae85ca11b1da32938f03f6fe4c6a8ae5c3cb95a62d6fe4371773e48413458afd3c1a417078e48155037fa64ebbe14d8c5fa62b692fd7fa9b"
//            )
//        ]
//
//        let secretKey = [UInt8](from: try! HexString(from: secp256K1KeyPair.0))
//
//        try messagesWithExpected.forEach {
//            let message = [UInt8](from: try! HexString(from: $0.0))
//            let expected = [UInt8](from: try! HexString(from: $0.1))
//
//            let actual = try cryptoProvider.signSecp256K1(message, with: secretKey)
//
//            XCTAssertEqual(expected, actual)
//        }
//    }
//
//    func testVerifyMessageWithSecp256K1Key() throws {
//        let messagesWithExpected = [
//            (
//                (
//                    "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
//                    "c272b5c8f4aba4cbac9a40020639429edb211a3386bf927799ec6324a54239c77583b003b59a7bbc7111230f0530c05d544d570de7bc5ef302dddcbd62281cbe"
//                ),
//                true
//            ),
//            (
//                (
//                    "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
//                    "25984dc84e5c1d33ae85ca11b1da32938f03f6fe4c6a8ae5c3cb95a62d6fe4371773e48413458afd3c1a417078e48155037fa64ebbe14d8c5fa62b692fd7fa9b"
//                ),
//                true
//            ),
//            (
//                (
//                    "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
//                    "25984dc84e5c1d33ae85ca11b1da32938f03f6fe4c6a8ae5c3cb95a62d6fe4371773e48413458afd3c1a417078e48155037fa64ebbe14d8c5fa62b692fd7fa9b"
//                ),
//                false
//            ),
//            (
//                (
//                    "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
//                    "c272b5c8f4aba4cbac9a40020639429edb211a3386bf927799ec6324a54239c77583b003b59a7bbc7111230f0530c05d544d570de7bc5ef302dddcbd62281cbe"
//                ),
//                false
//            )
//        ]
//
//        let publicKey = [UInt8](from: try! HexString(from: secp256K1KeyPair.1))
//
//        try messagesWithExpected.forEach {
//            let message = [UInt8](from: try! HexString(from: $0.0.0))
//            let signature = [UInt8](from: try! HexString(from: $0.0.1))
//            let expected = $0.1
//
//            let actual = try cryptoProvider.verifySecp256K1(message, withSignature: signature, using: publicKey)
//
//            XCTAssertEqual(expected, actual)
//        }
//    }
    
    // MARK: P256
    
//    func testSignMessageWithP256Key() throws {
//        let messagesWithExpected = [
//            (
//                "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
//                "e0fdb186b140de795f73c30ed8c269a2a71ba4c062502c8befe85d38044fd9ec4a3246b6ba7fb06045a2d121e4f6c8e2aa90be01b5a96502e8e53407bbb13bc2"
//            ),
//            (
//                "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
//                "3c1c7c51f8ceddc31e6c81a46b3147b52cfa34bf9639af0b541f7eb94ea9356e729ef2d57c8dbe686a87b55695643d8fa4af50e17fb32808e0e9c94a315a763a"
//            )
//        ]
//        
//        let secretKey = [UInt8](from: try! HexString(from: p256KeyPair.0))
//        
//        try messagesWithExpected.forEach {
//            let message = [UInt8](from: try! HexString(from: $0.0))
//            let expected = [UInt8](from: try! HexString(from: $0.1))
//            
//            let actual = try cryptoProvider.signP256(message, with: secretKey)
//            
//            XCTAssertEqual(expected, actual)
//        }
//    }
//    
//    func testVerifyMessageWithP256Key() throws {
//        let messagesWithExpected = [
//            (
//                (
//                    "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
//                    "e0fdb186b140de795f73c30ed8c269a2a71ba4c062502c8befe85d38044fd9ec4a3246b6ba7fb06045a2d121e4f6c8e2aa90be01b5a96502e8e53407bbb13bc2"
//                ),
//                true
//            ),
//            (
//                (
//                    "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
//                    "3c1c7c51f8ceddc31e6c81a46b3147b52cfa34bf9639af0b541f7eb94ea9356e729ef2d57c8dbe686a87b55695643d8fa4af50e17fb32808e0e9c94a315a763a"
//                ),
//                true
//            ),
//            (
//                (
//                    "bb67a3ba9ac64fb89ab480f634755f0d92c263f980b8705dbb24b3010a3b1e69",
//                    "3c1c7c51f8ceddc31e6c81a46b3147b52cfa34bf9639af0b541f7eb94ea9356e729ef2d57c8dbe686a87b55695643d8fa4af50e17fb32808e0e9c94a315a763a"
//                ),
//                false
//            ),
//            (
//                (
//                    "a25f6cf295585d7f4802ed61cb4df44d4af5dc11c4ae86f61a2cab8fdcdbffc0",
//                    "e0fdb186b140de795f73c30ed8c269a2a71ba4c062502c8befe85d38044fd9ec4a3246b6ba7fb06045a2d121e4f6c8e2aa90be01b5a96502e8e53407bbb13bc2"
//                ),
//                false
//            )
//        ]
//        
//        let publicKey = [UInt8](from: try! HexString(from: p256KeyPair.1))
//        
//        try messagesWithExpected.forEach {
//            let message = [UInt8](from: try! HexString(from: $0.0.0))
//            let signature = [UInt8](from: try! HexString(from: $0.0.1))
//            let expected = $0.1
//            
//            let actual = try cryptoProvider.verifyP256(message, withSignature: signature, using: publicKey)
//            
//            XCTAssertEqual(expected, actual)
//        }
//    }
    
    private var ed25519KeyPair: (String, String) {
            (
                "8a56c92b7df4841ea1a79b2daa478b9a629ff359e00fd344e0c5fbd139e9114f208c1d0dec92b417baf72bed39357fa7062c59336a5981fa239c1f426841ea83",
                "208c1d0dec92b417baf72bed39357fa7062c59336a5981fa239c1f426841ea83"
            )
    }

    private var secp256K1KeyPair: (String, String) {
        (
            "02fb68cbc677ffb43368a610f2d5782a159ae2783aad34a8f353b94d63738c58",
            "02434e3529cd6a192e865d28d60cf516adb58bb074b9c17dfd3c45d9c697b83333"
        )
    }

    private var p256KeyPair: (String, String) {
        (
            "4372f787773fb0669c4ba453768573c61e20ad09616043df3cf16ab7e6bfb94b",
            "0397e0c76ca850349cfb7684121c5fc7516f7ff3300bf047631cc8e6b155b56758"
        )
    }
}
