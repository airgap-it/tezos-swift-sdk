//
//  ContractEntrypoint.swift
//  
//
//  Created by Julia Samol on 25.07.22.
//

import TezosCore
import TezosMichelson
import TezosOperation
import TezosRPC

public struct ContractEntrypoint<BlockRPC: Block, OperationFeeEstimator: FeeEstimator> where OperationFeeEstimator.FeeApplicable == TezosOperation {
    public let entrypoint: Entrypoint
    
    private let code: Micheline.Lazy
    private let contractAddress: ContractHash
    
    private let block: BlockRPC
    private let feeEstimator: OperationFeeEstimator
    
    init(
        from code: Micheline.Lazy,
        entrypoint: Entrypoint,
        contractAddress: ContractHash,
        block: BlockRPC,
        feeEstimator: OperationFeeEstimator
    ) async {
        self.entrypoint = entrypoint
        self.code = code
        self.contractAddress = contractAddress
        self.block = block
        self.feeEstimator = feeEstimator
    }
    
    public func callAsFunction(
        source: Address.Implicit,
        parameters: Micheline,
        configuredWith configuration: EntrypointCallConfiguration = .init()
    ) async throws -> TezosOperation.Unsigned {
        let branch = try await returnOrFetch(configuration.branch) {
            try await block.header.get(configuredWith: .init(headers: configuration.headers)).hash
        }
        
        let counter = try await returnOrFetch(configuration.counter) {
            try await block.context.contracts(contractID: source.asAddress()).counter.get(configuredWith: .init(headers: configuration.headers))
        }
        
        let operation = TezosOperation.Unsigned(
            branch: branch,
            contents: [
                .transaction(.init(
                    source: source,
                    counter: try counter.map { try .init($0) } ?? .zero,
                    gasLimit: try configuration.limits.map { try .init($0.gas) } ?? .zero,
                    storageLimit: try configuration.limits.map { try .init($0.storage) } ?? .zero,
                    amount: configuration.amount ?? .zero,
                    destination: contractAddress.asAddress(),
                    parameters: .init(entrypoint: entrypoint, value: parameters)
                ))
            ]
        )
        
        if configuration.fee != nil, configuration.limits != nil {
            return operation
        } else {
            let operationWithFee = try await feeEstimator.minFee(chainID: .main, operation: operation.asOperation(), configuredWith: .init(headers: configuration.headers))
            return .init(branch: operationWithFee.branch, contents: operationWithFee.contents)
        }
    }
    
    public func callAsFunction(
        source: Address.Implicit,
        parameters: ContractEntrypointParameter,
        configuredWith configuration: EntrypointCallConfiguration = .init()
    ) async throws -> TezosOperation.Unsigned {
        let code = try await code.get(headers: configuration.headers)
        return try await self(source: source, parameters: .init(from: parameters, code: code), configuredWith: configuration)
    }
    
    private func returnOrFetch<T>(_ value: T?, fetch: () async throws -> T) async rethrows -> T {
        if let value = value {
            return value
        } else {
            return try await fetch()
        }
    }
}
