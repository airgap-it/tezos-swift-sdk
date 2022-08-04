//
//  OperationSigning.swift
//  
//
//  Created by Julia Samol on 06.07.22.
//

import TezosCore
import TezosCryptoDefault

// MARK: TezosOperation

extension TezosOperation {
    public func sign(with key: Key.Secret) throws -> TezosOperation.Signed {
        try sign(with: key, using: .init(provider: DefaultCryptoProvider()))
    }
    
    func sign<Provider: CryptoProvider>(with key: Key.Secret, using crypto: Crypto<Provider>) throws -> TezosOperation.Signed {
        .init(branch: branch, contents: contents, signature: try key.sign(self, using: crypto))
    }

    
    public func verify(with key: Key.Public) throws -> Bool {
        switch self {
        case .unsigned(_):
            return false
        case .signed(let signed):
            return try signed.verify(with: key)
        }
    }
    
    func verify<Provider: CryptoProvider>(with key: Key.Public, using crypto: Crypto<Provider>) throws -> Bool {
        switch self {
        case .unsigned(_):
            return false
        case .signed(let signed):
            return try signed.verify(with: key, using: crypto)
        }
    }
}

extension TezosOperation.Unsigned {
    public func sign(with key: Key.Secret) throws -> TezosOperation.Signed {
        try sign(with: key, using: .init(provider: DefaultCryptoProvider()))
    }
    
    func sign<Provider: CryptoProvider>(with key: Key.Secret, using crypto: Crypto<Provider>) throws -> TezosOperation.Signed {
        .init(branch: branch, contents: contents, signature: try key.sign(asOperation(), using: crypto))
    }
}

extension TezosOperation.Signed {
    public func sign(with key: Key.Secret) throws -> TezosOperation.Signed {
        try sign(with: key, using: .init(provider: DefaultCryptoProvider()))
    }
    
    func sign<Provider: CryptoProvider>(with key: Key.Secret, using crypto: Crypto<Provider>) throws -> TezosOperation.Signed {
        .init(branch: branch, contents: contents, signature: try key.sign(asOperation(), using: crypto))
    }
    
    public func verify(with key: Key.Public) throws -> Bool {
        try verify(with: key, using: .init(provider: DefaultCryptoProvider()))
    }
    
    func verify<Provider: CryptoProvider>(with key: Key.Public, using crypto: Crypto<Provider>) throws -> Bool {
        try key.verify(self, using: crypto)
    }
}
