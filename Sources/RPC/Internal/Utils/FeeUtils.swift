//
//  FeeUtils.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosCore
import TezosOperation

// MARK: TezosOperation

extension TezosOperation {
    var fee: Mutez {
        contents.reduce(try! Mutez(0)) { (acc, content) in acc + content.fee }
    }
}

// MARK: TezosOperation.Content

extension TezosOperation.Content {
    var fee: Mutez {
        guard let managerOperation = asManager() else {
            return try! .init(0)
        }
        
        return managerOperation.fee
    }
    
    var hasFee: Bool {
        fee.value != 0
    }
}
