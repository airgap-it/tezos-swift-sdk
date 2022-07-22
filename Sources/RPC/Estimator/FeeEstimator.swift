//
//  FeeEstimator.swift
//  
//
//  Created by Julia Samol on 18.07.22.
//

import TezosOperation

public protocol FeeEstimator {
    associatedtype FeeApplicable
    
    func minFee(chainID: RPCChainID, operation: FeeApplicable, configuredWith configuration: MinFeeConfiguration) async throws -> FeeApplicable
}
