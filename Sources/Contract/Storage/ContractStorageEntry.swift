//
//  ContractStorageEntry.swift
//  
//
//  Created by Julia Samol on 21.07.22.
//

import Foundation

import TezosCore
import TezosMichelson
import TezosRPC
    
public enum ContractStorageEntry: ContractStorageEntryProtocol, Hashable {
    public typealias `Protocol` = ContractStorageEntryProtocol
    
    case value(Value)
    case object(Object)
    case sequence(Sequence)
    case map(Map)
    case bigMap(BigMap)
    
    public var names: Set<String> {
        common.names
    }
    
    public var value: Micheline {
        common.value
    }
    
    public var type: Micheline {
        common.type
    }
    
    init(from value: Micheline, type: Micheline, nodeURL: URL) throws {
        if let bigMapType = try? type.asPrim(.type(.bigMap)),
           case let .literal(integer) = value,
           case let .integer(bigMapValue) = integer
        {
            self = .bigMap(.init(from: bigMapValue, type: bigMapType, nodeURL: nodeURL))
        } else if let sequenceType = try? type.asPrim(.type(.list), .type(.set)),
                  sequenceType.args.count == 1,
                  case let .sequence(sequenceValue) = value
        {
            self = .sequence(try .init(from: sequenceValue, type: sequenceType, elementType: sequenceType.args[0], nodeURL: nodeURL))
        } else if let lambdaType = try? type.asPrim(.type(.lambda)),
                  case let .sequence(lambdaValue) = value
        {
            self = .sequence(try .init(from: lambdaValue, type: lambdaType, nodeURL: nodeURL))
        } else if let mapType = try? type.asPrim(.type(.map)),
                  case let .sequence(mapValue) = value
        {
            self = .map(try .init(from: mapValue, type: mapType, nodeURL: nodeURL))
        } else if let primType = try? type.asPrim(), primType.args.isEmpty {
            self = .value(.init(from: value, type: primType))
        } else if let primType = try? type.asPrim(), let primValue = try? value.asPrim() {
            self = .object(try .init(from: primValue, type: primType, nodeURL: nodeURL))
        } else {
            throw TezosContractError.invalidType("storage type")
        }
    }
    
    public func asStorageEntry() -> ContractStorageEntry {
        self
    }
}

public protocol ContractStorageEntryProtocol {
    var value: Micheline { get }
    var type: Micheline { get }
    
    func asStorageEntry() -> ContractStorageEntry
}

public extension ContractStorageEntry.`Protocol` {
    
    var names: Set<String> {
        guard let type = try? type.asPrim() else {
            return []
        }
        
        return .init(type.annots.map { $0 })
    }
}

// MARK: ContractStorageEntry.Value

extension ContractStorageEntry {
    
    public struct Value: `Protocol`, Hashable {
        public let value: Micheline
        public let type: Micheline
        
        init(from value: Micheline, type: Micheline.PrimitiveApplication) {
            self.init(value: value, type: .prim(type))
        }
        
        init(value: Micheline, type: Micheline) {
            self.value = value
            self.type = type
        }
        
        public func asStorageEntry() -> ContractStorageEntry {
            .value(self)
        }
    }
}

// MARK: ContractStorageEntry.Object

extension ContractStorageEntry {
    
    public struct Object: `Protocol`, Hashable {
        public let value: Micheline
        public let type: Micheline
        
        public let elements: [ContractStorageEntry]
        private let dict: [String: ContractStorageEntry]
        
        init(from value: Micheline.PrimitiveApplication, type: Micheline.PrimitiveApplication, nodeURL: URL) throws {
            guard value.args.count == type.args.count else {
                throw TezosContractError.invalidType("storage object")
            }

            let elements = try zip(value.args, type.args)
                .flatMap { (value) -> [ContractStorageEntry] in
                    let (v, t) = value
                    let entry = try ContractStorageEntry(from: v, type: t, nodeURL: nodeURL)
                    
                    if case let .object(object) = entry, object.names.isEmpty {
                        return .init(object.elements)
                    } else {
                        return [entry]
                    }
                }
            
            self.init(value: .prim(value), type: .prim(type), elements: elements)
        }
        
