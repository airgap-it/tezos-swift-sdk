//
//  ContractEntrypointParameter.swift
//  
//
//  Created by Julia Samol on 27.07.22.
//

import TezosMichelson

public enum ContractEntrypointParameter: ContractEntrypointParameterProtocol, Hashable {
    public typealias `Protocol` = ContractEntrypointParameterProtocol
    
    case value(Value)
    case object(Object)
    case sequence(Sequence)
    case map(Map)
    
    public var name: String? {
        switch self {
        case .value(let value):
            return value.name
        case .object(let object):
            return object.name
        case .sequence(let sequence):
            return sequence.name
        case .map(let map):
            return map.name
        }
    }
}

public protocol ContractEntrypointParameterProtocol {
    var name: String? { get }
}

// MARK: ContractEntryParameter.Value

extension ContractEntrypointParameter {
    
    public struct Value: `Protocol`, Hashable {
        public let value: Micheline?
        public let name: String?
        
        public init(_ value: Micheline? = nil, name: String? = nil) {
            self.value = value
            self.name = name
        }
    }
}

// MARK: ContractEntryParameter.Object

extension ContractEntrypointParameter {
    
    public struct Object: `Protocol`, Hashable {
        public internal(set) var elements: [ContractEntrypointParameter]
        public let name: String?
        
        let fields: Set<String>
        
        public init(_ elements: ContractEntrypointParameter..., name: String? = nil) {
            self.init(elements: elements, name: name)
        }
        
        public init(elements: [ContractEntrypointParameter], name: String? = nil) {
            self.elements = elements
            self.name = name
            self.fields = .init(elements.compactMap({ $0.name }))
        }
    }
}

// MARK: ContractEntryParameter.Sequence

extension ContractEntrypointParameter {
    
    public struct Sequence: `Protocol`, Hashable {
        public let elements: [ContractEntrypointParameter]
        public let name: String?
        
        public init(_ elements: ContractEntrypointParameter..., name: String? = nil) {
            self.elements = elements
            self.name = name
        }
    }
}

// MARK: ContractEntryParameter.Map

extension ContractEntrypointParameter {
    
    public struct Map: `Protocol`, Hashable {
        public let elements: [ContractEntrypointParameter: ContractEntrypointParameter]
        public let name: String?
        
        public init(_ elements: [ContractEntrypointParameter: ContractEntrypointParameter], name: String? = nil) {
            self.elements = elements
            self.name = name
        }
    }
}
