//
//  Michelson.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation
import TezosCore

public indirect enum Michelson: Hashable {
    public typealias `Protocol` = MichelsonProtocol
    
    case data(Data)
    case type(`Type`)
}

public protocol MichelsonProtocol {
    var annotations: [Michelson.Annotation] { get }
    
    func asMichelson() -> Michelson
}

// MARK: Prim

extension Michelson {
    public typealias Prim = MichelsonPrimProtocol
    
    public static var allPrims: [Prim.Type] {
        Data.allPrims + `Type`.allPrims
    }
}

public protocol MichelsonPrimProtocol {
    static var name: String { get }
    static var tag: [UInt8] { get }
    
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
