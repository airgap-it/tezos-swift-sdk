//
//  MichelinePackingTests.swift
//  
//
//  Created by Julia Samol on 16.06.22.
//

import XCTest
@testable import TezosCore
@testable import TezosMichelson

class MichelinePackingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPackMichelineToBytes() throws {
        try [
            packedWithIntegersAndSchemas.wrapped().wrapped(),
            packedWithStringsAndSchemas.wrapped().wrapped(),
            packedWithBytesAndSchemas.wrapped().wrapped(),
            packedWithPrimitiveApplicationsAndSchemas.wrapped(),
            packedWithSequencesAndSchemas.wrapped(),
            [
                TestCase<Micheline.Literal.Integer>(
                    packed: "0500aff8aff1ce5f",
                    valuesWithSchemas: [
                        (try! .init("1642675437103"), .comparableType(prim: .timestamp))
                    ]
                ),
            ].wrapped().wrapped(),
            [
                TestCase<Micheline.Literal.String>(
                    packed: "050a000000402050b812a7d784193c030c8c72d892c2e167765fa5506c10bca5073b963fb9b861251f349c52cde2b76af285235c0a8bdc7eb2b26646ddc759b7da425d64588d",
                    valuesWithSchemas: [
                        (try! .init("edsigtc2yNWbqq5WxGjJMrBDFR6WjQHWztGaXPsKk5ZoPST6XBmPfkykxxoEcmvHnyNzQAdzih6dE6yMwGi5smEmARDhjfwaqwZ"), .comparableType(prim: .signature))
                    ]
                ),
                TestCase<Micheline.Literal.String>(
                    packed: "050a000000409dbc33d2b25d37d5a965789bef6e65f65d2048922e00127a79741137a84915e2a61e5f43bdaab7c401e5a74301118dd2aa048c39c7808a994cbc1e8ca819e73a",
                    valuesWithSchemas: [
                        (try! .init("spsig1SSsjUEotAhXLxnpxhYYTDbTz2cWbj2LqvFsdeEq5ggRetuAWYLa1GjPPcEJcHL8CqpGt2DeYq9onWuMiYraGNEA4P3UKC"), .comparableType(prim: .signature))
                    ]
                ),
                
                TestCase<Micheline.Literal.String>(
                    packed: "050a00000040d5dd7160f806328604d8fc6413a17386eb5b3825dbb68b4b7c38ca314c624955efd6bfafb3e04aa696d7fbee0bb32d94288c4d582edcd0d9f07142fa1dd7048f",
                    valuesWithSchemas: [
                        (try! .init("p2sigqHLPRghCJr9E3B1ihWfjPJCLsADCL9JqoxESYLqQ2UzBSRvcUbjQ1s1ztpa5mNcrKAnEFAd7MDNrTrm1iDT7bA3Lkkxne"), .comparableType(prim: .signature))
                    ]
                ),
                
                TestCase<Micheline.Literal.String>(
                    packed: "050a00000040cdedf48569b5ff605f3d4d00219d70a6b4aa46b090c5ceceeacfb3d5abb614e2ae2d01ce7b0b2fb17bee11434d3b379bcfef01126b2778646ac7bb11c5eb5a0b",
                    valuesWithSchemas: [
                        (try! .init("sigpvu5AhSNvaGmWMj4jZFWfZ73aCWtHqLEXCb5uRCrPkXzP5AuJeuptXKS3NMQHg7h8nd3iDVYNwf2fFNaWskUA7DjxJKAL"), .comparableType(prim: .signature))
                    ]
                ),
            ].wrapped().wrapped(),
            [
                TestCase<Micheline.Literal.Bytes>(
                    packed: "050a00000016000094a0ba27169ed8d97c1f476de6156c2482dbfb3d",
                    valuesWithSchemas: [
                        (try! .init("0x000094a0ba27169ed8d97c1f476de6156c2482dbfb3d"), .comparableType(prim: .address))
                    ]
                ),
                TestCase<Micheline.Literal.Bytes>(
                    packed: "050a00000004ef6a66af",
                    valuesWithSchemas: [
                        (try! .init("0xef6a66af"), .comparableType(prim: .chainID))
                    ]
                ),
                TestCase<Micheline.Literal.Bytes>(
                    packed: "050a000000150094a0ba27169ed8d97c1f476de6156c2482dbfb3d",
                    valuesWithSchemas: [
                        (try! .init("0x0094a0ba27169ed8d97c1f476de6156c2482dbfb3d"), .comparableType(prim: .keyHash))
                    ]
                ),
                TestCase<Micheline.Literal.Bytes>(
                    packed: "050a00000021005a9847101250e9cea9e714a8fd945e5131aeb5c021e027b1420db0cdd971c862",
                    valuesWithSchemas: [
                        (try! .init("0x005a9847101250e9cea9e714a8fd945e5131aeb5c021e027b1420db0cdd971c862"), .comparableType(prim: .key))
                    ]
                ),
                TestCase<Micheline.Literal.Bytes>(
                    packed: "050a000000402050b812a7d784193c030c8c72d892c2e167765fa5506c10bca5073b963fb9b861251f349c52cde2b76af285235c0a8bdc7eb2b26646ddc759b7da425d64588d",
                    valuesWithSchemas: [
                        (try! .init("0x2050b812a7d784193c030c8c72d892c2e167765fa5506c10bca5073b963fb9b861251f349c52cde2b76af285235c0a8bdc7eb2b26646ddc759b7da425d64588d"), .comparableType(prim: .signature))
                    ]
                )
            ].wrapped().wrapped(),
            [
                TestCase<Micheline.Sequence>(
                    packed: "050707030b0707030b030b",
                    valuesWithSchemas: [
                        (
                            [
                                .data(prim: .unit),
                                .data(prim: .unit),
                                .data(prim: .unit)
                            ],
                            .comparableType(
                                prim: .pair,
                                args: [
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit)
                                ]
                            )
                        )
                    ]
                )
            ].wrapped()
        ].flatMap { $0 }.forEach { testCase in
            try testCase.valuesWithSchemas.forEach { (micheline, schema) in
                XCTAssertEqual(testCase.packed, try micheline.packToBytes(usingSchema: schema))
            }
        }
    }

    func testFailToPackMichelinePrimitiveApplicationIfPrimIsUnknown() throws {
        try invalidPrimitiveApplicationsWithSchema.forEach { (micheline, schema) in
            XCTAssertThrowsError(try micheline.packToBytes(usingSchema: schema))
        }
    }
    
    func testUnpackMichelineFromBytes() throws {
        try [
            packedWithIntegersAndSchemas.wrapped().wrapped(),
            packedWithStringsAndSchemas.wrapped().wrapped(),
            packedWithBytesAndSchemas.wrapped().wrapped(),
            packedWithPrimitiveApplicationsAndSchemas.wrapped(),
            packedWithSequencesAndSchemas.wrapped(),
            [
                TestCase<Micheline.Literal.String>(
                    packed: "050a000000402050b812a7d784193c030c8c72d892c2e167765fa5506c10bca5073b963fb9b861251f349c52cde2b76af285235c0a8bdc7eb2b26646ddc759b7da425d64588d",
                    valuesWithSchemas: [
                        (try! .init("sigSDWFTNwZ9KvDYK4i9N4ToEDdTS4udhw2Ba1MDoQS75ZswT5G5qssjzhjKfzsup3j6X6maqsGMQAXv3g76RCEAddoyfkRa"), .comparableType(prim: .signature))
                    ]
                ),
                TestCase<Micheline.Literal.String>(
                    packed: "050a000000409dbc33d2b25d37d5a965789bef6e65f65d2048922e00127a79741137a84915e2a61e5f43bdaab7c401e5a74301118dd2aa048c39c7808a994cbc1e8ca819e73a",
                    valuesWithSchemas: [
                        (try! .init("sigidCQQdZQpjNxno4zYzPoJv65CpwXfPeNM8Yrr5XGnkiDqFMKyGC49FXhEfDYtGG885894N27h15hECFCgB5M9h3Up8u51"), .comparableType(prim: .signature))
                    ]
                ),
                
                TestCase<Micheline.Literal.String>(
                    packed: "050a00000040d5dd7160f806328604d8fc6413a17386eb5b3825dbb68b4b7c38ca314c624955efd6bfafb3e04aa696d7fbee0bb32d94288c4d582edcd0d9f07142fa1dd7048f",
                    valuesWithSchemas: [
                        (try! .init("sigqy7YLb96qv6m6vFTyv8wsqQxUVywEitdNBP48tQ6p2hduA9J6YeAjgbhht3rLB3Xh9GDAvgmrG4V5AqH7mFgKThJthxa3"), .comparableType(prim: .signature))
                    ]
                ),
                
                TestCase<Micheline.Literal.String>(
                    packed: "050a00000040cdedf48569b5ff605f3d4d00219d70a6b4aa46b090c5ceceeacfb3d5abb614e2ae2d01ce7b0b2fb17bee11434d3b379bcfef01126b2778646ac7bb11c5eb5a0b",
                    valuesWithSchemas: [
                        (try! .init("sigpvu5AhSNvaGmWMj4jZFWfZ73aCWtHqLEXCb5uRCrPkXzP5AuJeuptXKS3NMQHg7h8nd3iDVYNwf2fFNaWskUA7DjxJKAL"), .comparableType(prim: .signature))
                    ]
                ),
            ].wrapped().wrapped(),
        ].flatMap { $0 }.forEach { testCase in
            try testCase.valuesWithSchemas.forEach { (micheline, schema) in
                XCTAssertEqual(try micheline.normalized(), try Micheline(fromPacked: testCase.packed, usingSchema: schema))
            }
        }
    }
    
    func testFailToUnpackMichelineIfPackedValueOrSchemaIsInvalid() throws {
        try (invalidPackedWithSchema + packedWithInvalidSchema).forEach { (packed, schema) in
            XCTAssertThrowsError(try Micheline(fromPacked: [UInt8](from: try! HexString(from: packed)), usingSchema: schema))
        }
    }

    private var packedWithIntegersAndSchemas: [TestCase<Micheline.Literal.Integer>] {
        [
            .init(
                packed: "0500c384efcfc7dac2f5849995afab9fa7c48b8fa4c0d9b5ca908dc70d",
                valuesWithSchemas: [
                    (try! .init("-41547452475632687683489977342365486797893454355756867843"), nil),
                    (try! .init("-41547452475632687683489977342365486797893454355756867843"), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500fc90d3c2e6a3b9c4c0b7fbf3b3b6d802",
                valuesWithSchemas: [
                    (try! .init("-54576326575686358562454576456764"), nil),
                    (try! .init("-54576326575686358562454576456764"), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500c8a8dd9df89cb998be01",
                valuesWithSchemas: [
                    (.init(-6852352674543413768), nil),
                    (.init(-6852352674543413768), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500f9b1e2fee2c308",
                valuesWithSchemas: [
                    (.init(-18756523543673), nil),
                    (.init(-18756523543673), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500c002",
                valuesWithSchemas: [
                    (.init(-128), nil),
                    (.init(-128), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500ff01",
                valuesWithSchemas: [
                    (.init(-127), nil),
                    (.init(-127), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500c001",
                valuesWithSchemas: [
                    (.init(-64), nil),
                    (.init(-64), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05006a",
                valuesWithSchemas: [
                    (.init(-42), nil),
                    (.init(-42), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05004a",
                valuesWithSchemas: [
                    (.init(-10), nil),
                    (.init(-10), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "050041",
                valuesWithSchemas: [
                    (.init(-1), nil),
                    (.init(-1), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "050000",
                valuesWithSchemas: [
                    (.init(0), nil),
                    (.init(0), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "050001",
                valuesWithSchemas: [
                    (.init(1), nil),
                    (.init(1), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05000a",
                valuesWithSchemas: [
                    (.init(10), nil),
                    (.init(10), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05002a",
                valuesWithSchemas: [
                    (.init(42), nil),
                    (.init(42), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05008001",
                valuesWithSchemas: [
                    (.init(64), nil),
                    (.init(64), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500bf01",
                valuesWithSchemas: [
                    (.init(127), nil),
                    (.init(127), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05008002",
                valuesWithSchemas: [
                    (.init(128), nil),
                    (.init(128), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500b9b1e2fee2c308",
                valuesWithSchemas: [
                    (.init(18756523543673), nil),
                    (.init(18756523543673), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "050088a8dd9df89cb998be01",
                valuesWithSchemas: [
                    (.init(6852352674543413768), nil),
                    (.init(6852352674543413768), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "0500bc90d3c2e6a3b9c4c0b7fbf3b3b6d802",
                valuesWithSchemas: [
                    (try! .init("54576326575686358562454576456764"), nil),
                    (try! .init("54576326575686358562454576456764"), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05008384efcfc7dac2f5849995afab9fa7c48b8fa4c0d9b5ca908dc70d",
                valuesWithSchemas: [
                    (try! .init("41547452475632687683489977342365486797893454355756867843"), nil),
                    (try! .init("41547452475632687683489977342365486797893454355756867843"), .comparableType(prim: .int))
                ]
            ),
            .init(
                packed: "05002a",
                valuesWithSchemas: [
                    (.init(42), .type(
                        prim: .bigMap,
                        args: [
                            .comparableType(prim: .unit),
                            .comparableType(prim: .unit)
                        ]
                    )),
                ]
            ),
        ]
    }

    private var packedWithStringsAndSchemas: [TestCase<Micheline.Literal.String>] {
        [
            .init(
                packed: "050100000000",
                valuesWithSchemas: [
                    (try! .init(""), nil),
                    (try! .init(""), .comparableType(prim: .string))
                ]
            ),
            .init(
                packed: "05010000000161",
                valuesWithSchemas: [
                    (try! .init("a"), nil),
                    (try! .init("a"), .comparableType(prim: .string))
                ]
            ),
            .init(
                packed: "050100000003616263",
                valuesWithSchemas: [
                    (try! .init("abc"), nil),
                    (try! .init("abc"), .comparableType(prim: .string))
                ]
            ),
            .init(
                packed: "050100000024747a315a734b4d6f6f47504a6135486f525435445156356a31526b5263536979706e594e",
                valuesWithSchemas: [
                    (try! .init("tz1ZsKMooGPJa5HoRT5DQV5j1RkRcSiypnYN"), nil),
                    (try! .init("tz1ZsKMooGPJa5HoRT5DQV5j1RkRcSiypnYN"), .comparableType(prim: .string))
                ]
            ),
            .init(
                packed: "050a00000016000094a0ba27169ed8d97c1f476de6156c2482dbfb3d",
                valuesWithSchemas: [
                    (try! .init("tz1ZBuF2dQ7E1b32bK3g1Qsah4pvWqpM4b4A"), .comparableType(prim: .address))
                ]
            ),
            .init(
                packed: "050a0000001601541e2bf7dc4401328be301227d204d5dc233b67600",
                valuesWithSchemas: [
                    (try! .init("KT1GFYUFQRT4RsNbtG2NU23woUyMp5tx9gx2"), .comparableType(prim: .address))
                ]
            ),
            .init(
                packed: "050a0000002001541e2bf7dc4401328be301227d204d5dc233b67600656e747279706f696e74",
                valuesWithSchemas: [
                    (try! .init("KT1GFYUFQRT4RsNbtG2NU23woUyMp5tx9gx2%entrypoint"), .comparableType(prim: .address))
                ]
            ),
            .init(
                packed: "050a00000004ef6a66af",
                valuesWithSchemas: [
                    (try! .init("NetXy3eo3jtuwuc"), .comparableType(prim: .chainID))
                ]
            ),
            .init(
                packed: "050a000000150094a0ba27169ed8d97c1f476de6156c2482dbfb3d",
                valuesWithSchemas: [
                    (try! .init("tz1ZBuF2dQ7E1b32bK3g1Qsah4pvWqpM4b4A"), .comparableType(prim: .keyHash))
                ]
            ),
            .init(
                packed: "050a00000021005a9847101250e9cea9e714a8fd945e5131aeb5c021e027b1420db0cdd971c862",
                valuesWithSchemas: [
                    (try! .init("edpkuL84TEk6s2C9JCywmBS4Mztumq6iUVxNtBHvuZG95VPvFw1yCR"), .comparableType(prim: .key))
                ]
            ),
            .init(
                packed: "0500aff8aff1ce5f",
                valuesWithSchemas: [
                    (try! .init("2022-01-20T10:43:57.103Z"), .comparableType(prim: .timestamp))
                ]
            ),
        ]
    }

    private var packedWithBytesAndSchemas: [TestCase<Micheline.Literal.Bytes>] {
        [
            .init(
                packed: "050a00000000",
                valuesWithSchemas: [
                    (try! .init("0x"), nil),
                    (try! .init("0x"), .comparableType(prim: .bytes))
                ]
            ),
            .init(
                packed: "050a0000000100",
                valuesWithSchemas: [
                    (try! .init("0x00"), nil),
                    (try! .init("0x00"), .comparableType(prim: .bytes))
                ]
            ),
            .init(
                packed: "050a000000049434dc98",
                valuesWithSchemas: [
                    (try! .init("0x9434dc98"), nil),
                    (try! .init("0x9434dc98"), .comparableType(prim: .bytes))
                ]
            ),
            .init(
                packed: "050a000000047b1ea2cb",
                valuesWithSchemas: [
                    (try! .init("0x7b1ea2cb"), nil),
                    (try! .init("0x7b1ea2cb"), .comparableType(prim: .bytes))
                ]
            ),
            .init(
                packed: "050a00000004e40476d7",
                valuesWithSchemas: [
                    (try! .init("0xe40476d7"), nil),
                    (try! .init("0xe40476d7"), .comparableType(prim: .bytes))
                ]
            ),
            .init(
                packed: "050a00000006c47320abdd31",
                valuesWithSchemas: [
                    (try! .init("0xc47320abdd31"), nil),
                    (try! .init("0xc47320abdd31"), .comparableType(prim: .bytes))
                ]
            ),
            .init(
                packed: "050a000000065786dac9eaf4",
                valuesWithSchemas: [
                    (try! .init("0x5786dac9eaf4"), nil),
                    (try! .init("0x5786dac9eaf4"), .comparableType(prim: .bytes))
                ]
            ),
        ]
    }

    private var packedWithPrimitiveApplicationsAndSchemas: [TestCase<Micheline.PrimitiveApplication>] {
        [
            .init(
                packed: "050500036c",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .type(.parameter),
                            args: [
                                .comparableType(prim: .unit),
                            ]
                        ),
                        nil
                    )
                ]
            ),
            .init(
                packed: "050600036c0000000a25706172616d65746572",
                valuesWithSchemas: [
                    (
                        try! .init(
                            prim: .type(.parameter),
                            args: [
                                .comparableType(prim: .unit),
                            ],
                            annots: ["%parameter"]
                        ),
                        nil
                    )
                ]
            ),
            .init(
                packed: "050501036c",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .type(.storage),
                            args: [
                                .comparableType(prim: .unit),
                            ]
                        ),
                        nil
                    )
                ]
            ),
            .init(
                packed: "050502034f",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .type(.code),
                            args: [
                                .instruction(prim: .unit)
                            ]
                        ),
                        nil
                    )
                ]
            ),
            .init(
                packed: "050303",
                valuesWithSchemas: [
                    (.init(prim: .data(.false)), nil),
                    (.init(prim: .data(.false)), .comparableType(prim: .bool))
                ]
            ),
            .init(
                packed: "050704030b030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.elt),
                            args: [
                                .data(prim: .unit),
                                .data(prim: .unit)
                            ]
                        ),
                        nil
                    )
                ]
            ),
            .init(
                packed: "050505030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.left),
                            args: [
                                .data(prim: .unit)
                            ]
                        ),
                        nil
                    ),
                    (
                        .init(
                            prim: .data(.left),
                            args: [
                                .data(prim: .unit)
                            ]
                        ),
                        .comparableType(
                            prim: .or,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .bool)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "0505050707030b0707030b030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.left),
                            args: [
                                .data(
                                    prim: .pair,
                                    args: [
                                        .data(prim: .unit),
                                        .data(prim: .unit),
                                        .data(prim: .unit)
                                    ]
                                )
                            ]
                        ),
                        .comparableType(
                            prim: .or,
                            args: [
                                .comparableType(
                                    prim: .pair,
                                    args: [
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit)
                                    ]
                                ),
                                .comparableType(prim: .bool)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050306",
                valuesWithSchemas: [
                    (
                        .init(prim: .data(.none)),
                        nil
                    ),
                    (
                        .init(prim: .data(.none)),
                        .comparableType(
                            prim: .option,
                            args: [
                                .comparableType(prim: .unit),
                            ]
                        )
                    ),
                    (
                        .init(prim: .data(.none)),
                        .comparableType(
                            prim: .option,
                            args: [
                                .comparableType(
                                    prim: .pair,
                                    args: [
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit)
                                    ]
                                )
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050303",
                valuesWithSchemas: [
                    (
                        .init(prim: .data(.false)),
                        nil
                    ),
                    (
                        .init(prim: .data(.false)),
                        .comparableType(prim: .bool)
                    )
                ]
            ),
            .init(
                packed: "050707030b030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.pair),
                            args: [
                                .data(prim: .unit),
                                .data(prim: .unit)
                            ]
                        ),
                        nil
                    ),
                    (
                        .init(
                            prim: .data(.pair),
                            args: [
                                .data(prim: .unit),
                                .data(prim: .unit)
                            ]
                        ),
                        .comparableType(
                            prim: .pair,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050707030b0707030b030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.pair),
                            args: [
                                .data(prim: .unit),
                                .data(prim: .unit),
                                .data(prim: .unit)
                            ]
                        ),
                        .comparableType(
                            prim: .pair,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050508030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.right),
                            args: [
                                .data(prim: .unit)
                            ]
                        ),
                        nil
                    ),
                    (
                        .init(
                            prim: .data(.right),
                            args: [
                                .data(prim: .unit)
                            ]
                        ),
                        .comparableType(
                            prim: .or,
                            args: [
                                .comparableType(prim: .bool),
                                .comparableType(prim: .unit)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "0505080707030b0707030b030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.right),
                            args: [
                                .data(
                                    prim: .pair,
                                    args: [
                                        .data(prim: .unit),
                                        .data(prim: .unit),
                                        .data(prim: .unit)
                                    ]
                                )
                            ]
                        ),
                        .comparableType(
                            prim: .or,
                            args: [
                                .comparableType(prim: .bool),
                                .comparableType(
                                    prim: .pair,
                                    args: [
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit)
                                    ]
                                )
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050509030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.some),
                            args: [
                                .data(prim: .unit)
                            ]
                        ),
                        nil
                    ),
                    (
                        .init(
                            prim: .data(.some),
                            args: [
                                .data(prim: .unit)
                            ]
                        ),
                        .comparableType(
                            prim: .option,
                            args: [
                                .comparableType(prim: .unit)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "0505090707030b0707030b030b",
                valuesWithSchemas: [
                    (
                        .init(
                            prim: .data(.some),
                            args: [
                                .data(
                                    prim: .pair,
                                    args: [
                                        .data(prim: .unit),
                                        .data(prim: .unit),
                                        .data(prim: .unit)
                                    ]
                                )
                            ]
                        ),
                        .comparableType(
                            prim: .option,
                            args: [
                                .comparableType(
                                    prim: .pair,
                                    args: [
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit),
                                        .comparableType(prim: .unit)
                                    ]
                                )
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "05030a",
                valuesWithSchemas: [
                    (.init(prim: .data(.true)), nil),
                    (.init(prim: .data(.true)), .comparableType(prim: .bool))
                ]
            ),
            .init(
                packed: "05030b",
                valuesWithSchemas: [
                    (.init(prim: .data(.unit)), nil),
                    (.init(prim: .data(.unit)), .comparableType(prim: .unit))
                ]
            ),
        ]
    }

    private var packedWithSequencesAndSchemas: [TestCase<Micheline.Sequence>] {
        [
            .init(
                packed: "050200000000",
                valuesWithSchemas: [
                    ([], nil),
                    ([], .sequence([])),
                ]
            ),
            .init(
                packed: "0502000000020000",
                valuesWithSchemas: [
                    (
                        [
                            .int(0)
                        ],
                        nil
                    ),
                    (
                        [
                            .int(0)
                        ],
                        .sequence([
                            .comparableType(prim: .int)
                        ])
                    )
                ]
            ),
            .init(
                packed: "05020000000a00000100000003616263",
                valuesWithSchemas: [
                    (
                        [
                            .int(0),
                            try! .string("abc")
                        ],
                        nil
                    ),
                    (
                        [
                            .int(0),
                            try! .string("abc")
                        ],
                        .sequence([
                            .comparableType(prim: .int),
                            .comparableType(prim: .string)
                        ])
                    )
                ]
            ),
            .init(
                packed: "050200000006030b030b030b",
                valuesWithSchemas: [
                    (
                        [
                            .data(prim: .unit),
                            .data(prim: .unit),
                            .data(prim: .unit),
                        ],
                        .type(
                            prim: .list,
                            args: [
                                .comparableType(prim: .unit)
                            ]
                        )
                    ),
                    (
                        [
                            .data(prim: .unit),
                            .data(prim: .unit),
                            .data(prim: .unit),
                        ],
                        .type(
                            prim: .set,
                            args: [
                                .comparableType(prim: .unit)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "0502000000060704030b030b",
                valuesWithSchemas: [
                    (
                        [
                            .data(
                                prim: .elt,
                                args: [
                                    .data(prim: .unit),
                                    .data(prim: .unit)
                                ]
                            ),
                        ],
                        .type(
                            prim: .map,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit)
                            ]
                        )
                    ),
                    (
                        [
                            .data(
                                prim: .elt,
                                args: [
                                    .data(prim: .unit),
                                    .data(prim: .unit)
                                ]
                            ),
                        ],
                        .type(
                            prim: .bigMap,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit)
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050200000002030c",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(prim: .pack)
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(prim: .pack)
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit),
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "0502000000070200000002030c",
                valuesWithSchemas: [
                    (
                        [
                            .sequence([
                                .instruction(prim: .pack)
                            ])
                        ],
                        nil
                    ),
                    (
                        [
                            .sequence([
                                .instruction(prim: .pack)
                            ])
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit),
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050200000009051f0200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .dip,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .dip,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050200000010072c0200000002034f0200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .if,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .if,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050200000010072d0200000002034f0200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .ifCons,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .ifCons,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050200000010072e0200000002034f0200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .ifLeft,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .ifLeft,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050200000010072f0200000002034f0200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .ifNone,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .ifNone,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ]),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "05020000001509310000000b036c036c0200000002034f00000000",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .lambda,
                                args: [
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .lambda,
                                args: [
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "05020000000905340200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .loop,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .loop,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "05020000000905380200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .map,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .map,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "05020000000905520200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .iter,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .iter,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "05020000000905530200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .loopLeft,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .loopLeft,
                                args: [
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .sequence([
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                ])
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "05020000000f0743075e036c036c0200000002034f",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .push,
                                args: [
                                    .type(
                                        prim: .lambda,
                                        args: [
                                            .comparableType(prim: .unit),
                                            .comparableType(prim: .unit),
                                        ]
                                    ),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .push,
                                args: [
                                    .type(
                                        prim: .lambda,
                                        args: [
                                            .comparableType(prim: .unit),
                                            .comparableType(prim: .unit),
                                        ]
                                    ),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit),
                            ]
                        )
                    )
                ]
            ),
            .init(
                packed: "050200000015091d0000000b036c036c0200000002034f00000000",
                valuesWithSchemas: [
                    (
                        [
                            .instruction(
                                prim: .createContract,
                                args: [
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        nil
                    ),
                    (
                        [
                            .instruction(
                                prim: .createContract,
                                args: [
                                    .comparableType(prim: .unit),
                                    .comparableType(prim: .unit),
                                    .sequence([
                                        .instruction(prim: .unit)
                                    ])
                                ]
                            )
                        ],
                        .type(
                            prim: .lambda,
                            args: [
                                .comparableType(prim: .unit),
                                .comparableType(prim: .unit),
                            ]
                        )
                    )
                ]
            )
        ]
    }

    private var invalidPrimitiveApplicationsWithSchema: [(Micheline.PrimitiveApplication, Micheline?)] {
        [(try! .init(prim: "unknown"), nil)]
    }

    private var invalidPackedWithSchema: [(String, Micheline?)] {
        [
            ("00", nil),
            ("00020000000f0743075e036c036c0200000002034f", .type(
                prim: .lambda,
                args: [
                    .comparableType(prim: .unit),
                    .comparableType(prim: .unit),
                ]
            )),
            ("050743075e036c036c0200000002034f", .type(
                prim: .lambda,
                args: [
                    .comparableType(prim: .unit),
                    .comparableType(prim: .unit),
                ]
            ))
        ]
    }

    private var packedWithInvalidSchema: [(String, Micheline?)] {
        [
            ("050100000000", .literal(
                .integer(.init(1))
            )),
            ("0500aff8aff1ce5f", .comparableType(
                prim: .option,
                args: [
                    .comparableType(prim: .unit)
                ]
            )),
            ("050041", .comparableType(
                prim: .option,
                args: [
                    .comparableType(prim: .unit)
                ]
            )),
            ("0500aff8aff1ce5f", .comparableType(
                prim: .pair,
                args: [
                    .comparableType(prim: .unit),
                    .comparableType(prim: .unit)
                ]
            )),
            ("050041", .comparableType(
                prim: .pair,
                args: [
                    .comparableType(prim: .unit),
                    .comparableType(prim: .unit)
                ]
            )),
        ]
    }
}

private struct TestCase<Value> {
    let packed: [UInt8]
    let valuesWithSchemas: [(Value, Micheline?)]
    
    init(packed: [UInt8], valuesWithSchemas: [(Value, Micheline?)]) {
        self.packed = packed
        self.valuesWithSchemas = valuesWithSchemas
    }
    
    init(packed: String, valuesWithSchemas: [(Value, Micheline?)]) {
        self.init(packed: [UInt8](from: try! HexString(from: packed)), valuesWithSchemas: valuesWithSchemas)
    }
}

private extension TestCase where Value == Micheline.Literal.Integer {
    func wrapped() -> TestCase<Micheline.Literal> {
        TestCase<Micheline.Literal>(packed: packed, valuesWithSchemas: valuesWithSchemas.map({ (.integer($0.0), $0.1) }))
    }
}

private extension TestCase where Value == Micheline.Literal.String {
    func wrapped() -> TestCase<Micheline.Literal> {
        TestCase<Micheline.Literal>(packed: packed, valuesWithSchemas: valuesWithSchemas.map({ (.string($0.0), $0.1) }))
    }
}

private extension TestCase where Value == Micheline.Literal.Bytes {
    func wrapped() -> TestCase<Micheline.Literal> {
        TestCase<Micheline.Literal>(packed: packed, valuesWithSchemas: valuesWithSchemas.map({ (.bytes($0.0), $0.1) }))
    }
}

private extension TestCase where Value == Micheline.Literal {
    func wrapped() -> TestCase<Micheline> {
        TestCase<Micheline>(packed: packed, valuesWithSchemas: valuesWithSchemas.map({ (.literal($0.0), $0.1) }))
    }
}

private extension TestCase where Value == Micheline.PrimitiveApplication {
    func wrapped() -> TestCase<Micheline> {
        TestCase<Micheline>(packed: packed, valuesWithSchemas: valuesWithSchemas.map({ (.prim($0.0), $0.1) }))
    }
}

private extension TestCase where Value == Micheline.Sequence {
    func wrapped() -> TestCase<Micheline> {
        TestCase<Micheline>(packed: packed, valuesWithSchemas: valuesWithSchemas.map({ (.sequence($0.0), $0.1) }))
    }
}

private extension Array {
    func wrapped() -> [TestCase<Micheline.Literal>] where Element == TestCase<Micheline.Literal.Integer> {
        map { $0.wrapped() }
    }
    
    func wrapped() -> [TestCase<Micheline.Literal>] where Element == TestCase<Micheline.Literal.String> {
        map { $0.wrapped() }
    }
    
    func wrapped() -> [TestCase<Micheline.Literal>] where Element == TestCase<Micheline.Literal.Bytes> {
        map { $0.wrapped() }
    }
    
    func wrapped() -> [TestCase<Micheline>] where Element == TestCase<Micheline.Literal> {
        map { $0.wrapped() }
    }
    
    func wrapped() -> [TestCase<Micheline>] where Element == TestCase<Micheline.PrimitiveApplication> {
        map { $0.wrapped() }
    }
    
    func wrapped() -> [TestCase<Micheline>] where Element == TestCase<Micheline.Sequence> {
        map { $0.wrapped() }
    }
}
