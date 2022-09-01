//
//  Contract.swift
//  
//
//  Created by Julia Samol on 20.07.22.
//

import Foundation

import TezosCore
import TezosMichelson
import TezosOperation
import TezosRPC

public typealias TezosContract = Contract<
    BlockClient<URLSessionHTTP>,
    BlockContextContractsContractClient<URLSessionHTTP>,
    OperationFeeEstimator<ChainsClient<URLSessionHTTP>>
>

public class Contract<
    BlockRPC: Block,
    ContractRPC: BlockContextContractsContract,
    FeeEstimatorRPC: FeeEstimator
> where FeeEstimatorRPC.FeeApplicable == TezosOperation {
    public let address: ContractHash
    
    private let block: BlockRPC
    private let contract: ContractRPC
    private let feeEstimator: FeeEstimatorRPC
    
    private let nodeURL: URL
    
    public static func create(nodeURL: URL, address: ContractHash) -> Contract<
        BlockClient<URLSessionHTTP>,
        BlockContextContractsContractClient<URLSessionHTTP>,
        OperationFeeEstimator<ChainsClient<URLSessionHTTP>>
    > {
        let http = URLSessionHTTP()
        let chains = ChainsClient(parentURL: nodeURL, http: http)
        
        let block = chains.main.blocks.head
        let contract = block.context.contracts(contractID: address.asAddress())
        
        return .init(
            address: address,
            block: block,
            contract: contract,
            feeEstimator: OperationFeeEstimator(chains: chains),
            nodeURL: nodeURL
        )
    }
    
    init(address: ContractHash, block: BlockRPC, contract: ContractRPC, feeEstimator: FeeEstimatorRPC, nodeURL: URL) {
        self.address = address
        self.block = block
        self.contract = contract
        self.feeEstimator = feeEstimator
        self.nodeURL = nodeURL
    }
    
    public lazy var storage: ContractStorage<ContractRPC> = .init(from: codeCached, contract: contract, nodeURL: nodeURL)
    
    private lazy var entrypointsCached: Cached<[String: Micheline]> = .init{ [unowned self] in
        try await self.contract.entrypoints.get(configuredWith: .init(headers: $0)).entrypoints.mapValues { try $0.normalized() }
    }
    public func entrypoint(_ entrypoint: Entrypoint = .default) -> ContractEntrypoint<BlockRPC, FeeEstimatorRPC> {
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
        
        return .init(from: entrypointsLazy, entrypoint: entrypoint, contractAddress: address, block: block, feeEstimator: feeEstimator)
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
              let parameter = try? parameter.asPrim(.type(.parameter)),
              parameter.args.count == 1
        else {
            return nil
        }
        
        return parameter.args[0]
    }
}
