//
//  Contract.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosCore
import TezosMichelson
import TezosOperation
import TezosRPC

public class Contract<ContractRPC: BlockContextContractsContract> {
    public let address: ContractHash
    
    private let contract: ContractRPC
    
    init(address: ContractHash, contract: ContractRPC) {
        self.address = address
        self.contract = contract
    }
    
    public lazy var storage: ContractStorage<ContractRPC> = .init(from: codeCached, contract: contract)
    
    private lazy var entrypointsCached: Cached<[String: Micheline]> = .init{ [unowned self] in
        try await self.contract.entrypoints.get(configuredWith: .init(headers: $0)).entrypoints.mapValues { try $0.normalized() }
    }
    public func entrypoint(_ entrypoint: Entrypoint = .default) async -> ContractEntrypoint<ContractRPC> {
        let entrypointsLazy: Cached<Micheline> = entrypointsCached.combine(with: codeCached).map {
            let (entrypoints, code) = $0
            
            if let entrypointType = entrypoints[entrypoint.value] {
                return entrypointType
            } else if let entrypointType = code.findEntrypoint(entrypoint) {
                return entrypointType
            } else {
                throw TezosContractError.notFound("contract entrypoint \(entrypoint)")
            }
        }
        
        return await .init(from: entrypointsLazy, contract: contract)
    }
    
    private lazy var codeCached: Cached<ContractCode> = .init { [unowned self] in
        try .init(from: try await self.contract.script.getNormalized(headers: $0))
    }
    public func code(configuredWith configuration: GetContractCodeConfiguration = .init()) async throws -> ContractCode {
        try await codeCached.get(headers: configuration.headers)
    }
}

// MARK: Utility Extensions

private extension BlockContextContractsContractScript {
    
    func getNormalized(headers: [HTTPHeader]) async throws -> Script {
        guard let script = try await getNormalizedOrNil(headers: headers) else {
            throw TezosContractError.notFound("script")
        }
        
        return script
    }
    
    private func getNormalizedOrNil(headers: [HTTPHeader]) async throws -> Script? {
        do {
            return try await normalized.post(unparsingMode: .optimizedLegacy, configuredWith: .init(headers: headers))
        } catch {
            return try await get(configuredWith: .init(headers: headers))?.normalized()
        }
    }
}

private extension Script {
    
    func normalized() throws -> Script {
        .init(code: try code.normalized(), storage: try storage.normalized())
    }
}

private extension ContractCode {
    
    func findEntrypoint(_ entrypoint: Entrypoint) -> Micheline? {
        guard case .default = entrypoint,
              let parameter = try? parameter.asPrim(Michelson._Type.Parameter.self),
              parameter.args.count == 1
        else {
            return nil
        }
        
        return parameter.args[0]
    }
}
