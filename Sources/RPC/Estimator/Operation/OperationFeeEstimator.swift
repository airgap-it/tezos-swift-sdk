//
//  OperationFeeEstimator.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import BigInt
import TezosCore
import TezosOperation

public class OperationFeeEstimator<ChainsRPC: Chains>: FeeEstimator {
    private let chains: ChainsRPC
    
    private lazy var chainIDCached: CachedMap<RPCChainID, ChainID> = .init { [unowned self] in
        try await self.chains(chainID: $0).chainID.get(configuredWith: .init(headers: $1))
    }
    
    public init(chains: ChainsRPC) {
        self.chains = chains
    }
    
    public func minFee(chainID: RPCChainID, operation: TezosOperation, configuredWith configuration: MinFeeConfiguration) async throws -> TezosOperation {
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
    
    private func resolveChainID(from chainID: RPCChainID, with headers: [HTTPHeader]) async throws -> ChainID {
        if case let .id(chainID) = chainID {
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
    
    func update(with rpcContents: [RPCOperation.Content]) throws -> TezosOperation {
        var groupedContents = try rpcContents.grouping(by: { try Content(from: $0).hashValue })
        let updatedContents = try contents.map { (content: Content) -> Content in
            guard let rpcContent = groupedContents.next(for: content.hashValue) else {
                return content
            }

            return try content.update(with: rpcContent)
        }
        
        return .init(branch: branch, contents: updatedContents, signature: signature)
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
        case .transaction(let transaction):
            return .transaction(.init(
                source: transaction.source,
                fee: fee,
                counter: transaction.counter,
                gasLimit: .init(limits.gasBigUInt),
                storageLimit: .init(limits.storageBigUInt),
                amount: transaction.amount,
                destination: transaction.destination,
                parameters: transaction.parameters
            ))
            
        case .origination(let origination):
            return .origination(.init(
                source: origination.source,
                fee: fee,
                counter: origination.counter,
                gasLimit: .init(limits.gasBigUInt),
                storageLimit: .init(limits.storageBigUInt),
                balance: origination.balance,
                delegate: origination.delegate,
                script: origination.script
            ))
            
        case .delegation(let delegation):
            return .delegation(.init(
                source: delegation.source,
                fee: fee,
                counter: delegation.counter,
                gasLimit: .init(limits.gasBigUInt),
                storageLimit: .init(limits.storageBigUInt),
                delegate: delegation.delegate
            ))
            
        case .registerGlobalConstant(let registerGlobalConstant):
            return .registerGlobalConstant(.init(
                source: registerGlobalConstant.source,
                fee: fee,
                counter: registerGlobalConstant.counter,
                gasLimit: .init(limits.gasBigUInt),
                storageLimit: .init(limits.storageBigUInt),
                value: registerGlobalConstant.value
            ))
            
        case .setDepositsLimit(let setDepositsLimit):
            return .setDepositsLimit(.init(
                source: setDepositsLimit.source,
                fee: fee,
                counter: setDepositsLimit.counter,
                gasLimit: .init(limits.gasBigUInt),
                storageLimit: .init(limits.storageBigUInt),
                limit: setDepositsLimit.limit
            ))
        default:
            return self
        }
    }
    
    func update(with rpcContent: RPCOperation.Content) throws -> TezosOperation.Content { 
        guard
            !hasFee,
            let _ = asManager(),
            matches(rpcContent: rpcContent),
            let metadataLimits = try rpcContent.metadataLimits()
        else {
            return self
        }
        
        let forged = try forge()
        let size = forged.count + 32 + 64 /* content size + forged branch size + forged signature size */
        let fee = calculateFee(forOperationOfSize: size, using: metadataLimits)
        
        return apply(fee: fee, limits: metadataLimits)
    }
    
    private func matches(rpcContent: RPCOperation.Content) -> Bool {
        switch self {
        case .seedNonceRevelation(_):
            guard case .seedNonceRevelation(_) = rpcContent else {
                return false
            }
            
            return true
        case .doubleEndorsementEvidence(_):
            guard case .doubleEndorsementEvidence(_) = rpcContent else {
                return false
            }
            
            return true
        case .doubleBakingEvidence(_):
            guard case .doubleBakingEvidence(_) = rpcContent else {
                return false
            }
            
            return true
        case .activateAccount(_):
            guard case .activateAccount(_) = rpcContent else {
                return false
            }
            
            return true
        case .proposals(_):
            guard case .proposals(_) = rpcContent else {
                return false
            }
            
            return true
        case .ballot(_):
            guard case .ballot(_) = rpcContent else {
                return false
            }
            
            return true
        case .doublePreendorsementEvidence(_):
            guard case .doublePreendorsementEvidence(_) = rpcContent else {
                return false
            }
            
            return true
        case .failingNoop(_):
            guard case .failingNoop(_) = rpcContent else {
                return false
            }
            
            return true
        case .preendorsement(_):
            guard case .preendorsement(_) = rpcContent else {
                return false
            }
            
            return true
        case .endorsement(_):
            guard case .endorsement(_) = rpcContent else {
                return false
            }
            
            return true
        case .reveal(_):
            guard case .reveal(_) = rpcContent else {
                return false
            }
            
            return true
        case .transaction(_):
            guard case .transaction(_) = rpcContent else {
                return false
            }
            
            return true
        case .origination(_):
            guard case .origination(_) = rpcContent else {
                return false
            }
            
            return true
        case .delegation(_):
            guard case .delegation(_) = rpcContent else {
                return false
            }
            
            return true
        case .registerGlobalConstant(_):
            guard case .registerGlobalConstant(_) = rpcContent else {
                return false
            }
            
            return true
        case .setDepositsLimit(_):
            guard case .setDepositsLimit(_) = rpcContent else {
                return false
            }
            
            return true
        }
    }
    
    private func calculateFee(forOperationOfSize operationSize: Int, using limits: Limits.Operation) -> Mutez {
        let gasFee = Nanotez(feePerGasUnitNanotez) * limits.gasBigUInt
        let storageFee = Nanotez(feePerStorageByteNanotez) * operationSize
        
        return try! Mutez(Int64(feeBaseMutez)) + Mutez(from: gasFee) + Mutez(from: storageFee) + (try! Mutez(Int64(feeSafetyMarginMutez)))
    }
}

private extension Dictionary {
    mutating func next(for key: Key) -> RPCOperation.Content? where Value == Array<RPCOperation.Content> {
        guard var values = self[key], !values.isEmpty else {
            return nil
        }
        
        let content = values.removeFirst()
        self[key] = values
        
        return content
    }
}

// MARK: Constants

private let feeBaseMutez: UInt = 100

private let feePerGasUnitNanotez: UInt = 100
private let feePerStorageByteNanotez: UInt = 1000

private let feeSafetyMarginMutez: UInt = 100
