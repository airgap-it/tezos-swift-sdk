//
//  TezosCryptoDefaultError.swift
//  
//
//  Created by Julia Samol on 03.08.22.
//

public enum TezosCryptoSodiumError: Error {
    case sodium(Int)
    case secp256k1(String)
}
