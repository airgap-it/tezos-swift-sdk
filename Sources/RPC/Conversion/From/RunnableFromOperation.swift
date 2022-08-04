//
//  RunnableFromOperation.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore
import TezosOperation

public extension RPCRunnableOperation {
    init(from operation: TezosOperation, chainID: ChainID) {
        self.init(
            branch: operation.branch,
            contents: operation.contents.map({ .init(from: $0) }),
            signature: operation.signatureOrPlaceholder,
            chainID: chainID
        )
    }
}

// MARK: Utility Extensions

private extension TezosOperation {
    
    var signatureOrPlaceholder: Signature {
        switch self {
        case .unsigned(_):
            return .placeholder
        case .signed(let signed):
            return signed.signature
        }
    }
}
