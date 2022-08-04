//
//  FeeEstimatorDefaults.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore
import TezosOperation

public extension FeeEstimator {
    func minFee(chainID: RPCChainID = .main, operation: FeeApplicable) async throws -> FeeApplicable {
        try await minFee(chainID: chainID, operation: operation, configuredWith: .init())
    }
}
