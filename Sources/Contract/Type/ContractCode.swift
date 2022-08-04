//
//  ContractCode.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosMichelson
import TezosRPC
    
public struct ContractCode {
    public let parameter: Micheline
    public let storage: Micheline
    public let code: Micheline
    
    typealias Lazy = Cached<ContractCode>
}
