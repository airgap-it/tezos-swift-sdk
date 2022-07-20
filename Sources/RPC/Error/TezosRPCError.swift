//
//  TezosRPCError.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

public struct TezosRPCError: Error {
    let errors: [RPCError]
    
    public var description: String {
        "Operation failed with errors \(errors)."
    }
}
