//
//  TezosContractError.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

public enum TezosContractError: Error {
    case notFound(_ name: String)
    case invalidType(_ name: String)
}
