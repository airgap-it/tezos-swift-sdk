//
//  OperationFromRunnable.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore
import TezosOperation

public extension TezosOperation {
    init(from operation: RPCRunnableOperation) throws {
        self.init(
            branch: operation.branch,
            contents: try operation.contents.map({ try .init(from: $0) }),
            signature: operation.isSigned ? operation.signature : nil
        )
    }
}

// MARK: Utility Extensions

private extension RPCRunnableOperation {
    
    var isSigned: Bool {
        !signature.isPlaceholder
    }
}
