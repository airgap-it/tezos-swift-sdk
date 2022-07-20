//
//  Contract.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import TezosCore
import TezosOperation
import TezosRPC

public class Contract<ContractRPC: BlockContextContractsContract> {
    public let address: ContractHash
    
    private let contract: ContractRPC
    
    init(address: ContractHash, contract: ContractRPC) {
        self.address = address
        self.contract = contract
    }
    
    private lazy var codeCached: Cached<Code> = .init { [unowned self] in
        try .init(from: try await self.contract.script.getNormalized(headers: $0))
    }
    
    public func code(headers: [HTTPHeader] = []) async throws -> Code {
        try await codeCached.get(headers: headers)
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
