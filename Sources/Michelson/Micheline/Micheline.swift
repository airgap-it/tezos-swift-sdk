//
//  Micheline.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import TezosCore

public indirect enum Micheline: Hashable, Codable, MichelineProtocol {
    public typealias `Protocol` = MichelineProtocol
    
    case literal(Literal)
    case prim(PrimitiveApplication)
    case sequence(Sequence)
    
    public func asMicheline() -> Micheline {
        self
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            if container.contains(.prim) {
                self = .prim(try .init(from: decoder))
            } else if container.containsAny(.int, .string, .bytes) {
                self = .literal(try .init(from: decoder))
            } else {
                throw TezosError.invalidValue("Unknown Micheline encoded value.")
            }
        } else {
            self = .sequence(try .init(from: decoder))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .literal(let content):
            try content.encode(to: encoder)
        case .prim(let content):
            try content.encode(to: encoder)
        case .sequence(let content):
            try content.encode(to: encoder)
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case int
        case string
        case bytes
        case prim
    }
}

public protocol MichelineProtocol {
    func asMicheline() -> Micheline
}

// MARK: Utility Extensions

private extension KeyedDecodingContainer {
    func containsAny(_ keys: Key...) -> Bool {
        keys.contains(where: { contains($0) })
    }
}
