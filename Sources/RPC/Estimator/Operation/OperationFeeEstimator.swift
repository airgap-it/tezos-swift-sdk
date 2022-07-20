//
//  OperationFeeEstimator.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import BigInt
import TezosCore
import TezosOperation

class OperationFeeEstimator: FeeEstimator {
    public typealias Result = TezosOperation
    
    private let chains: Chains
    
    private lazy var chainIDCached: CachedMap<String, ChainID> = .init { [unowned self] in
        try await self.chains(chainID: $0).chainID.get(configuredWith: .init(headers: $1))
    }
    
    init(chains: Chains) {
        self.chains = chains
    }
    
    func minFee(chainID: String, operation: TezosOperation, configuredWith configuration: MinFeeConfiguration) async throws -> TezosOperation {
        let chainID = try await resolveChainID(from: chainID, with: configuration.headers)
        let runnableOperation = RPCRunnableOperation(from: try operation.apply(limits: configuration.limits), chainID: chainID)
        
        let runOperationResult = try await chains(chainID: chainID)
            .blocks
            .head
            .helpers
            .scripts
            .runOperation
            .post(operation: runnableOperation, configuredWith: .init(headers: configuration.headers))
        
        let operation = try TezosOperation(from: runnableOperation).update(with: runOperationResult)
        
        return operation
    }
    
    private func resolveChainID(from chainID: String, with headers: [HTTPHeader]) async throws -> ChainID {
        if let chainID = try? ChainID(base58: chainID) {
            return chainID
        } else {
            return try await chainIDCached.get(forKey: chainID, headers: headers)
        }
    }
}

// MARK: Utility Extensions

private extension TezosOperation {
    
    func apply(limits: Limits) throws -> TezosOperation {
        let maxLimits = try maxLimits(from: limits)
        let updatedContents = contents.map { $0.apply(limits: maxLimits) }
        
        return .init(branch: branch, contents: updatedContents, signature: signature)
    }
    
    func update(with rpcContents: [RPCOperation.Content]) -> TezosOperation {
        // TODO
    }
    
    private func maxLimits(from limits: Limits) throws -> Limits.Operation {
        let availableGasLimitPerBlock = max(limits.perBlock.gasBigUInt - (try self.limits().gasBigUInt), BigUInt.zero)
        let requiresEstimation = contents.filter { !$0.hasFee }.count
        let maxGasLimitPerOperation = requiresEstimation > 0 ? availableGasLimitPerBlock / BigUInt(requiresEstimation) : BigUInt.zero
        
        return .init(
            gas: min(limits.perOperation.gasBigUInt, maxGasLimitPerOperation),
            storage: limits.perOperation.storageBigUInt
        )
    }
}

private extension TezosOperation.Content {
    
    func apply(fee: Mutez = .zero, limits: Limits.Operation = .zero) -> TezosOperation.Content {
        guard !hasFee else {
            return self
        }
        
        switch self {
        case .reveal(let reveal):
            return .reveal(.init(
                source: reveal.source,
                fee: fee,
                counter: reveal.counter,
                gasLimit: .init(limits.gasBigUInt),
                storageLimit: .init(limits.storageBigUInt),
                publicKey: reveal.publicKey
            ))
        default:
            return self
        }
    }
}
