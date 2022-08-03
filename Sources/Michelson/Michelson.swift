//
//  Michelson.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import TezosCore

public indirect enum Michelson: MichelsonProtocol, Hashable {
    public typealias `Protocol` = MichelsonProtocol
    
    case data(Data)
    case type(`Type`)
    
    public var annotations: [Annotation] {
        common.annotations
    }
    
    public func asMichelson() -> Michelson {
        self
    }
}

public protocol MichelsonProtocol {
    var annotations: [Michelson.Annotation] { get }
    
    func asMichelson() -> Michelson
}

// MARK: Prim

extension Michelson {
    
    public enum Prim: Hashable, RawRepresentable {
        public typealias `Protocol` = MichelsonPrimProtocol
        public typealias RawValue = `Protocol`.Type
        
        case data(Data.Prim)
        case type(`Type`.Prim)
        
        public static let allRawValues: [RawValue] = Data.Prim.allRawValues + `Type`.Prim.allRawValues
        
        public init?(rawValue: RawValue) {
            switch rawValue {
            case is Data.Prim.RawValue:
                guard let data = Data.Prim(rawValue: rawValue as! Data.Prim.RawValue) else {
                    return nil
                }
                
                self = .data(data)
            case is `Type`.Prim.RawValue:
                guard let type = `Type`.Prim(rawValue: rawValue as! `Type`.Prim.RawValue) else {
                    return nil
                }
                
                self = .type(type)
            default:
                return nil
            }
        }
        
        public var rawValue: RawValue {
            switch self {
            case .data(let data):
                return data.rawValue
            case .type(let type):
                return type.rawValue
            }
        }
    }
}

public protocol MichelsonPrimProtocol {
    static var name: String { get }
    static var tag: [UInt8] { get }
    
    static func validateArgs(_ args: [Michelson]) throws
    
    init(args: [Michelson], annots: [Michelson.Annotation]) throws
}

// MARK: Annotation

extension Michelson {
    public typealias Annotation = MichelsonAnnotationProtocol
    
    // MARK: TypeAnnotation
    
    public struct TypeAnnotation: Annotation, Hashable {
        public static let prefix: String = ":"
        
        public let value: String
        
        public init(value: String) throws {
            guard Self.isValid(value) else {
                throw TezosError.invalidValue("Invalid TypeAnnotation value.")
            }
            
            self.value = value
        }
    }
    
    // MARK: VariableAnnotation
        
    public struct VariableAnnotation: Annotation, Hashable {
        public static let prefix: String = "@"
        
        public let value: String
        
        public init(value: String) throws {
            guard Self.isValid(value) else {
                throw TezosError.invalidValue("Invalid VariableAnnotation value.")
            }
            
            self.value = value
        }
    }
    
    // MARK: FieldAnnotation
    
    public struct FieldAnnotation: Annotation, Hashable {
        public static let prefix: String = "%"
        
        public let value: String
        
        public init(value: String) throws {
            guard Self.isValid(value) else {
                throw TezosError.invalidValue("Invalid FieldAnnotation value.")
            }
            
            self.value = value
        }
    }
}

public protocol MichelsonAnnotationProtocol {
    static var prefix: String { get }
    var value: String { get }
    
    init(value: String) throws
}

// MARK: Utility Extensions

extension Michelson {
    var common: `Protocol` {
        switch self {
        case .data(let data):
            return data.common
        case .type(let type):
            return type.common
        }
    }
}

public extension Michelson.`Protocol` {
    var annotations: [Michelson.Annotation] { [] }
}

public extension Michelson.Annotation {
    static func isValid(_ value: String) -> Bool {
        value.hasPrefix(Self.prefix)
    }
    
    func matches(_ string: String) -> Bool {
        value.removingPrefix(Self.prefix) == string.removingPrefix(Self.prefix)
    }
}
