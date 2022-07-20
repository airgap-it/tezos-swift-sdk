//
//  ContractStorage.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import Foundation
import TezosRPC

extension Contract {
    
    public struct Storage {
        private let meta: LazyMeta
        private let contract: ContractRPC
    }
}

// MARK: Creator

extension Contract.Storage {
    
    struct Creator {
        private let contract: ContractRPC
        
        func create(from code: Contract.LazyCode) throws -> Contract.Storage {
            let meta = try code.map { try Meta(from: $0) }
            return .init(meta: meta, contract: contract)
        }
    }
}

// MARK: Meta

extension Contract.Storage {
    
    struct Meta {
        
        init(from code: Contract.Code) throws {
            
        }
    }
    
    typealias LazyMeta = Cached<Meta>
}
