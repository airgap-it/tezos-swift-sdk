//
//  CryptoProvider.swift
//  
//
//  Created by Julia Samol on 06.07.22.
//

import Foundation

public protocol CryptoProvider {
    func blake2b(message: [UInt8], ofSize size: Int) throws -> [UInt8]
    
    func signEd25519(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8]
    func verifyEd25519(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool
    
    func signSecp256K1(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8]
    func verifySecp256K1(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool
    
    func signP256(_ message: [UInt8], with key: [UInt8]) throws -> [UInt8]
    func verifyP256(_ message: [UInt8], withSignature signature: [UInt8], using key: [UInt8]) throws -> Bool
}
