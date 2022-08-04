//
//  ContractStorageTest.swift
//  
//
//  Created by Julia Samol on 21.07.22.
//

import XCTest

@testable import TezosContract
@testable import TezosCore
@testable import TezosMichelson
@testable import TezosOperation
@testable import TezosRPC

class ContractStorageTest: XCTestCase {
    
    private let nodeURL: URL = .init(string: "http://node.com")!

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testCreatesContractStorageEntryFromStorageValues() async throws {
        for testCase in testCases {
            let contractRPC = BlockContextContractsContractMock(value: testCase.value)
            let contractStorage = ContractStorage(
                from: .init { _ in
                    .init(
                        parameter: .sequence([]),
                        storage: .type(prim: .storage, args: [testCase.type]),
                        code: .sequence([])
                    )
                },
                contract: contractRPC,
                nodeURL: nodeURL
            )
            
            let actual = try await contractStorage.get()
            
            XCTAssertEqual(actual, testCase.entry)
        }
    }
    
    private var testCases: [StorageTestCase] {
        [
            .init {
                let type: Micheline = .type(
                    prim: .pair,
                    args: [
                        try! .type(
                            prim: .bigMap,
                            args: [
                                .comparableType(prim: .address),
                                try! .comparableType(prim: .nat, annots: [":balance"])
                            ],
                            annots: ["%ledger"]
                        ),
                        .type(
                            prim: .pair,
                            args: [
                                try! .type(
                                    prim: .bigMap,
                                    args: [
                                        .comparableType(
                                            prim: .pair,
                                            args: [
                                                try! .comparableType(prim: .address, annots: [":owner"]),
                                                try! .comparableType(prim: .address, annots: [":spender"])
                                            ]
                                        ),
                                              .comparableType(prim: .nat)
                                    ],
                                    annots: ["%approvals"]
                                ),
                                try! .comparableType(
                                    prim: .pair,
                                    args: [
                                        try! .comparableType(prim: .address, annots: ["%admin"]),
                                        .comparableType(
                                            prim: .pair,
                                            args: [
                                                try! .comparableType(prim: .bool, annots: ["%paused"]),
                                                try! .comparableType(prim: .nat, annots: ["%totalSupply"])
                                            ]
                                        )
                                    ],
                                    annots: ["%fields"]
                                )
                            ]
                        )
                    ]
                )
                
                let value: Micheline = .data(
                    prim: .pair,
                    args: [
                        .int(51296),
                        .data(
                            prim: .pair,
                            args: [
                                .int(51297),
                                .data(
                                    prim: .pair,
                                    args: [
                                        try! .bytes("0x0000a7848de3b1fce76a7ffce2c7ce40e46be33aed7c"),
                                        .data(
                                            prim: .pair,
                                            args: [
                                                .data(prim: .true),
                                                .int(20)
                                            ]
                                        )
                                    ]
                                )
                            ]
                        )
                    ]
                )
                
                let entry: ContractStorageEntry = .object(.init(
                    value: value,
                    type: type,
                    elements: [
                        .bigMap(.init(id: "51296", value: value.args[0], type: type.args[0], nodeURL: nodeURL)),
                        .bigMap(.init(id: "51297", value: value.args[1].args[0], type: type.args[1].args[0], nodeURL: nodeURL)),
                        .object(.init(
                            value: value.args[1].args[1],
                            type: type.args[1].args[1],
                            elements: [
                                .value(.init(value: value.args[1].args[1].args[0], type: type.args[1].args[1].args[0])),
                                .value(.init(value: value.args[1].args[1].args[1].args[0], type: type.args[1].args[1].args[1].args[0])),
                                .value(.init(value: value.args[1].args[1].args[1].args[1], type: type.args[1].args[1].args[1].args[1]))
                            ]
                        ))
                    ]
                ))
                
                return (type, value, entry)
            }
        ]
    }
    
    private struct StorageTestCase {
        let type: Micheline
        let value: Micheline
        let entry: ContractStorageEntry
        
        init(type: Micheline, value: Micheline, entry: ContractStorageEntry) {
            self.type = type
            self.value = value
            self.entry = entry
        }
        
        init(_ builder: () -> (Micheline, Micheline, ContractStorageEntry)) {
            let (type, value, entry) = builder()
            self.init(type: type, value: value, entry: entry)
        }
    }
    
    private struct BlockContextContractsContractMock: BlockContextContractsContract {
        let storage: BlockContextContractsContractStorageMock
        
        init(value: Micheline) {
            self.storage = .init(value: value)
        }
        
        func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws -> RPCContractDetails { fatalError("Not implemented") }
        
        var balance: BlockContextContractsContractBalanceClient<HTTPMock> { fatalError("Not implemented") }
        var counter: BlockContextContractsContractCounterClient<HTTPMock> { fatalError("Not implemented") }
        var delegate: BlockContextContractsContractDelegateClient<HTTPMock> { fatalError("Not implemented") }
        var entrypoints: BlockContextContractsContractEntrypointsClient<HTTPMock> { fatalError("Not implemented") }
        var managerKey: BlockContextContractsContractManagerKeyClient<HTTPMock> { fatalError("Not implemented") }
        var script: BlockContextContractsContractScriptClient<HTTPMock> { fatalError("Not implemented") }
        var singleSaplingGetDiff: BlockContextContractsContractSingleSaplingGetDiffClient<HTTPMock> { fatalError("Not implemented") }
    }
    
    private struct BlockContextContractsContractStorageMock: BlockContextContractsContractStorage {
        let normalized: BlockContextContractsContractStorageNormalizedMock
        
        init(value: Micheline) {
            self.normalized = .init(value: value)
        }
        
        func get(configuredWith configuration: BlockContextContractsContractGetConfiguration) async throws -> Micheline? { fatalError("Not implemented") }
    }
    
    private struct BlockContextContractsContractStorageNormalizedMock: BlockContextContractsContractStorageNormalized {
        let value: Micheline
        
        func post(unparsingMode: RPCScriptParsing, configuredWith configuration: BlockContextContractsContractStorageGetConfiguration) async throws -> Micheline? {
            value
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

private extension Micheline {
    
    var args: [Micheline] {
        if case let .prim(prim) = self {
            return prim.args
        } else {
            return []
        }
    }
}
