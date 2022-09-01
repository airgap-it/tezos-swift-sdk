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

public struct ContractEntrypoint<HTTPClient: HTTP> {
    public let entrypoint: Entrypoint
    
    private let code: Micheline.Lazy
    private let contractAddress: ContractHash
    
    private let block: BlockClient<HTTPClient>
    private let feeEstimator: OperationFeeEstimator<ChainsClient<HTTPClient>>
    
    init(
        from code: Micheline.Lazy,
        entrypoint: Entrypoint,
        contractAddress: ContractHash,
        block: BlockClient<HTTPClient>,
        feeEstimator: OperationFeeEstimator<ChainsClient<HTTPClient>>
    ) {
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
        let branch: BlockHash = try await {
            if let branch = configuration.branch {
                return branch
            } else {
                return try await block.header.get(configuredWith: .init(headers: configuration.headers)).hash
            }
        }()
        
        let counter: String? = try await {
            if let counter = configuration.counter {
                return counter
            } else {
                return try await block.context.contracts(contractID: source.asAddress()).counter.get(configuredWith: .init(headers: configuration.headers))
            }
        }()
        
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
}
