//
//  LimitsUtils.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosOperation

// MARK: TezosOperation

extension TezosOperation {
    func limits() throws -> Limits.Operation {
        try contents.reduce(.zero) { (acc, content) in acc + (try content.limits()) }
    }
}

// MARK: TezosOperation.Content

extension TezosOperation.Content {
    func limits() throws -> Limits.Operation {
        guard hasFee, let managerOperation = self as? Manager else {
            return .zero
        }
        
        return .init(
            gas: try .init(managerOperation.gasLimit.value),
            storage: try .init(managerOperation.storageLimit.value)
        )
    }
}
