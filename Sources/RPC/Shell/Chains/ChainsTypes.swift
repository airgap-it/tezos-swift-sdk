//
//  ChainsTypes.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

// MARK: /chains/<chain_id>

public struct SetBootstrappedRequest: Hashable, Codable {
    public let bootstrapped: Bool
    
    public init(bootstrapped: Bool) {
        self.bootstrapped = bootstrapped
    }
}
