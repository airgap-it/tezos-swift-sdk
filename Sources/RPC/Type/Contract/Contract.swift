//
//  Contract.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import Foundation
import TezosCore
import TezosOperation

// MARK: RPCContractDetails

public struct RPCContractDetails: Hashable, Codable {
    public let balance: String
    public let delegate: Address.Implicit?
    public let script: Script?
    public let counter: String?
    
    public init(balance: String, delegate: Address.Implicit? = nil, script: Script? = nil, counter: String? = nil) {
        self.balance = balance
        self.delegate = delegate
        self.script = script
        self.counter = counter
    }
}