        init(value: Micheline, type: Micheline, elements: [ContractStorageEntry]) {
            self.value = value
            self.type = type
            self.elements = elements
            self.dict = elements
                .flatMap { (entry) -> [(String, ContractStorageEntry)] in
                    return entry.names.map { name in (name, entry) }
                }
                .reduce(into: [:]) { (dict, next) in
                    dict[next.0] = next.1
                }
        }
        
        public subscript(key: String) -> ContractStorageEntry? {
            dict[key]
        }
        
        public func asStorageEntry() -> ContractStorageEntry {
            .object(self)
        }
    }
}

// MARK: ContractStorageEntry.Sequence

extension ContractStorageEntry {
    
    public struct Sequence: `Protocol`, Hashable {
        public let value: Micheline
        public let type: Micheline
        
        public let elements: [ContractStorageEntry]
        
        init(from value: Micheline.Sequence, type: Micheline.PrimitiveApplication, elementType: Micheline? = nil, nodeURL: URL) throws {
            let values = try value.map {
                try ContractStorageEntry(from: $0, type: elementType ?? .prim(type), nodeURL: nodeURL)
            }
            
            self.init(value: .sequence(value), type: .prim(type), values: values)
        }
        
        init(value: Micheline, type: Micheline, values: [ContractStorageEntry]) {
            self.value = value
            self.type = type
            self.elements = values
        }
        
        public func asStorageEntry() -> ContractStorageEntry {
            .sequence(self)
        }
    }
}

// MARK: ContractStorageEntry.Map

extension ContractStorageEntry {
    
    public struct Map: `Protocol`, Hashable {
        public let value: Micheline
        public let type: Micheline
        
        private let dict: [ContractStorageEntry: ContractStorageEntry]
        
        init(from value: Micheline.Sequence, type: Micheline.PrimitiveApplication, nodeURL: URL) throws {
            guard type.args.count == 2 else {
                throw TezosContractError.invalidType("storage map")
            }
            
            let dict: [ContractStorageEntry: ContractStorageEntry] = try value.reduce(into: [:]) { (dict, next) in
                guard let elt = try? next.asPrim(.data(.elt)), elt.args.count == 2 else {
                    throw TezosContractError.invalidType("storage map value")
                }
                
                let key = try ContractStorageEntry(from: elt.args[0], type: type.args[0], nodeURL: nodeURL)
                let value = try ContractStorageEntry(from: elt.args[1], type: type.args[1], nodeURL: nodeURL)
                
                dict[key] = value
            }
            
            self.init(value: .sequence(value), type: .prim(type), dict: dict)
        }
        
        init(value: Micheline, type: Micheline, dict: [ContractStorageEntry: ContractStorageEntry]) {
            self.value = value
            self.type = type
            self.dict = dict
        }
        
        public subscript(key: ContractStorageEntry) -> ContractStorageEntry? {
            dict[key]
        }
        
        public func asStorageEntry() -> ContractStorageEntry {
            .map(self)
        }
    }
}

// MARK: ContractStorageEntry.BigMap

extension ContractStorageEntry {
    
    public struct BigMap: `Protocol`, BigMapHandler, Hashable {
        public let id: String
        
        public let value: Micheline
        public let type: Micheline
        
        public let nodeURL: URL
        
        init(from value: Micheline.Literal.Integer, type: Micheline.PrimitiveApplication, nodeURL: URL) {
            self.init(id: value.value, value: .literal(.integer(value)), type: .prim(type), nodeURL: nodeURL)
        }
        
        init(id: String, value: Micheline, type: Micheline, nodeURL: URL) {
            self.id = id
            self.value = value
            self.type = type
            self.nodeURL = nodeURL
        }
        
        public func asStorageEntry() -> ContractStorageEntry {
            .bigMap(self)
        }
    }
}

// MARK: Utility Extensions

private extension ContractStorageEntry {
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
        case .bigMap(let bigMap):
            return bigMap
        }
    }
}
