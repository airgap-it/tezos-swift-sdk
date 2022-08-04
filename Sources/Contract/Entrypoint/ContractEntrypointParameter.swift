//
//  ContractEntrypointParameter.swift
//  
//
//  Created by Julia Samol on 27.07.22.
//

import OrderedCollections
import TezosMichelson

public enum ContractEntrypointParameter: ContractEntrypointParameterProtocol, Hashable {
    public typealias `Protocol` = ContractEntrypointParameterProtocol
    
    case value(Value)
    case object(Object)
    case sequence(Sequence)
    case map(Map)
    
    public var name: String? {
        common.name
    }
    
    public func asEntrypointParameter() -> ContractEntrypointParameter {
        self
    }
}

public protocol ContractEntrypointParameterProtocol {
    var name: String? { get }
    
    func asEntrypointParameter() -> ContractEntrypointParameter
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
        
        public func asEntrypointParameter() -> ContractEntrypointParameter {
            .value(self)
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
        
        public func asEntrypointParameter() -> ContractEntrypointParameter {
            .object(self)
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
        
        public func asEntrypointParameter() -> ContractEntrypointParameter {
            .sequence(self)
        }
    }
}

// MARK: ContractEntryParameter.Map

extension ContractEntrypointParameter {
    
    public struct Map: `Protocol`, Hashable {
        public let elements: OrderedDictionary<ContractEntrypointParameter, ContractEntrypointParameter>
        public let name: String?
        
        public init(_ elements: OrderedDictionary<ContractEntrypointParameter, ContractEntrypointParameter>, name: String? = nil) {
            self.elements = elements
            self.name = name
        }
        
        public func asEntrypointParameter() -> ContractEntrypointParameter {
            .map(self)
        }
    }
}

// MARK: Utility Extensions

private extension ContractEntrypointParameter {
    
    var common: `Protocol` {
        switch self {
        case .value(let value):
            return value
        case .object(let object):
            return object
        case .sequence(let sequence):
            return sequence
        case .map(let map):
            return map
        }
    }
}
