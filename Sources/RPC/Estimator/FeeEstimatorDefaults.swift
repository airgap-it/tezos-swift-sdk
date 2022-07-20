//
//  FeeEstimatorDefaults.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore
import TezosOperation

public extension FeeEstimator {
    func minFee(chainID: String, operation: TezosOperation) async throws -> Result {
        try await minFee(chainID: chainID, operation: operation, configuredWith: .init())
    }
    
    func minFee(chainID: ChainID, operation: TezosOperation, configuredWith configuration: MinFeeConfiguration = .init()) async throws -> Result {
        try await minFee(chainID: chainID.base58, operation: operation, configuredWith: configuration)
    }
}
