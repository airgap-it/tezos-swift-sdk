//
//  MichelineLiteral.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import TezosCore

extension Micheline {
    
    public enum Literal: Hashable, Codable, MichelineLiteralProtocol {
        public typealias `Protocol` = MichelineLiteralProtocol
        
        case integer(Integer)
        case string(String)
        case bytes(Bytes)
        
        public func asMichelineLiteral() -> Micheline.Literal {
            self
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.int) {
                self = .integer(try Integer(from: decoder))
            } else if container.contains(.string) {
                self = .string(try String(from: decoder))
            } else if container.contains(.bytes) {
                self = .bytes(try Bytes(from: decoder))
            } else {
                throw TezosError.invalidValue("Invalid Micheline literal encoded value.")
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            switch self {
            case .integer(let content):
                try content.encode(to: encoder)
            case .string(let content):
                try content.encode(to: encoder)
            case .bytes(let content):
                try content.encode(to: encoder)
            }
        }
        
        public enum CodingKeys: Swift.String, CodingKey {
            case int
            case string
            case bytes
        }
        
        // MARK: Int
        
        public struct Integer: `Protocol`, BigIntWrapper, Hashable, Codable {
            public let value: Swift.String
            
            public init<S: StringProtocol>(_ value: S) throws {
                guard Self.isValid(value: value) else {
                    throw TezosError.invalidValue("Invalid Micheline integer literal value.")
                }
                
                self.value = Swift.String(value)
            }
            
            public func asMichelineLiteral() -> Micheline.Literal {
                .integer(self)
            }
            
            // MARK: Codable
            
            public enum CodingKeys: Swift.String, CodingKey {
                case value = "int"
            }
        }
        
        // MARK: String
        
        public struct String: `Protocol`, StringWrapper, Hashable, Codable {
            public static let regex: Swift.String = #"^(\"|\r|\n|\t|\b|\\|[^\"\\])*$"#
            
            public let value: Swift.String
            
            public init<S: StringProtocol>(_ value: S) throws {
                guard Self.isValid(value: value) else {
                    throw TezosError.invalidValue("Invalid Micheline string literal value.")
                }
                
                self.value = Swift.String(value)
            }
            
            public func asMichelineLiteral() -> Micheline.Literal {
                .string(self)
            }
            
            // MARK: Codable
            
            public enum CodingKeys: Swift.String, CodingKey {
                case value = "string"
            }
        }
        
        // MARK: Bytes
        
        public struct Bytes: `Protocol`, BytesWrapper, Hashable, Codable {
            public static let regex: Swift.String = HexString.regex(withPrefix: .required)
            
            public let value: Swift.String
            
            public init<S: StringProtocol>(_ value: S) throws {
                guard Self.isValid(value: value) else {
                    throw TezosError.invalidValue("Invalid Micheline bytes literal value.")
                }
                
                self.value = Swift.String(value)
            }
            
            public init(_ value: [UInt8]) {
                self.value = Swift.String(HexString(from: value), withPrefix: true)
            }
            
            public func asMichelineLiteral() -> Micheline.Literal {
                .bytes(self)
            }
            
            // MARK: Codable
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let bytes = try container.decode(Swift.String.self, forKey: .value)
                
                try self.init(Swift.String(HexString(from: bytes), withPrefix: true))
            }
            
            public func encode(to encoder: Encoder) throws {
                let hex = try HexString(from: value)
                
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(Swift.String(hex, withPrefix: false), forKey: .value)
            }
            
            public enum CodingKeys: Swift.String, CodingKey {
                case value = "bytes"
            }
        }
    }
}

public protocol MichelineLiteralProtocol: Micheline.`Protocol` {
    func asMichelineLiteral() -> Micheline.Literal
}

public extension Micheline.Literal.`Protocol` {
    func asMicheline() -> Micheline {
        .literal(asMichelineLiteral())
    }
}
