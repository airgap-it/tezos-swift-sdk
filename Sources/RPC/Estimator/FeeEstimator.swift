//
//  FeeEstimator.swift
//  
//
//  Created by Julia Samol on 18.07.22.
//

import TezosOperation

public protocol FeeEstimator {
    associatedtype Result
    
    func minFee(chainID: String, operation: TezosOperation, configuredWith configuration: MinFeeConfiguration) async throws -> Result
}
