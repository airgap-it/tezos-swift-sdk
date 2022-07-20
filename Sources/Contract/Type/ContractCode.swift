//
//  ContractCode.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosMichelson
import TezosRPC

extension Contract {
    
    public struct Code {
        public let parameter: Micheline
        public let storage: Micheline
        public let code: Micheline
    }
    
    typealias LazyCode = Cached<Code>
}
