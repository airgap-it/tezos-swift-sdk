//
//  Tezos.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

// TODO: Add configurable modules

struct Tezos<CP: CryptoProvider> {
    public let context: Context<CP>
}

// MARK: Context

extension Tezos {
    
    struct Context<CP: CryptoProvider> {
        public let crypto: Crypto<CP>
        
        init(cryptoProvider: CP) {
            self.crypto = .init(provider: cryptoProvider)
        }
    }
}

// MARK: Module

protocol TezosModule {
    associatedtype Builder: TezosModuleBuilder where Builder.T == Self
    
    static var builder: Builder { get }
}

protocol TezosModuleBuilder {
    associatedtype T: TezosModule
    
    func build() throws -> T
}
