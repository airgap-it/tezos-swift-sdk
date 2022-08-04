//
//  SaplingState.swift
//  
//
//  Created by Julia Samol on 14.07.22.
//

import TezosCore

// MARK: RPCSaplingStateDiff

public struct RPCSaplingStateDiff: Hashable, Codable {
    public let root: HexString
    public let commitmentsAndCiphertexts: [Tuple<HexString, RPCSaplingCiphertext>]
    public let nullifiers: [HexString]
    
    public init(root: HexString, commitmentsAndCiphertexts: [Tuple<HexString, RPCSaplingCiphertext>], nullifiers: [HexString]) {
        self.root = root
        self.commitmentsAndCiphertexts = commitmentsAndCiphertexts
        self.nullifiers = nullifiers
    }
    
    enum CodingKeys: String, CodingKey {
        case root
        case commitmentsAndCiphertexts = "commitments_and_ciphertexts"
        case nullifiers
    }
}
