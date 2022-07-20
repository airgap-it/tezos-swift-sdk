//
//  TxRollupBond.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import Foundation
import TezosCore

// MARK: TxRollupBondID

public struct TxRollupBondID: Hashable, Codable {
    public let txRollup: TxRollupHash
    
    public init(txRollup: TxRollupHash) {
        self.txRollup = txRollup
    }
    
    enum CodingKeys: String, CodingKey {
        case txRollup = "tx_rollup"
    }
}
