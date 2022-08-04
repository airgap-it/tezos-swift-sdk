//
//  BigMapHandler.swift
//  
//
//  Created by Julia Samol on 21.07.22.
//

import Foundation

import TezosCore
import TezosMichelson
import TezosRPC
import TezosCryptoDefault

public protocol BigMapHandler {
    var id: String { get }
    var type: Micheline { get }
    
    var nodeURL: URL { get }
}

public extension BigMapHandler {
    func get(
        forKey key: Micheline,
        configuredWith configuration: BigMapGetConfiguration
    ) async throws -> ContractStorageEntry? {
        let chains = ChainsClient(parentURL: nodeURL, http: URLSessionHTTP())
        
        return try await get(
            forKey: key,
            using: .init(provider: DefaultCryptoProvider()),
            and: chains.main.blocks.head.context.bigMaps,
            configuredWith: configuration
        )
    }
    
    private func get<Provider: CryptoProvider, BigMapsRPC: BlockContextBigMaps>(
        forKey key: Micheline,
        using crypto: Crypto<Provider>,
        and rpc: BigMapsRPC,
        configuredWith configuration: BigMapGetConfiguration
    ) async throws -> ContractStorageEntry? {
        guard let type = try? type.asPrim(.type(.bigMap)), type.args.count == 2 else {
            throw TezosContractError.invalidType("storage big map")
        }
        
        let keyExpr = try scriptExpr(from: key, ofType: type.args[0], using: crypto)
        guard let value = try await rpc(bigMapID: id)(scriptExpr: keyExpr).get(configuredWith: .init(headers: configuration.headers)) else {
            return nil
        }
        
        return try .init(from: value, type: type.args[1], nodeURL: nodeURL)
    }
    
    private func scriptExpr<Provider: CryptoProvider>(from key: Micheline, ofType type: Micheline, using crypto: Crypto<Provider>) throws -> ScriptExprHash {
        let keyBytes = try key.packToBytes(usingSchema: type)
        let keyHash = try crypto.hash(keyBytes, ofSize: 32)
        
        return try ScriptExprHash(from: keyHash)
    }
}

public typealias BigMapGetConfiguration = HeadersOnlyConfiguration
