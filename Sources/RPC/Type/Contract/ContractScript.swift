//
//  ContractScript.swift
//  
//
//  Created by Julia Samol on 12.07.22.
//

// MARK: ScriptParsing

public enum RPCScriptParsing: String, Hashable, Codable {
    case readable = "Readable"
    case optimized = "Optimized"
    case optimizedLegacy = "Optimized_legacy"
}
