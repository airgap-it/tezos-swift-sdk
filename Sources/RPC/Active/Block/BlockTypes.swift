//
//  BlockTypes.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation

// MARK: ../<block_id>/context/contracts/<contract_id>/script/normalized

public struct GetContractNormalizedScriptRequest: Hashable, Codable {
    public let unparsingMode: RPCScriptParsing
    
    public init(unparsingMode: RPCScriptParsing) {
        self.unparsingMode = unparsingMode
    }
    
    enum CodingKeys: String, CodingKey {
        case unparsingMode = "unparsing_mode"
    }
}

// MARK: ../<block_id>/context/contracts/<contract_id>/storage/normalized

public struct GetContractNormalizedStorageRequest: Hashable, Codable {
    public let unparsingMode: RPCScriptParsing
    
    public init(unparsingMode: RPCScriptParsing) {
        self.unparsingMode = unparsingMode
    }
    
    enum CodingKeys: String, CodingKey {
        case unparsingMode = "unparsing_mode"
    }
}
