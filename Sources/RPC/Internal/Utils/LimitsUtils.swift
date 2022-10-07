//
//  LimitsUtils.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosOperation
import BigInt

// MARK: TezosOperation

extension TezosOperation {
    
    func limits() throws -> Limits.Operation {
        try contents.reduce(.zero) { (acc, content) in acc + (try content.limits()) }
    }
}

// MARK: TezosOperation.Content

extension TezosOperation.Content {
    
    func limits() throws -> Limits.Operation {
        guard hasFee, let managerOperation = asManager() else {
            return .zero
        }
        
        return .init(
            gas: try .init(managerOperation.gasLimit.value),
            storage: try .init(managerOperation.storageLimit.value)
        )
    }
}

// MARK: RPCOperation.Content

extension RPCOperation.Content {
    
    func metadataLimits() throws -> Limits.Operation? {
        switch self {
        case .reveal(let reveal):
            return try reveal.metadata?.limits()
        case .transaction(let transaction):
            return try transaction.metadata?.limits()
        case .origination(let origination):
            return try origination.metadata?.limits()
        case .delegation(let delegation):
            return try delegation.metadata?.limits()
        case .registerGlobalConstant(let registerGlobalConstant):
            return try registerGlobalConstant.metadata?.limits()
        case .setDepositsLimit(let setDepositsLimit):
            return try setDepositsLimit.metadata?.limits()
        default:
            return nil
        }
    }
}

// MARK: RPCOperationMetadata.Reveal

extension RPCOperationMetadata.Reveal {
    
    func limits() throws -> Limits.Operation {
        try getLimits(from: .reveal(operationResult), and: internalOperationResults)
    }
}

// MARK: RPCOperationMetadata.Transaction

extension RPCOperationMetadata.Transaction {
    
    func limits() throws -> Limits.Operation {
        try getLimits(from: .transaction(operationResult), and: internalOperationResults)
    }
}

// MARK: RPCOperationMetadata.Origination

extension RPCOperationMetadata.Origination {
    
    func limits() throws -> Limits.Operation {
        try getLimits(from: .origination(operationResult), and: internalOperationResults)
    }
}

// MARK: RPCOperationMetadata.Delegation

extension RPCOperationMetadata.Delegation {
    
    func limits() throws -> Limits.Operation {
        try getLimits(from: .delegation(operationResult), and: internalOperationResults)
    }
}

// MARK: RPCOperationMetadata.RegisterGlobalConstant

extension RPCOperationMetadata.RegisterGlobalConstant {
    
    func limits() throws -> Limits.Operation {
        try getLimits(from: .registerGlobalConstant(operationResult), and: internalOperationResults)
    }
}

// MARK: RPCOperationMetadata.SetDepositsLimit

extension RPCOperationMetadata.SetDepositsLimit {
    
    func limits() throws -> Limits.Operation {
        try getLimits(from: .setDepositsLimit(operationResult), and: internalOperationResults)
    }
}

// MARK: RPCOperationResults

extension RPCOperationResult {
    
    func limits() throws -> Limits.Operation {
        try assertApplied()
        return .init(gas: try gasLimit(), storage: try storageLimit())
    }
    
    func gasLimit() throws -> BigUInt {
        let consumedGas = try consumedGasBigUInt()
        return consumedGas + BigUInt(gasSafetyMargin)
    }
    
    private func consumedGasBigUInt() throws -> BigUInt {
        if let consumedGas = consumedMilligas {
            return try .init(consumedGas) / 1000
        } else {
            return .zero
        }
    }
    
    func storageLimit() throws -> BigUInt {
        let paidStorageSizeDiff: BigUInt = try paidStorageSizeDiffBigUInt()
        return paidStorageSizeDiff + (try burnFee()) + BigUInt(gasSafetyMargin)
    }
    
    private func paidStorageSizeDiffBigUInt() throws -> BigUInt {
        if let paidStorageSizeDiff = paidStorageSizeDiff {
            return try .init(paidStorageSizeDiff)
        } else {
            return .zero
        }
    }
    
    func burnFee() throws -> BigUInt {
        let originatedContracts = originatedContracts?.count ?? 0
        let originatedContractsFee = BigUInt(originatedContracts) * BigUInt(storageContractAllocation)
        let allocatedDestinationContractFee = (allocatedDestinationContract ?? false) ? BigUInt(storageContractAllocation) : 0
        
        return originatedContractsFee + allocatedDestinationContractFee
    }
    
    private func assertApplied() throws {
        if let errors = errors {
            throw TezosRPCError.rpc(errors)
        }
    }
}

// MARK: Utilities

private func getLimits(from operationResult: RPCOperationResult, and internalOperationResults: [RPCInternalOperationResult]?) throws -> Limits.Operation {
    let internalResults = internalOperationResults ?? []
    return try internalResults.reduce(try operationResult.limits()) { (acc, internalResult) in acc + (try internalResult.result.limits()) }
}

// MARK: Constants

private let storageContractAllocation: UInt = 257

private let gasSafetyMargin: UInt = 100
private let storageSafetyMargin: UInt = 100
