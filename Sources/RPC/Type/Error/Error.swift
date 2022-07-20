//
//  Error.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import Foundation

// MARK: Error

public struct RPCError: Hashable, Codable {
    public let kind: Kind
    public let id: String
    public let details: [String: String]?
    
    public init(kind: Kind, id: String, details: [String:String]? = nil) {
        self.kind = kind
        self.id = id
        self.details = details
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let kind = try container.decode(Kind.self, forKey: .kind)
        let id = try container.decode(String.self, forKey: .id)
        
        var details = try [String: String](from: decoder)
        details.removeKnownValues(keyedBy: CodingKeys.self)
        
        self.init(kind: kind, id: id, details: details.isEmpty ? nil : details)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(kind, forKey: .kind)
        try container.encode(id, forKey: .id)
        
        if let details = details {
            try details.encode(to: encoder)
        }
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case kind
        case id
    }
    
    // MARK: Kind
    
    public enum Kind: RawRepresentable, Hashable, Codable {
        private static let branchRaw: String = "branch"
        private static let temporaryRaw: String = "temporary"
        private static let permanentRaw: String = "permanent"
        
        case branch
        case temporary
        case permanent
        case unknown(_ name: String)
        
        // MARK: RawRepresentable
        
        public typealias RawValue = String
        
        public init?(rawValue: String) {
            switch rawValue {
            case Self.branchRaw:
                self = .branch
            case Self.temporaryRaw:
                self = .temporary
            case Self.permanentRaw:
                self = .permanent
            default:
                self = .unknown(rawValue)
            }
        }
        
        public var rawValue: String {
            switch self {
            case .branch:
                return Self.branchRaw
            case .temporary:
                return Self.temporaryRaw
            case .permanent:
                return Self.permanentRaw
            case .unknown(let name):
                return name
            }
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let rawValue = try String(from: decoder)
            self.init(rawValue: rawValue)!
        }
        
        public func encode(to encoder: Encoder) throws {
            try rawValue.encode(to: encoder)
        }
    }
}

// MARK: Utility Extensions

private extension Dictionary where Key == String {
    mutating func removeKnownValues<T: CodingKey & CaseIterable & RawRepresentable>(keyedBy keys: T.Type) where T.RawValue == String {
        keys.allCases.forEach {
            removeValue(forKey: $0.rawValue)
        }
    }
}
