//
//  ContractCodeFromScript.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosCore
import TezosMichelson
import TezosOperation

extension ContractCode {
    
    init(from script: Script) throws {
        guard case let .sequence(contractCode) = script.code else {
            throw TezosError.invalidValue("Invalid Micheline type, expected `.sequence`, but got \(script.code)")
        }
        
        guard contractCode.count == 3 else {
            throw TezosError.invalidValue("Unkown contract code type.")
        }
        
        let parameter = try contractCode[0].asPrim(.type(.parameter))
        let storage = try contractCode[1].asPrim(.type(.storage))
        let code = try contractCode[2].asPrim(.type(.code))
        
        self.init(parameter: .prim(parameter), storage: .prim(storage), code: .prim(code))
    }
}
