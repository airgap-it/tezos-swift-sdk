//
//  OperationForgingTest.swift
//  
//
//  Created by Julia Samol on 06.07.22.
//

import XCTest
import TezosTestUtils

@testable import TezosCore
@testable import TezosOperation

class OperationForgingTests: XCTestCase {
    
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testForgeOperationToBytes() throws {
        try [
            operationsWithBytes,
            [
                (
                    .signed(.init(
                        branch: try! .init(base58: "BLyKu3tnc9NCuiFfCqfeVGPCoZTyW63dYh2XAYxkM7fQYKCqsju"),
                        content: [],
                        signature: try! .init(base58: "sigYfEeo85wodMjbaJhosP3FMwKeSitdD4jEtPUF2HzQmFvUkRe2fN8FZ5Q9cA1cNj1FALBHEPyav6azDvvuhMNhzUBuwLuz")
                    )),
                    "a5db12a8a7716fa5445bd374c8b3239c876dde8397efae0eb0dd223dc23a51c7"
                )
            ]
        ].flatMap { $0 }.forEach {
            let (operation, hex) = $0
            XCTAssertEqual(try! HexString(from: hex).encodeToBytes(), try operation.forge())
        }
    }
    
    func testUnforgeOperationFromBytes() throws {
        try operationsWithBytes.forEach {
            let (operation, hex) = $0
            XCTAssertEqual(operation, try TezosOperation(fromForged: try! HexString(from: hex).encodeToBytes()))
        }
    }
    
    func testFailToUnforgeOperationFromInvalid() throws {
        try invalidBytes.forEach { hex in
            XCTAssertThrowsError(try TezosOperation(fromForged: try! HexString(from: hex).encodeToBytes()))
        }
    }
    
    func testForgeOperationContentToBytes() throws {
        try operationContentsWithBytes.forEach {
            let (content, hex) = $0
            XCTAssertEqual(try! HexString(from: hex).encodeToBytes(), try content.forge())
        }
    }
    
    func testUnforgeOperationContentFromBytes() throws {
        try operationContentsWithBytes.forEach {
            let (content, hex) = $0
            XCTAssertEqual(content, try TezosOperation.Content(fromForged: try! HexString(from: hex).encodeToBytes()))
        }
    }
    
    func testFailToUnforgeOperationContentFromInvalid() throws {
        try invalidBytes.forEach { hex in
            XCTAssertThrowsError(try TezosOperation.Content(fromForged: try! HexString(from: hex).encodeToBytes()))
        }
    }
    
