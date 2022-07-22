//
//  OperationFeeEstimatorTest.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import XCTest
import TezosTestUtils

@testable import TezosCore
@testable import TezosOperation
@testable import TezosRPC

class OperationFeeEstimatorTest: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {

    }
    
    func testMinFeeEstimationWithDefaultLimits() async throws {
        let chainID = try! ChainID(base58: "NetXdQprcVkpaWU")
        let branch = try! BlockHash(base58: "BKuka2aVwcjNkZrDzFHJMvdCz43RoMt1kFfjKnipNnGsERSAUEn")
        
        let operation = TezosOperation(
            branch: branch,
            contents: [
                .transaction(.init(
                    source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                    fee: .zero,
                    counter: .init(UInt(727)),
                    gasLimit: .init(UInt(1_030_000)),
                    storageLimit: .init(UInt(50_000)),
                    amount: try! .init(1000),
                    destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")))
                ))
            ]
        )
        
        let chains = ChainsMock(chainID: chainID, rpcContents: [
            .transaction(.init(
                source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                fee: .zero,
                counter: "727",
                gasLimit: "1040000",
                storageLimit: "60000",
                amount: try! .init(1000),
                destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                metadata: .init(
                    balanceUpdates: [],
                    operationResult: .appliedToContract(.init(
                        balanceUpdates: [
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: -1000,
                                origin: .block
                            )),
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: 1000,
                                origin: .block
                            ))
                        ],
                        consumedGas: "1421",
                        consumedMilligas: "1420040"
                    ))
                )
            ))
        ])
        
        let operationFeeEstimator = OperationFeeEstimator(chains: chains)
        
        let updatedOperation = try await operationFeeEstimator.minFee(chainID: .id(chainID), operation: operation)
        
        XCTAssertEqual(try! Mutez(505), updatedOperation.fee)
        XCTAssertEqual(Limits.Operation(gas: UInt(1521), storage: UInt(100)), try! updatedOperation.limits())
    }
    
    func testMinFeeEstimationWithSpecifiedLimits() async throws {
        let chainID = try! ChainID(base58: "NetXdQprcVkpaWU")
        let branch = try! BlockHash(base58: "BKuka2aVwcjNkZrDzFHJMvdCz43RoMt1kFfjKnipNnGsERSAUEn")
        let limits = Limits(gasPerOperation: UInt(400_000), gasPerBlock: UInt(1_020_000), storagePerOperation: UInt(40_000))
        
        let operation = TezosOperation(
            branch: branch,
            contents: [
                .transaction(.init(
                    source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                    fee: .zero,
                    counter: .init(UInt(727)),
                    gasLimit: .init(UInt(1_030_000)),
                    storageLimit: .init(UInt(50_000)),
                    amount: try! .init(1000),
                    destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")))
                ))
            ]
        )
        
        let chains = ChainsMock(chainID: chainID, rpcContents: [
            .transaction(.init(
                source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                fee: .zero,
                counter: "727",
                gasLimit: "400000",
                storageLimit: "40000",
                amount: try! .init(1000),
                destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                metadata: .init(
                    balanceUpdates: [],
                    operationResult: .appliedToContract(.init(
                        balanceUpdates: [
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: -1000,
                                origin: .block
                            )),
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: 1000,
                                origin: .block
                            ))
                        ],
                        consumedGas: "1421",
                        consumedMilligas: "1420040"
                    ))
                )
            ))
        ])
        
        let operationFeeEstimator = OperationFeeEstimator(chains: chains)
        
        let updatedOperation = try await operationFeeEstimator.minFee(chainID: .id(chainID), operation: operation, configuredWith: .init(limits: limits))
        
        XCTAssertEqual(try! Mutez(505), updatedOperation.fee)
        XCTAssertEqual(Limits.Operation(gas: UInt(1521), storage: UInt(100)), try! updatedOperation.limits())
    }
    
    func testMinFeeEstimationShouldNotReplaceSetFeesAndLimits() async throws {
        let chainID = try! ChainID(base58: "NetXdQprcVkpaWU")
        let branch = try! BlockHash(base58: "BKuka2aVwcjNkZrDzFHJMvdCz43RoMt1kFfjKnipNnGsERSAUEn")
        
        let operation = TezosOperation(
            branch: branch,
            contents: [
                .transaction(.init(
                    source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                    fee: .zero,
                    counter: .init(UInt(727)),
                    gasLimit: .init(UInt(1_030_000)),
                    storageLimit: .init(UInt(50_000)),
                    amount: try! .init(1000),
                    destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")))
                )),
                .transaction(.init(
                    source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                    fee: try! .init(600),
                    counter: .init(UInt(728)),
                    gasLimit: .init(UInt(1_030_000)),
                    storageLimit: .init(UInt(51_000)),
                    amount: try! .init(1000),
                    destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")))
                ))
            ]
        )
        
        let chains = ChainsMock(chainID: chainID, rpcContents: [
            .transaction(.init(
                source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                fee: .zero,
                counter: "727",
                gasLimit: "1040000",
                storageLimit: "60000",
                amount: try! .init(1000),
                destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                metadata: .init(
                    balanceUpdates: [],
                    operationResult: .appliedToContract(.init(
                        balanceUpdates: [
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: -1000,
                                origin: .block
                            )),
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: 1000,
                                origin: .block
                            ))
                        ],
                        consumedGas: "1421",
                        consumedMilligas: "1420040"
                    ))
                )
            )),

            .transaction(.init(
                source: .tz1(try! .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb")),
                fee: try! Mutez(600),
                counter: "728",
                gasLimit: "1030000",
                storageLimit: "51000",
                amount: try! .init(1000),
                destination: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                metadata: .init(
                    balanceUpdates: [
                        .contract(.init(
                            contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                            change: -600,
                            origin: .block
                        )),
                        .contract(.init(
                            contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                            change: 600,
                            origin: .block
                        ))
                    ],
                    operationResult: .appliedToContract(.init(
                        balanceUpdates: [
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: -1000,
                                origin: .block
                            )),
                            .contract(.init(
                                contract: .implicit(.tz1(try .init(base58: "tz1gru9Tsz1X7GaYnsKR2YeGJLTVm4NwMhvb"))),
                                change: 1000,
                                origin: .block
                            ))
                        ],
                        consumedGas: "1421",
                        consumedMilligas: "1420040"
                    ))
                )
            ))
        ])
        
        let operationFeeEstimator = OperationFeeEstimator(chains: chains)
        
        let updatedOperation = try await operationFeeEstimator.minFee(chainID: .id(chainID), operation: operation)
        
        XCTAssertEqual(try! Mutez(1105), updatedOperation.fee)
        XCTAssertEqual(Limits.Operation(gas: UInt(1_031_521), storage: UInt(51_100)), try! updatedOperation.limits())
    }
    
    private struct ChainsMock: Chains {
        let chain: ChainsChainMock
        
        init(chainID: ChainID, rpcContents: [RPCOperation.Content]) {
            self.chain = .init(chainID: chainID, rpcContents: rpcContents)
        }
        
        func callAsFunction(chainID: RPCChainID) -> ChainsChainMock {
            return chain
        }
    }
    
    private struct ChainsChainMock: ChainsChain {
        let blocks: ChainsChainBlocksMock
        let chainID: ChainsChainChainIDMock
        
        init(chainID: ChainID, rpcContents: [RPCOperation.Content]) {
            self.blocks = .init(rpcContents: rpcContents)
            self.chainID = .init(chainID: chainID)
        }
        
        func patch(bootstrapped: Bool, configuredWith configuration: ChainsChainPatchConfiguration) async throws { fatalError("Not implemented") }
        var invalidBlocks: ChainsChainInvalidBlocksClient<HTTPMock> { fatalError("Not implemented") }
        var isBootstrapped: ChainsChainIsBootstrappedClient<HTTPMock> { fatalError("Not implemented") }
        var levels: ChainsChainLevelsClient<HTTPMock> { fatalError("Not implemented") }
    }
    
    private struct ChainsChainBlocksMock: ChainsChainBlocks {
        let block: BlockMock
        
        init(rpcContents: [RPCOperation.Content]) {
            self.block = .init(rpcContents: rpcContents)
        }
        
        func callAsFunction(blockID: RPCBlockID) -> BlockMock {
            block
        }
        
        func get(configuredWith configuration: ChainsChainBlocksGetConfiguration) async throws -> [BlockHash] { fatalError("Not implemented") }
    }
    
    private struct BlockMock: Block {
        let helpers: BlockHelpersMock
        
        init(rpcContents: [RPCOperation.Content]) {
            self.helpers = .init(rpcContents: rpcContents)
        }
        
        func get(configuredWith configuration: BlockGetConfiguration) async throws -> RPCBlock { fatalError("Not implemented") }
        
        var context: BlockContextClient<HTTPMock> { fatalError("Not implemented") }
        var header: BlockHeaderClient<HTTPMock> { fatalError("Not implemented") }
        var operations: BlockOperationsClient<HTTPMock> { fatalError("Not implemented") }
    }
    
    private struct BlockHelpersMock: BlockHelpers {
        let scripts: BlockHelpersScriptsMock
        
        init(rpcContents: [RPCOperation.Content]) {
            self.scripts = .init(rpcContents: rpcContents)
        }
        
        var preapply: BlockHelpersPreapplyClient<HTTPMock> { fatalError("Not implemented") }
    }
    
    private struct BlockHelpersScriptsMock: BlockHelpersScripts {
        let runOperation: BlockHelpersScriptsRunOperationMock
        
        init(rpcContents: [RPCOperation.Content]) {
            self.runOperation = .init(rpcContents: rpcContents)
        }
    }
    
    private struct BlockHelpersScriptsRunOperationMock: BlockHelpersScriptsRunOperation {
        let rpcContents: [RPCOperation.Content]
        
        func post(
            operation: RPCRunnableOperation,
            configuredWith configuration: BlockHelpersPreapplyOperationsPostConfiguration
        ) async throws -> [RPCOperation.Content] {
            rpcContents
        }
    }
    
    private struct ChainsChainChainIDMock: ChainsChainChainID {
        let chainID: ChainID
        
        func get(configuredWith configuration: ChainsChainChainIDGetConfiguration) async throws -> ChainID {
            chainID
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
