//
//  InlinedPreendorsement.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation
import TezosCore

extension Operation {
    
    public struct InlinedPreendorsement: Hashable {
        public let branch: BlockHash
        public let operations: Content.Preendorsement
        public let signature: Signature
        
        public init(branch: BlockHash, operations: Content.Preendorsement, signature: Signature) {
            self.branch = branch
            self.operations = operations
            self.signature = signature
        }
    }
}
