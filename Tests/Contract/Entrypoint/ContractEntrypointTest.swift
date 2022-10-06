//
//  ContractEntrypointTest.swift
//  
//
//  Created by Julia Samol on 28.07.22.
//

import XCTest

@testable import TezosContract
@testable import TezosCore
@testable import TezosMichelson
@testable import TezosOperation
@testable import TezosRPC

class ContractEntrypointTest: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testCreatesUnsignedOperationWithRawParameters() async throws {
        let source = try! Ed25519PublicKeyHash(base58: "tz1ZSs43ujit1oRsVn67Asz3pTMF8R6CXWPi")
        let branch = try! BlockHash(base58: "BLkKavdWXZdfEXmup3FQKCrPJXTrVGfrbLhgBE3UU3SvyztZHHh")
        let counter = "1"
        
        let block = BlockMock(branch: branch, counter: counter)
        let feeEstimator = OperationFeeEstimatorMock()
        
        for testCase in testCases {
            let contractEntrypoint = ContractEntrypoint(
                from: .init { _ in testCase.type },
                entrypoint: .init(from: testCase.name),
                contractAddress: testCase.contractAddress,
                block: block,
                feeEstimator: feeEstimator
            )
            
            let actual = try await contractEntrypoint(source: source.asImplicitAddress(), parameters: testCase.value)
            let expected = TezosOperation.Unsigned(
                branch: branch,
                contents: [
                    .transaction(.init(
                        source: source.asImplicitAddress(),
                        fee: .zero,
                        counter: try! .init(counter),
                        gasLimit: .zero,
                        storageLimit: .zero,
                        amount: .zero,
                        destination: testCase.contractAddress.asAddress(),
                        parameters: .init(
                            entrypoint: .init(from: testCase.name),
                            value: testCase.value
                        )
                    ))
                ]
            )
            
            XCTAssertEqual(actual, expected)
        }
    }
    
    func testCreatesUnsignedOperationWithNamedParameters() async throws {
        let source = try! Ed25519PublicKeyHash(base58: "tz1ZSs43ujit1oRsVn67Asz3pTMF8R6CXWPi")
        let branch = try! BlockHash(base58: "BLkKavdWXZdfEXmup3FQKCrPJXTrVGfrbLhgBE3UU3SvyztZHHh")
        let counter = "1"
        
        let block = BlockMock(branch: branch, counter: counter)
        let feeEstimator = OperationFeeEstimatorMock()
        
        for testCase in testCases {
            let contractEntrypoint = ContractEntrypoint(
                from: .init { _ in testCase.type },
                entrypoint: .init(from: testCase.name),
                contractAddress: testCase.contractAddress,
                block: block,
                feeEstimator: feeEstimator
            )
            
            let actual = try await contractEntrypoint(source: source.asImplicitAddress(), parameters: testCase.namedValue)
            let expected = TezosOperation.Unsigned(
                branch: branch,
                contents: [
                    .transaction(.init(
                        source: source.asImplicitAddress(),
                        fee: .zero,
                        counter: try! .init(counter),
                        gasLimit: .zero,
                        storageLimit: .zero,
                        amount: .zero,
                        destination: testCase.contractAddress.asAddress(),
                        parameters: .init(
                            entrypoint: .init(from: testCase.name),
                            value: testCase.value
                        )
                    ))
                ]
            )
            
            XCTAssertEqual(actual, expected)
        }
    }
    
    private var testCases: [EntrypointTestCase] {
        [
            .init {
                let name = "test_entrypoint1"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")
                
                let type: Micheline = .comparableType(
                    prim: .pair,
                    args: [
                        .comparableType(
                            prim: .pair,
                            args: [
                                try! .comparableType(
                                    prim: .option,
                                    args: [
                                        .comparableType(prim: .address)
                                    ],
                                    annots: ["%address"]
                                ),
                                .comparableType(
                                    prim: .pair,
                                    args: [
                                        try! .comparableType(prim: .bytes, annots: ["%label"]),
                                        try! .comparableType(prim: .address, annots: ["%owner"])
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
                                        try! .comparableType(prim: .bytes, annots: ["%parent"]),
                                        try! .comparableType(prim: .nat, annots: ["%ttl"])
                                    ]
                                )
                            ]
                        )
                    ]
                )
                
                let value: Micheline = .data(
                    prim: .pair,
                    args: [
                        .data(
                            prim: .pair,
                            args: [
                                .data(
                                    prim: .some,
                                    args: [
                                        try! .string("tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")
                                    ]
                                ),
                                .data(
                                    prim: .pair,
                                    args: [
                                        try! .bytes("0x0000a7848de3b1fce76a7ffce2c7ce40e46be33aed7c"),
                                        try! .string("tz1b6wRXMA2PxATL6aoVGy9j7kSqXijW7VPq")
                                    ]
                                )
                            ]
                        ),
                        .data(
                            prim: .some,
                            args: [
                                .data(
                                    prim: .pair,
                                    args: [
                                        try! .bytes("0x0b51b8ae90e19a079c9db469c4881871a5ba7778acf9773ac00c7dfcda0b1c87"),
                                        .int(1)
                                    ]
                                )
                            ]
                        )
                    ]
                )
                
                let namedValue: ContractEntrypointParameter = .object(.init(
                    .value(.init(.literal(.string(try! .init("tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))), name: "%address")),
                    .value(.init(.literal(.bytes(try! .init("0x0000a7848de3b1fce76a7ffce2c7ce40e46be33aed7c"))), name: "%label")),
                    .value(.init(.literal(.string(try! .init("tz1b6wRXMA2PxATL6aoVGy9j7kSqXijW7VPq"))), name: "%owner")),
                    .value(.init(.literal(.bytes(try! .init("0x0b51b8ae90e19a079c9db469c4881871a5ba7778acf9773ac00c7dfcda0b1c87"))), name: "%parent")),
                    .value(.init(.literal(.integer(.init(1))), name: "%ttl"))
                ))
                
                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint2"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")
                
                let type: Micheline = .comparableType(
                    prim: .pair,
                    args: [
                        .comparableType(
                            prim: .pair,
                            args: [
                                .comparableType(
                                    prim: .pair,
                                    args: [
                                        try! .comparableType(
                                            prim: .option,
                                            args: [
                                                .comparableType(prim: .address)
                                            ],
                                            annots: ["%address"]
                                        ),
                                        try! .type(
                                            prim: .map,
                                            args: [
                                                .comparableType(prim: .string),
                                                .comparableType(
                                                    prim: .or,
                                                    args: [
                                                        .comparableType(
                                                            prim: .or,
                                                            args: [
                                                                .comparableType(
                                                                    prim: .or,
                                                                    args: [
                                                                        .comparableType(
                                                                            prim: .or,
                                                                            args: [
                                                                                try! .comparableType(prim: .address, annots: ["%address"]),
                                                                                try! .comparableType(prim: .bool, annots: ["%bool"])
                                                                            ]
                                                                        ),
                                                                        .comparableType(
                                                                            prim: .or,
                                                                            args: [
                                                                                try! .comparableType(prim: .bytes, annots: ["%bytes"]),
                                                                                try! .comparableType(prim: .int, annots: ["%int"])
                                                                            ]
                                                                        )
                                                                    ]
                                                                ),
                                                                .comparableType(
                                                                    prim: .or,
                                                                    args: [
                                                                        .comparableType(
                                                                            prim: .or,
                                                                            args: [
                                                                                try! .comparableType(prim: .key, annots: ["%key"]),
                                                                                try! .comparableType(prim: .keyHash, annots: ["%key_hash"])
                                                                            ]
                                                                        ),
                                                                        .comparableType(
                                                                            prim: .or,
                                                                            args: [
                                                                                try! .comparableType(prim: .nat, annots: ["%nat"]),
                                                                                try! .comparableType(prim: .signature, annots: ["%signature"])
                                                                            ]
                                                                        )
                                                                    ]
                                                                )
                                                            ]
                                                        ),
                                                        .comparableType(
                                                            prim: .or,
                                                            args: [
                                                                .comparableType(
                                                                    prim: .or,
                                                                    args: [
                                                                        try! .comparableType(prim: .string, annots: ["%string"]),
                                                                        try! .comparableType(prim: .mutez, annots: ["%tez"])
                                                                    ]
                                                                ),
                                                                try! .comparableType(prim: .timestamp, annots: ["%timestamp"])
                                                            ]
                                                        )
                                                    ]
                                                )
                                            ],
                                            annots: ["%data"]
                                        )
                                    ]
                                ),
                                .comparableType(
                                    prim: .pair,
                                    args: [
                                        try! .comparableType(prim: .bytes, annots: ["%label"]),
                                        try! .comparableType(prim: .address, annots: ["%owner"])
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
                                        try! .comparableType(prim: .bytes, annots: ["%parent"]),
                                        try! .comparableType(prim: .nat, annots: ["%ttl"])
                                    ]
                                )
                            ]
                        )
                    ]
                )
                
                let value: Micheline = .data(
                    prim: .pair,
                    args: [
                        .data(
                            prim: .pair,
                            args: [
                                .data(
                                    prim: .pair,
                                    args: [
                                        .data(
                                            prim: .some,
                                            args: [
                                                try! .string("tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")
                                            ]
                                        ),
                                        .sequence([
                                            .data(
                                                prim: .elt,
                                                args: [
                                                    try! .string("key1"),
                                                    .data(
                                                        prim: .left,
                                                        args: [
                                                            .data(
                                                                prim: .left,
                                                                args: [
                                                                    .data(
                                                                        prim: .left,
                                                                        args: [
                                                                            .data(
                                                                                prim: .right,
                                                                                args: [
                                                                                    .data(prim: .true)
                                                                                ]
                                                                            )
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                                ]
                                            ),
                                            .data(
                                                prim: .elt,
                                                args: [
                                                    try! .string("key2"),
                                                    .data(
                                                        prim: .left,
                                                        args: [
                                                            .data(
                                                                prim: .right,
                                                                args: [
                                                                    .data(
                                                                        prim: .right,
                                                                        args: [
                                                                            .data(
                                                                                prim: .left,
                                                                                args: [
                                                                                    .int(1)
                                                                                ]
                                                                            )
                                                                        ]
                                                                    )
                                                                ]
                                                            )
                                                        ]
                                                    )
                                                ]
                                            )
                                        ])
                                    ]
                                ),
                                .data(
                                    prim: .pair,
                                    args: [
                                        try! .bytes("0x0000a7848de3b1fce76a7ffce2c7ce40e46be33aed7c"),
                                        try! .string("tz1b6wRXMA2PxATL6aoVGy9j7kSqXijW7VPq")
                                    ]
                                )
                            ]
                        ),
                        .data(
                            prim: .some,
                            args: [
                                .data(
                                    prim: .pair,
                                    args: [
                                        try! .bytes("0x0b51b8ae90e19a079c9db469c4881871a5ba7778acf9773ac00c7dfcda0b1c87"),
                                        .int(2)
                                    ]
                                )
                            ]
                        )
                    ]
                )
                
                let namedValue: ContractEntrypointParameter = .object(.init(
                    .value(.init(try! .string("tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"), name: "%address")),
                    .map(.init(
                        [
                            .value(.init(try! .string("key1"))): .value(.init(.data(prim: .true), name: "%bool")),
                            .value(.init(try! .string("key2"))): .value(.init(.int(1), name: "%nat")),
                        ],
                        name: "%data"
                    )),
                    .value(.init(try! .bytes("0x0000a7848de3b1fce76a7ffce2c7ce40e46be33aed7c"), name: "%label")),
                    .value(.init(try! .string("tz1b6wRXMA2PxATL6aoVGy9j7kSqXijW7VPq"), name: "%owner")),
                    .value(.init(try! .bytes("0x0b51b8ae90e19a079c9db469c4881871a5ba7778acf9773ac00c7dfcda0b1c87"), name: "%parent")),
                    .value(.init(.int(2), name: "%ttl"))
                ))
                
                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint3"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")
                
                let type: Micheline = try! .comparableType(prim: .nat, annots: ["%current_version"])
                let value: Micheline = .int(1)
                
                let namedValue: ContractEntrypointParameter = .value(.init(.int(1)))
                
                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint4"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")
                
                let type: Micheline = try! .comparableType(prim: .nat, annots: ["%current_version"])
                let value: Micheline = .int(1)
                
                let namedValue: ContractEntrypointParameter = .value(.init(.int(1), name: "%current_version"))
                
                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint5"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")
                
                let type: Micheline = try! .comparableType(prim: .nat, annots: ["%current_version"])
                let value: Micheline = .int(1)
                
                let namedValue: ContractEntrypointParameter = .object(.init(
                    .value(.init(.int(1), name: "%current_version"))
                ))
                
                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint6"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")
                
                let type: Micheline = .comparableType(
                    prim: .pair,
                    args: [
                        try! .comparableType(
                            prim: .nat,
                            annots: ["%value"]
                        ),
                        try! .comparableType(
                            prim: .pair,
                            args: [
                                .comparableType(prim: .nat),
                                .comparableType(prim: .nat),
                            ],
                            annots: ["%data"]
                        )
                    ]
                )
                
                let value: Micheline = .data(
                    prim: .pair,
                    args: [
                        .int(1),
                        .data(
                            prim: .pair,
                            args: [
                                .int(2),
                                .int(3)
                            ]
                        )
                    ]
                )
                
                let namedValue: ContractEntrypointParameter = .object(.init(
                    .value(.init(.int(1), name: "%value")),
                    .object(.init(
                        .value(.init(.int(2))),
                        .value(.init(.int(3))),
                        name: "%data"
                    ))
                ))
                
                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint7"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")

                let type: Micheline = .type(
                    prim: .list,
                    args: [
                        .comparableType(
                            prim: .pair,
                            args: [
                                try! .comparableType(prim: .nat, annots: ["%first"]),
                                try! .comparableType(prim: .nat, annots: ["%second"])
                            ]
                        )
                    ]
                )

                let value: Micheline = .sequence([
                    .data(
                        prim: .pair,
                        args: [
                            .int(1),
                            .int(2)
                        ]
                    ),
                    .data(
                        prim: .pair,
                        args: [
                            .int(3),
                            .int(4)
                        ]
                    )
                ])

                let namedValue: ContractEntrypointParameter = .sequence(.init(
                    .object(.init(
                        .value(.init(.int(1), name: "%first")),
                        .value(.init(.int(2), name: "%second"))
                    )),
                    .object(.init(
                        .value(.init(.int(3), name: "%first")),
                        .value(.init(.int(4), name: "%second"))
                    ))
                ))

                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint8"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")

                let type: Micheline = .type(
                    prim: .list,
                    args: [
                        .comparableType(
                            prim: .pair,
                            args: [
                                try! .comparableType(prim: .nat, annots: ["%first"]),
                                try! .comparableType(prim: .nat, annots: ["%second"])
                            ]
                        )
                    ]
                )

                let value: Micheline = .sequence([
                    .data(
                        prim: .pair,
                        args: [
                            .int(1),
                            .int(2)
                        ]
                    ),
                    .data(
                        prim: .pair,
                        args: [
                            .int(3),
                            .int(4)
                        ]
                    )
                ])

                let namedValue: ContractEntrypointParameter = .object(.init(
                    .sequence(.init(
                        .object(.init(
                            .value(.init(.int(1), name: "%first")),
                            .value(.init(.int(2), name: "%second"))
                        )),
                        .object(.init(
                            .value(.init(.int(3), name: "%first")),
                            .value(.init(.int(4), name: "%second"))
                        ))
                    ))
                ))

                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint9"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")

                let type: Micheline = .type(
                    prim: .map,
                    args: [
                        .comparableType(prim: .string),
                        .comparableType(prim: .nat)
                    ]
                )

                let value: Micheline = .sequence([
                    .data(
                        prim: .elt,
                        args: [
                            try! .string("first"),
                            .int(1)
                        ]
                    ),
                    .data(
                        prim: .elt,
                        args: [
                            try! .string("second"),
                            .int(2)
                        ]
                    )
                ])

                let namedValue: ContractEntrypointParameter = .map(.init([
                    .value(.init(try! .string("first"))): .value(.init(.int(1))),
                    .value(.init(try! .string("second"))): .value(.init(.int(2))),
                ]))

                return (name, contractAddress, type, value, namedValue)
            },
            .init {
                let name = "test_entrypoint10"
                let contractAddress = try! ContractHash(base58: "KT1ScmSVNZoC73zdn8Vevkit6wzbTr4aXYtc")

                let type: Micheline = .type(
                    prim: .map,
                    args: [
                        .comparableType(prim: .string),
                        .comparableType(prim: .nat)
                    ]
                )

                let value: Micheline = .sequence([
                    .data(
                        prim: .elt,
                        args: [
                            try! .string("first"),
                            .int(1)
                        ]
                    ),
                    .data(
                        prim: .elt,
                        args: [
                            try! .string("second"),
                            .int(2)
                        ]
                    )
                ])

                let namedValue: ContractEntrypointParameter = .object(.init(
                    .map(.init([
                        .value(.init(try! .string("first"))): .value(.init(.int(1))),
                        .value(.init(try! .string("second"))): .value(.init(.int(2))),
                    ]))
                ))

                return (name, contractAddress, type, value, namedValue)
            }
        ]
    }
    
    private struct EntrypointTestCase {
        let name: String
        let contractAddress: ContractHash
        let type: Micheline
        let value: Micheline
        let namedValue: ContractEntrypointParameter
        
        init(
            name: String,
            contractAddress: ContractHash,
            type: Micheline,
            value: Micheline,
            namedValue: ContractEntrypointParameter
        ) {
            self.name = name
            self.contractAddress = contractAddress
            self.type = type
            self.value = value
            self.namedValue = namedValue
            
        }
        
        init(_ builder: () -> (String, ContractHash, Micheline, Micheline, ContractEntrypointParameter)) {
            let (name, contractAddress, type, value, namedValue) = builder()
            self.init(name: name, contractAddress: contractAddress, type: type, value: value, namedValue: namedValue)
        }
    }
    
    private struct BlockMock: Block {
        let context: BlockContextMock
        let header: BlockHeaderMock
        
        init(branch: BlockHash, counter: String) {
            self.context = .init(counter: counter)
            self.header = .init(hash: branch)
        }
        
        func get(configuredWith configuration: BlockGetConfiguration) async throws -> RPCBlock { fatalError("Not implemented") }
        
        var helpers: BlockHelpersClient<HTTPMock> { fatalError("Not implemented") }
        var operations: BlockOperationsClient<HTTPMock> { fatalError("Not implemented") }
    }
    
    private struct BlockContextMock: BlockContext {
        let contracts: BlockContextContractsMock
        
        init(counter: String) {
            self.contracts = .init(counter: counter)
        }
        
        var bigMaps: BlockContextBigMapsClient<HTTPMock> { fatalError("Not implemented") }
        var constants: BlockContextConstantsClient<HTTPMock> { fatalError("Not implemented") }
        var delegates: BlockContextDelegatesClient<HTTPMock> { fatalError("Not implemented") }
        var sapling: BlockContextSaplingClient<HTTPMock> { fatalError("Not implemented") }
    }
    
    private struct BlockContextContractsMock: BlockContextContracts {
        let counter: String
        
        func callAsFunction(contractID: Address) -> BlockContextContractsContractMock {
            .init(counter: counter)
        }
    }
    
    private struct BlockContextContractsContractMock: BlockContextContractsContract {
        let counter: BlockContextContractsContractCounterMock
        
        init(counter: String) {
            self.counter = .init(counter: counter)
        }
        
        func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws -> RPCContractDetails { fatalError("Not implemented") }
        
        var balance: BlockContextContractsContractBalanceClient<HTTPMock> { fatalError("Not implemented") }
        var delegate: BlockContextContractsContractDelegateClient<HTTPMock> { fatalError("Not implemented") }
        var entrypoints: BlockContextContractsContractEntrypointsClient<HTTPMock> { fatalError("Not implemented") }
        var managerKey: BlockContextContractsContractManagerKeyClient<HTTPMock> { fatalError("Not implemented") }
        var script: BlockContextContractsContractScriptClient<HTTPMock> { fatalError("Not implemented") }
        var singleSaplingGetDiff: BlockContextContractsContractSingleSaplingGetDiffClient<HTTPMock> { fatalError("Not implemented") }
        var storage: BlockContextContractsContractStorageClient<HTTPMock> { fatalError("Not implemented") }
    }
    
    private struct BlockContextContractsContractCounterMock: BlockContextContractsContractCounter {
        let counter: String
        
        func get(configuredWith configuration: BlockContextContractsContractCounterGetConfiguration) async throws -> String? {
            counter
        }
    }
    
    private struct BlockHeaderMock: BlockHeader {
        let hash: BlockHash
        
        func get(configuredWith configuration: BlockHeaderGetConfiguration) async throws -> RPCFullBlockHeader {
            .init(
                protocol: try! .init(base58: "PtARwRL7jEGtzoCCWDBXe6ZJ4ZJiWtDgBC2a5WwnHYYyKPdmwrb"),
                chainID: try! .init(base58: "NetXy3eo3jtuwuc"),
                hash: hash,
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
                proofOfWorkNonce: "d4d34b5686c98ae1",
                seedNonceHash: nil,
                liquidityBakingToggleVote: .on,
                signature: .sig(try! .init(base58: "sigiaEd9dHEGKgccx3JBBDw4eb6WVxGH3MvyziYbQqWQRMmyecdo5VuSkYWkgZvcQXshB4vV2qkTb6AxbKruaNPfnMg4u2EA"))
            )
        }
    }
    
    private struct OperationFeeEstimatorMock: FeeEstimator {
        func minFee(chainID: RPCChainID, operation: TezosOperation, configuredWith configuration: MinFeeConfiguration) async throws -> TezosOperation {
            operation
        }
    }
    
    private struct HTTPMock: HTTP {
        func delete<Response: Decodable>(baseURL: URL, endpoint: String, headers: [HTTPHeader], parameters: [HTTPParameter]) async throws -> Response { fatalError("Not implemented") }
        func get<Response: Decodable>(baseURL: URL, endpoint: String, headers: [HTTPHeader], parameters: [HTTPParameter]) async throws -> Response { fatalError("Not implemented") }
        func patch<Request: Encodable, Response: Decodable>(baseURL: URL, endpoint: String, headers: [HTTPHeader], parameters: [HTTPParameter], request: Request?) async throws -> Response { fatalError("Not implemented") }
        func post<Request: Encodable, Response: Decodable>(baseURL: URL, endpoint: String, headers: [HTTPHeader], parameters: [HTTPParameter], request: Request?) async throws -> Response { fatalError("Not implemented") }
        func put<Request: Encodable, Response: Decodable>(baseURL: URL, endpoint: String, headers: [HTTPHeader], parameters: [HTTPParameter], request: Request?) async throws -> Response { fatalError("Not implemented") }
    }
}
