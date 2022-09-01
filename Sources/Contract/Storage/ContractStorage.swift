//
//  ContractStorage.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import Foundation

import TezosMichelson
import TezosRPC
    
public struct ContractStorage<HTTPClient: HTTP> {
    private let type: Micheline.Lazy
    private let contract: BlockContextContractsContractClient<HTTPClient>
    private let nodeURL: URL
    
    init(from code: ContractCode.Lazy, contract: BlockContextContractsContractClient<HTTPClient>, nodeURL: URL) {
        let type: Cached<Micheline> = code.map {
            guard let storage = try? $0.storage.asPrim(.type(.storage)), storage.args.count == 1 else {
                throw TezosContractError.invalidType("storage")
            }
            
            return try storage.args[0].normalized()
        }
       
        self.type = type
        self.contract = contract
        self.nodeURL = nodeURL
    }
    
    public func get(configuredWith configuration: GetContractStorageConfiguration = .init()) async throws -> ContractStorageEntry? {
        async let valueAsync = contract.storage.getNormalized(headers: configuration.headers)
        async let typeAsync = type.get(headers: configuration.headers)
        
        let (value, type) = try await (valueAsync, typeAsync)
        guard let value = value else {
            return nil
        }
        
        return try .init(from: value, type: type, nodeURL: nodeURL)
    }
}

// MARK: Utility Extensions

private extension BlockContextContractsContractStorage {
    
    func getNormalized(headers: [HTTPHeader]) async throws -> Micheline? {
        do {
            return try await normalized.post(unparsingMode: .optimizedLegacy, configuredWith: .init(headers: headers))
        } catch {
            return try await get(configuredWith: .init(headers: headers))?.normalized()
        }
    }
}
