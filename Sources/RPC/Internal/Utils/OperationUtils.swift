//
//  OperationUtils.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosOperation

// MARK: TezosOperation.Content

extension TezosOperation.Content {
    
    func asManager() -> Manager? {
        switch self {
        case .reveal(let reveal):
            return reveal
        case .transaction(let transaction):
            return transaction
        case .origination(let origination):
            return origination
        case .delegation(let delegation):
            return delegation
        case .registerGlobalConstant(let registerGlobalConstant):
            return registerGlobalConstant
        case .setDepositsLimit(let setDepositsLimit):
            return setDepositsLimit
        default:
            return nil
        }
    }
}
