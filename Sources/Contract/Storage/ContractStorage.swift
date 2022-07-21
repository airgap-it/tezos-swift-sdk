//
//  ContractStorage.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import Foundation
import TezosMichelson
import TezosRPC

extension Contract {
    
    public struct Storage {
        private let type: LazyType
        private let contract: ContractRPC
        
        init(from code: Contract.LazyCode, contract: ContractRPC) throws {
            let type: Cached<Micheline> = try code.map {
                guard let storage = try? $0.storage.asPrim(Michelson._Type.Storage.self), storage.args.count == 1 else {
                    throw TezosContractError.invalidType("storage")
                }
                
                return try storage.args[0].normalized()
            }
           
            self.type = type
            self.contract = contract
        }
        
        public func get(configuredWith configuration: GetContractStorageConfiguration = .init()) async throws -> Entry? {
            guard let value = try await contract.storage.getNormalized(headers: configuration.headers) else {
                return nil
            }
            
            let type = try await type.get(headers: configuration.headers)
            return try .init(from: value, type: type)
        }
    }
    
    typealias LazyType = Cached<Micheline>
}

// MARK: Utility Exceptions

private extension BlockContextContractsContractStorage {
    
    func getNormalized(headers: [HTTPHeader]) async throws -> Micheline? {
        do {
            return try await normalized.post(unparsingMode: .optimizedLegacy, configuredWith: .init(headers: headers))
        } catch {
            return try await get(configuredWith: .init(headers: headers))?.normalized()
        }
    }
}
