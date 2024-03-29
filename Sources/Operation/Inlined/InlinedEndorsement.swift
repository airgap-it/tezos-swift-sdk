//
//  InlinedEndorsement.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import TezosCore

extension TezosOperation {
    
    public struct InlinedEndorsement: Hashable {
        public let branch: BlockHash
        public let operations: Content.Endorsement
        public let signature: Signature
        
        public init(branch: BlockHash, operations: Content.Endorsement, signature: Signature) {
            self.branch = branch
            self.operations = operations
            self.signature = signature
        }
    }
}
