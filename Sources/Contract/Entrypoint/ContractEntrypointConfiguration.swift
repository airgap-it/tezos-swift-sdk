//
//  ContractEntrypointConfiguration.swift
//  
//
//  Created by Julia Samol on 26.07.22.
//

import TezosCore
import TezosRPC

public struct EntrypointCallConfiguration: BaseConfiguration {
    public let branch: BlockHash?
    public let fee: Mutez?
    public let counter: String?
    public let limits: Limits.Operation?
    public let amount: Mutez?
    public let headers: [HTTPHeader]
    
    public init(
        branch: BlockHash? = nil,
        fee: Mutez? = nil,
        counter: String? = nil,
        limits: Limits.Operation? = nil,
        amount: Mutez? = nil,
        headers: [HTTPHeader] = []
    ) {
        self.branch = branch
        self.fee = fee
        self.counter = counter
        self.limits = limits
        self.amount = amount
        self.headers = headers
    }
}