    private var operationsWithBytes: [(TezosOperation, String)] {
        [
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLyKu3tnc9NCuiFfCqfeVGPCoZTyW63dYh2XAYxkM7fQYKCqsju"),
                    content: []
                )),
                "a5db12a8a7716fa5445bd374c8b3239c876dde8397efae0eb0dd223dc23a51c7"
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    content: [
                        .seedNonceRevelation(.init(
                            level: 1, nonce: try! .init(from: "6cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214")
                        ))
                    ]
                )),
                "86db32fcecf30277eef3ef9f397118ed067957dd998979fd723ea0a0d50beead01000000016cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214"
            ),
            (
                .unsigned(.init(
                    branch: try! .init(base58: "BLjg4HU2BwnCgJfRutxJX5rHACzLDxRJes1MXqbXXdxvHWdK3Te"),
                    content: [
                        .seedNonceRevelation(.init(
                            level: 1, nonce: try! .init(from: "9d15bcdc0194b327d3cb0dcd05242bc6ff1635da635e38ed7a62b8c413ce6833")
                        )),
                        .seedNonceRevelation(.init(
                            level: 2, nonce: try! .init(from: "921ed0115c7cc1b5dcd07ad66ce4d9b2b0186c93c27a80d70b66b4e309add170")
                        ))
                    ]
                )),
                "86db32fcecf30277eef3ef9f397118ed067957dd998979fd723ea0a0d50beead01000000019d15bcdc0194b327d3cb0dcd05242bc6ff1635da635e38ed7a62b8c413ce68330100000002921ed0115c7cc1b5dcd07ad66ce4d9b2b0186c93c27a80d70b66b4e309add170"
            )
        ]
    }
    
    private var operationContentsWithBytes: [(TezosOperation.Content, String)] {
        [
            (
                .seedNonceRevelation(.init(
                    level: 1,
                    nonce: try! HexString(from: "6cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214")
                )),
                "01000000016cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214"
            ),
            (
                .doubleEndorsementEvidence(.init(
                    op1: .init(
                        branch: try! .init(base58: "BLT3XKN3vFqWnWfuuLenQiyVgEgKcJttnGGdCcQbmE95xz9y7S5"),
                        operations: .init(
                            slot: 1,
                            level: 1,
                            round: 1,
                            blockPayloadHash: try! .init(base58: "vh2cHpyeaHQhF7g3RFh8usyYmTTpt882UsRyXECuBwPiB3TcsKNd")
                        ),
                        signature: .sig(try! .init(base58: "sigdV5DNZRBLBDDEkbWcqefBuMZevanVyjotoazkkLbk7jXR8oZUmnxt6n3hkQtTe9WbLEkcCUWw1Ey7Ybby5z35nHKqpndn"))
                    ),
                    op2: .init(
                        branch: try! .init(base58: "BLZS5mP4BufHrZfvzrvw1ReWnj1L2zcQ4mM6Jywoaxe4mHbiCNn"),
                        operations: .init(
                            slot: 2,
                            level: 2,
                            round: 2,
                            blockPayloadHash: try! .init(base58: "vh2rXj5TAG8p1HKiMyaWDdYrRL2rTBPyFLkVorgzEEBqqd4sgsXG")
                        ),
                        signature: .sig(try! .init(base58: "sigff9imsFxGwyQ8nEpXUR8ZFwTqZWjMJAgKGwub6Mn9Cnu4VvBppTRt84VPp1fRwqpx8JTrLHg76guTGzkm9ETKwFNCzniY"))
                    )
                )),
                "020000008b611895c74249d0a90db97644942543d9a9f9efdf48f6fae039f1f72b07ad9ed415000100000001000000017afe70591b8fce15d79383d3b2d1215e11d49672901d733842d6221562a98324767251a73e10b6bbe72a662576abb35bb3161f9a662ead7207e26ca95dbd1c0a3b086470822e83160f916415e00f07840cecfb897e61945255c3ab943bebc1e60000008b6f9a5a686491dc1af62fe3f0c3b2d8d6e1f5883f50592029980d55864a6b24b015000200000002000000029b53a37d056c73de29fef1e17abfaab06876147aa7083b52b0ef6ba92bf5a50c870fd592cf831578551c230a5cc324c7d26c67e5185f071b3fdb797ef89f3be013d51b0f3cf181cb842f13bf35c29a2343908b348b7b5db2e38caa505d5dfc34"
            ),
            (
                .doubleBakingEvidence(.init(
                    bh1: .init(
                        level: 1,
                        proto: 1,
                        predecessor: try! .init(base58: "BKsP8FYgikDmqbUiVxfgXVjWuay5LQZY6LP4EvcsFK8uuqj4wQD"),
                        timestamp: .rfc3339("1970-01-01T00:00:00.001Z"),
                        validationPass: 1,
                        operationsHash: try! .init(base58: "LLoaLP6mc6nVzG2Rp3fSrHFvvGpUvkbHCjLASVduN7GzQAKnPctrR"),
                        fitness: [],
                        context: try! .init(base58: "CoWKSZnE72uMLBeh3Fmj3LSXjJmeCEmYBMxAig15g3LPjTP4rHmR"),
                        payloadHash: try! .init(base58: "vh2cJrNF6FCXo1bfnM9hj66NDQSGQCBxTtqkxkMLzkTeeDnZjrvD"),
                        payloadRound: 1,
                        proofOfWorkNonce: try! .init(from: "d4d34b5686c98ae1"),
                        seedNonceHash: nil,
                        liquidityBakingEscapeVote: true,
                        signature: .sig(try! .init(base58: "sigiaEd9dHEGKgccx3JBBDw4eb6WVxGH3MvyziYbQqWQRMmyecdo5VuSkYWkgZvcQXshB4vV2qkTb6AxbKruaNPfnMg4u2EA"))
                    ),
                    bh2: .init(
                        level: 2,
                        proto: 2,
                        predecessor: try! .init(base58: "BMaBxGyVhtTiMKd7KA8HXJnbTK4e1TzffNc94G18op55HGQYVRk"),
                        timestamp: .rfc3339("1970-01-01T00:00:00.002Z"),
                        validationPass: 2,
                        operationsHash: try! .init(base58: "LLoaNF9sd5z2SZtSmUopYNX6qs77QAUJqrnd5ei378H4bcJhQcPt5"),
                        fitness: [],
                        context: try! .init(base58: "CoVj5HxwnPHpC1SgCC6pgqVPgw2vqFEqaC2bF5STqcbyX6giVrGn"),
                        payloadHash: try! .init(base58: "vh2MHqgJtw8v7CDrZKYWtLmqGJtjzkRvs9yUeHNQqdgDJyCYm21q"),
                        payloadRound: 2,
                        proofOfWorkNonce: try! .init(from: "336ebf95efce0475"),
                        seedNonceHash: try! .init(base58: "nceUeUCJRZ4M7FCSBsAUZU6dmxePdH7irje9Gfj9zWwCdfWd5B4Ee"),
                        liquidityBakingEscapeVote: false,
                        signature: .sig(try! .init(base58: "sigRsUhHqaFVBeV4qzyCZ6Y9TvoKajyNwyPQQCW3SbgPYY99MrpTqR2FopjzZEHMWoJG7LaTaHu7bnieKQRKqCRLA7hB7Ekp"))
                    )
                )),
                "03000000e0000000010114a98b361825acd1997319b0b01069908d1103df26a5646bf998cd6df80b95c60000000000000001018539ef2bf06ca139c6aeda9edc16c853f2b09ff232fab97d7a15150a602ea36500000000dc8d5cafd036ba185119ba904aefbdefd6d30de1f5e4a49fb20b0997ea2cdc357b08b37679350e62ea1bff3287d151c79156f0160b296bdade0ffa7f16f26b6300000001d4d34b5686c98ae100ff9d584824e3bf8b4817abdce782d94d93df6c60581e581990767cb8c0c07c577c328cddebd2da2433736411e17c2cfb282c8067e89c5a3e48246f50eca5e7525f000001000000000202f5043ad9d3aeea868db43f2abda52e1b7f176f928742964ce1db62d8f48cd67f0000000000000002028974da4dc7fcb31faab671f35d065db1d699a2b7d97bb830330977b8650591b0000000008e84ab5712175f8ab1ce14bcf5185d712c472a4e6abf51093a06c7e9042e59d258ef5ec7e36bb4004a4e7f10cb94032d59b65f8a86450c20a63d802ad749546200000002336ebf95efce0475ff37ad10c119adb450d7456104f3971536fb486124a262549c00d3310cd93e6820001dad11dad4d16f110476a24734b1414725506b354e01de4e54a4fdcec01604fda840b53f2cac4109c32680fe58600d96749b1d2891a0aa22b222ba36c864f001"
            ),
            (
                .activateAccount(.init(
                    pkh: try! .init(base58: "tz1PokEhtiBGCmekQrcN87pCDmqy99TjaLuN"),
                    secret: try! .init(from: "7b27ba02550e6834b50173c8c506de42d901c606")
                )),
                "042db6ed2d71e8f22ce348c1b7b2e7f08892bd50ef7b27ba02550e6834b50173c8c506de42d901c606"
            ),
            (
                .proposals(.init(
                    source: try! .init(base58: "tz1QVzD6eV73LhtzhNKs94fKbvTg7VjKjEcE"),
                    period: 1,
                    proposals: [
                        try! .init(base58: "PtYnGfhwjiRjtA7VZriogYL6nwFgaAL9ZuVWE6UahXCMn6BoJPv")
                    ]
                )),
                "050035533a79b20d6ea4dc8b92ab1cf33b448b93c78f0000000100000020f0e14a6c55f809a0ac08dc9bba0596b0daac1944520dfa9b8e2ce4e1a102a203"
            ),
            (
                .proposals(.init(
                    source: try! .init(base58: "tz1MRrtJC9sk1o1D57LPWev6DDVjMgra5pXb"),
                    period: 1,
                    proposals: [
                        try! .init(base58: "PtARwRL7jEGtzoCCWDBXe6ZJ4ZJiWtDgBC2a5WwnHYYyKPdmwrb"),
                        try! .init(base58: "Ps6NdX1CpeF3kHV5CVQZMLZKZwAN8NYN9crdL3GzEg4uNg7f3DY")
                    ]
                )),
                "050013a312c56ed0eb53799ce6ef3eabfc1102f73b940000000100000040be2160f0cad3ca52a8e1a2f9e6fb25e748a769267dad2964550e6d946d0a03c23138e6c4f4e5e47064cbd0cd36b2a09ad01d0709b9737b1f8622a43448de01d5"
            ),
            (
                .ballot(.init(
                    source: try! .init(base58: "tz1eNhmMTYsti2quW46a5CBJbs4Fde4KGg4F"),
                    period: 1,
                    proposal: try! .init(base58: "PsjL76mH8vo3fTfUN4qKrdkPvRfXw7KJPWf87isNAxzh1vqdFQv"),
                    ballot: .yay
                )),
                "0600cd8459db8668d3ae6a4f49cb8fe3c5bbd6c76956000000018522ef9f87cef2f745984cdbfe4a723acfbe7979c6f24ebc04a86d786b1c038500"
            ),
            (
                .ballot(.init(
                    source: try! .init(base58: "tz1eNhmMTYsti2quW46a5CBJbs4Fde4KGg4F"),
                    period: 1,
                    proposal: try! .init(base58: "PsjL76mH8vo3fTfUN4qKrdkPvRfXw7KJPWf87isNAxzh1vqdFQv"),
                    ballot: .nay
                )),
                "0600cd8459db8668d3ae6a4f49cb8fe3c5bbd6c76956000000018522ef9f87cef2f745984cdbfe4a723acfbe7979c6f24ebc04a86d786b1c038501"
            ),
            (
                .ballot(.init(
                    source: try! .init(base58: "tz1eNhmMTYsti2quW46a5CBJbs4Fde4KGg4F"),
                    period: 1,
                    proposal: try! .init(base58: "PsjL76mH8vo3fTfUN4qKrdkPvRfXw7KJPWf87isNAxzh1vqdFQv"),
                    ballot: .pass
                )),
                "0600cd8459db8668d3ae6a4f49cb8fe3c5bbd6c76956000000018522ef9f87cef2f745984cdbfe4a723acfbe7979c6f24ebc04a86d786b1c038502"
            ),
            (
                .doublePreendorsementEvidence(.init(
                    op1: .init(
                        branch: try! .init(base58: "BLT3XKN3vFqWnWfuuLenQiyVgEgKcJttnGGdCcQbmE95xz9y7S5"),
                        operations: .init(
                            slot: 1,
                            level: 1,
                            round: 1,
                            blockPayloadHash: try! .init(base58: "vh2cHpyeaHQhF7g3RFh8usyYmTTpt882UsRyXECuBwPiB3TcsKNd")
                        ),
                        signature: .sig(try! .init(base58: "sigdV5DNZRBLBDDEkbWcqefBuMZevanVyjotoazkkLbk7jXR8oZUmnxt6n3hkQtTe9WbLEkcCUWw1Ey7Ybby5z35nHKqpndn"))
                    ),
                    op2: .init(
                        branch: try! .init(base58: "BLZS5mP4BufHrZfvzrvw1ReWnj1L2zcQ4mM6Jywoaxe4mHbiCNn"),
                        operations: .init(
                            slot: 2,
                            level: 2,
                            round: 2,
                            blockPayloadHash: try! .init(base58: "vh2rXj5TAG8p1HKiMyaWDdYrRL2rTBPyFLkVorgzEEBqqd4sgsXG")
                        ),
                        signature: .sig(try! .init(base58: "sigff9imsFxGwyQ8nEpXUR8ZFwTqZWjMJAgKGwub6Mn9Cnu4VvBppTRt84VPp1fRwqpx8JTrLHg76guTGzkm9ETKwFNCzniY"))
                    )
                )),
                "070000008b611895c74249d0a90db97644942543d9a9f9efdf48f6fae039f1f72b07ad9ed414000100000001000000017afe70591b8fce15d79383d3b2d1215e11d49672901d733842d6221562a98324767251a73e10b6bbe72a662576abb35bb3161f9a662ead7207e26ca95dbd1c0a3b086470822e83160f916415e00f07840cecfb897e61945255c3ab943bebc1e60000008b6f9a5a686491dc1af62fe3f0c3b2d8d6e1f5883f50592029980d55864a6b24b014000200000002000000029b53a37d056c73de29fef1e17abfaab06876147aa7083b52b0ef6ba92bf5a50c870fd592cf831578551c230a5cc324c7d26c67e5185f071b3fdb797ef89f3be013d51b0f3cf181cb842f13bf35c29a2343908b348b7b5db2e38caa505d5dfc34"
            ),
            (
                .failingNoop(.init(
                    arbitrary: try! .init(from: "cc7e647be422e432a3291ec8a2ee6f5e2210c51825b753758a99e266a0c65b15")
                )),
                "1100000020cc7e647be422e432a3291ec8a2ee6f5e2210c51825b753758a99e266a0c65b15"
            ),
            (
                .preendorsement(.init(
                    slot: 1,
                    level: 1,
                    round: 1,
                    blockPayloadHash: try! .init(base58: "vh2KDvhtt44Lyq187SnZjSDyRH1LNXbMj3T9G57miWK9QvqH3fhv")
                )),
                "1400010000000100000001543d9791df12f3237de836314a45a348e5d608c80a6a411246dfc67ef1a08d0a"
            ),
            (
                .endorsement(.init(
                    slot: 1,
                    level: 1,
                    round: 1,
                    blockPayloadHash: try! .init(base58: "vh2WtVuY9PK3mDsnfdzA6iXc4pocgUff8hgamWwXw19r5kDYHVS5")
                )),
                "15000100000001000000016eba3d57f131a71eab0692e333e889cbafe523c675e588ace92bb5056cbcb889"
            ),
            (
                .reveal(.init(
                    source: try! .init(base58: "tz1SZ2CmbQB7MMXgcMSmyyVXpya1rkb9UGUE"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    publicKey: try! .init(base58: "edpkuaARNJPQygG82X1xed6Z2kDutT8XjL3Fmv1XPBbca1uARirj55")
                )),
                "6b004bd66485632a18d61068fc940772dec8add5ff93fba3089a01fbb801e88a02007a79d89acb296dd9ec2be8fba817702dc41adf19e28bb250a337f840eb263c69"
            ),
            (
                .transaction(.init(
                    source: try! .init(base58: "tz1i8xLzLPQHknc5jmeFc3qxijar2HLG2W4Z"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    amount: try! .init(763243),
                    destination: .originated(try! .init(base58: "KT1GFYUFQRT4RsNbtG2NU23woUyMp5tx9gx2"))
                )),
                "6c00f6cb338e136f281d17a2657437f090daf84b42affba3089a01fbb801e88a02ebca2e01541e2bf7dc4401328be301227d204d5dc233b6760000"
            ),
            (
                .transaction(.init(
                    source: try! .init(base58: "tz1i8xLzLPQHknc5jmeFc3qxijar2HLG2W4Z"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    amount: try! .init(763243),
                    destination: .implicit(.tz1(try! .init(base58: "tz1YbTdYqmpLatAqLb1sm67qqXMXyRB3UYiz"))),
                    parameters: .init(
                        entrypoint: .`default`,
                        value: .sequence([])
                    )
                )),
                "6c00f6cb338e136f281d17a2657437f090daf84b42affba3089a01fbb801e88a02ebca2e00008e1d34730fcd7e8282b0efe7b09b3c57543e59c8ff00000000050200000000"
            ),
            (
                .transaction(.init(
                    source: try! .init(base58: "tz1i8xLzLPQHknc5jmeFc3qxijar2HLG2W4Z"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    amount: try! .init(763243),
                    destination: .implicit(.tz1(try! .init(base58: "tz1YbTdYqmpLatAqLb1sm67qqXMXyRB3UYiz"))),
                    parameters: .init(
                        entrypoint: .root,
                        value: .sequence([])
                    )
                )),
                "6c00f6cb338e136f281d17a2657437f090daf84b42affba3089a01fbb801e88a02ebca2e00008e1d34730fcd7e8282b0efe7b09b3c57543e59c8ff01000000050200000000"
            ),
            (
                .transaction(.init(
                    source: try! .init(base58: "tz1i8xLzLPQHknc5jmeFc3qxijar2HLG2W4Z"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    amount: try! .init(763243),
                    destination: .implicit(.tz1(try! .init(base58: "tz1YbTdYqmpLatAqLb1sm67qqXMXyRB3UYiz"))),
                    parameters: .init(
                        entrypoint: .`do`,
                        value: .sequence([])
                    )
                )),
                "6c00f6cb338e136f281d17a2657437f090daf84b42affba3089a01fbb801e88a02ebca2e00008e1d34730fcd7e8282b0efe7b09b3c57543e59c8ff02000000050200000000"
            ),
            (
                .transaction(.init(
                    source: try! .init(base58: "tz1i8xLzLPQHknc5jmeFc3qxijar2HLG2W4Z"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    amount: try! .init(763243),
                    destination: .implicit(.tz1(try! .init(base58: "tz1YbTdYqmpLatAqLb1sm67qqXMXyRB3UYiz"))),
                    parameters: .init(
                        entrypoint: .setDelegate,
                        value: .sequence([])
                    )
                )),
                "6c00f6cb338e136f281d17a2657437f090daf84b42affba3089a01fbb801e88a02ebca2e00008e1d34730fcd7e8282b0efe7b09b3c57543e59c8ff03000000050200000000"
            ),
            (
                .transaction(.init(
                    source: try! .init(base58: "tz1i8xLzLPQHknc5jmeFc3qxijar2HLG2W4Z"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    amount: try! .init(763243),
                    destination: .implicit(.tz1(try! .init(base58: "tz1YbTdYqmpLatAqLb1sm67qqXMXyRB3UYiz"))),
                    parameters: .init(
                        entrypoint: .removeDelegate,
                        value: .sequence([])
                    )
                )),
                "6c00f6cb338e136f281d17a2657437f090daf84b42affba3089a01fbb801e88a02ebca2e00008e1d34730fcd7e8282b0efe7b09b3c57543e59c8ff04000000050200000000"
            ),
            (
                .transaction(.init(
                    source: try! .init(base58: "tz1i8xLzLPQHknc5jmeFc3qxijar2HLG2W4Z"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    amount: try! .init(763243),
                    destination: .implicit(.tz1(try! .init(base58: "tz1YbTdYqmpLatAqLb1sm67qqXMXyRB3UYiz"))),
                    parameters: .init(
                        entrypoint: .named("named"),
                        value: .sequence([])
                    )
                )),
                "6c00f6cb338e136f281d17a2657437f090daf84b42affba3089a01fbb801e88a02ebca2e00008e1d34730fcd7e8282b0efe7b09b3c57543e59c8ffff056e616d6564000000050200000000"
            ),
            (
                .origination(.init(
                    source: try! .init(base58: "tz1LdF7qHCJg8Efa6Cx4LZrRPkvbh61H8tZq"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    balance: try! .init(763243),
                    delegate: nil,
                    script: .init(
                        code: .sequence([]),
                        storage: .sequence([])
                    )
                )),
                "6d000ad2152600ac6bb16b5512e43a337dd562dc2cccfba3089a01fbb801e88a02ebca2e00000000050200000000000000050200000000"
            ),
            (
                .origination(.init(
                    source: try! .init(base58: "tz1LdF7qHCJg8Efa6Cx4LZrRPkvbh61H8tZq"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    balance: try! .init(763243),
                    delegate: .tz1(try! .init(base58: "tz1RY8er4ybXszZBbhtQDrYhA5AYY3VQXiKn")),
                    script: .init(
                        code: .sequence([]),
                        storage: .sequence([])
                    )
                )),
                "6d000ad2152600ac6bb16b5512e43a337dd562dc2cccfba3089a01fbb801e88a02ebca2eff0040b33c1a35d72f3c85747f605b1902d36fc8c9a3000000050200000000000000050200000000"
            ),
            (
                .delegation(.init(
                    source: try! .init(base58: "tz1QVAraV1JDRsPikcqJVE4VccvW7vDWCJHy"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    delegate: nil
                )),
                "6e00352bb30ffdb72d101083a4fc5cd156f007705f5dfba3089a01fbb801e88a0200"
            ),
            (
                .delegation(.init(
                    source: try! .init(base58: "tz1QVAraV1JDRsPikcqJVE4VccvW7vDWCJHy"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    delegate: .tz1(try! .init(base58: "tz1dStZpfk5bWsvYvuktDJgDEbpuqDc7ipvi"))
                )),
                "6e00352bb30ffdb72d101083a4fc5cd156f007705f5dfba3089a01fbb801e88a02ff00c356e7cb9943f6ef4168bea7915c7f88152e6c37"
            ),
            (
                .registerGlobalConstant(.init(
                    source: try! .init(base58: "tz1brHnNaHcpxqHDhqwmAXDq1i4F2A4Xaepz"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    value: .sequence([])
                )),
                "6f00b1d399df432bbbdbd45cb6b454699ea96d77dabffba3089a01fbb801e88a02000000050200000000"
            ),
            (
                .setDepositsLimit(.init(
                    source: try! .init(base58: "tz1gxabEuUaCKk15qUKnhASJJoXhm9A7DVLM"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    limit: nil
                )),
                "7000e9dcc1a4a82c49aeec327b15e9ed457dc22a1ebcfba3089a01fbb801e88a0200"
            ),
            (
                .setDepositsLimit(.init(
                    source: try! .init(base58: "tz1gxabEuUaCKk15qUKnhASJJoXhm9A7DVLM"),
                    fee: try! .init(135675),
                    counter: .init(154),
                    gasLimit: .init(23675),
                    storageLimit: .init(34152),
                    limit: try! .init(634)
                )),
                "7000e9dcc1a4a82c49aeec327b15e9ed457dc22a1ebcfba3089a01fbb801e88a02fffa04"
            )
        ]
    }

    private var invalidBytes: [String] {
        [
            "a5db12a8a7716fa5445bd374c8b3239c876dde8397efae0eb0dd223dc23a51",
            "86db32fcecf30277eef3ef9f397118ed067957dd998979fd723ea0a0d50beead00000000016cdaf9367e551995a670a5c642a9396290f8c9d17e6bc3c1555bfaa910d92214"
        ]
    }
}
