//
//  TezosRPCError.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

public enum TezosRPCError: Error {
    case rpc([RPCError])
    case invalidURL(String)
    case http(Int)
    case unknown
}
