//
//  ContractStorageEntry.swift
//  
//
//  Created by Julia Samol on 21.07.22.
//

import TezosCore
import TezosMichelson
import TezosRPC
    
public enum ContractStorageEntry: Hashable {
    public typealias `Protocol` = ContractStorageEntryProtocol
    
    case value(Value)
    case object(Object)
    case sequence(Sequence)
    case map(Map)
    case bigMap(BigMap)
    
    public var names: Set<String> {
        switch self {
        case .value(let value):
            return value.names
        case .object(let object):
            return object.names
        case .sequence(let sequence):
            return sequence.names
        case .map(let map):
            return map.names
        case .bigMap(let bigMap):
            return bigMap.names
        }
    }
    
    public var value: Micheline {
        switch self {
        case .value(let value):
            return value.value
        case .object(let object):
            return object.value
        case .sequence(let sequence):
            return sequence.value
        case .map(let map):
            return map.value
        case .bigMap(let bigMap):
            return bigMap.value
        }
    }
    
    public var type: Micheline {
        switch self {
        case .value(let value):
            return value.type
        case .object(let object):
            return object.type
        case .sequence(let sequence):
            return sequence.type
        case .map(let map):
            return map.type
        case .bigMap(let bigMap):
            return bigMap.type
        }
    }
    
    init(from value: Micheline, type: Micheline) throws {
        if let bigMapType = try? type.asPrim(Michelson._Type.BigMap.self),
           case let .literal(integer) = value,
           case let .integer(bigMapValue) = integer
        {
            self = .bigMap(.init(from: bigMapValue, type: bigMapType))
        } else if let sequenceType = try? type.asPrim(Michelson._Type.List.self, Michelson._Type.Set.self),
                  sequenceType.args.count == 1,
                  case let .sequence(sequenceValue) = value
        {
            self = .sequence(try .init(from: sequenceValue, type: sequenceType, elementType: sequenceType.args[0]))
        } else if let lambdaType = try? type.asPrim(Michelson._Type.Lambda.self),
                  case let .sequence(lambdaValue) = value
        {
            self = .sequence(try .init(from: lambdaValue, type: lambdaType))
        } else if let mapType = try? type.asPrim(Michelson._Type.Map.self),
                  case let .sequence(mapValue) = value
        {
            self = .map(try .init(from: mapValue, type: mapType))
        } else if let primType = try? type.asPrim(), primType.args.isEmpty {
            self = .value(.init(from: value, type: primType))
        } else if let primType = try? type.asPrim(), let primValue = try? value.asPrim() {
            self = .object(try .init(from: primValue, type: primType))
        } else {
            throw TezosContractError.invalidType("storage type")
        }
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
    }
}

// MARK: ContractStorageEntry.Object

extension ContractStorageEntry {
    
    public struct Object: `Protocol`, Hashable {
        public let value: Micheline
        public let type: Micheline
        
        public let elements: [ContractStorageEntry]
        private let dict: [String: ContractStorageEntry]
        
        init(from value: Micheline.PrimitiveApplication, type: Micheline.PrimitiveApplication) throws {
            guard value.args.count == type.args.count else {
                throw TezosContractError.invalidType("storage object")
            }

            let elements = try zip(value.args, type.args)
                .flatMap { (value) -> [ContractStorageEntry] in
                    let (v, t) = value
                    let entry = try ContractStorageEntry(from: v, type: t)
                    
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
        
        subscript(key: String) -> ContractStorageEntry? {
            dict[key]
        }
    }
}

// MARK: ContractStorageEntry.Sequence

extension ContractStorageEntry {
    
    public struct Sequence: `Protocol`, Hashable {
        public let value: Micheline
        public let type: Micheline
        
        public let elements: [ContractStorageEntry]
        
        init(from value: Micheline.Sequence, type: Micheline.PrimitiveApplication, elementType: Micheline? = nil) throws {
            let values = try value.map {
                try ContractStorageEntry(from: $0, type: elementType ?? .prim(type))
            }
            
            self.init(value: .sequence(value), type: .prim(type), values: values)
        }
        
        init(value: Micheline, type: Micheline, values: [ContractStorageEntry]) {
            self.value = value
            self.type = type
            self.elements = values
        }
    }
}

// MARK: ContractStorageEntry.Map

extension ContractStorageEntry {
    
    public struct Map: `Protocol`, Hashable {
        public let value: Micheline
        public let type: Micheline
        
        private let dict: [ContractStorageEntry: ContractStorageEntry]
        
        init(from value: Micheline.Sequence, type: Micheline.PrimitiveApplication) throws {
            guard type.args.count == 2 else {
                throw TezosContractError.invalidType("storage map")
            }
            
            let dict: [ContractStorageEntry: ContractStorageEntry] = try value.reduce(into: [:]) { (dict, next) in
                guard let elt = try? next.asPrim(Michelson.Data.Elt.self), elt.args.count == 2 else {
                    throw TezosContractError.invalidType("storage map value")
                }
                
                let key = try ContractStorageEntry(from: elt.args[0], type: type.args[0])
                let value = try ContractStorageEntry(from: elt.args[1], type: type.args[1])
                
                dict[key] = value
            }
            
            self.init(value: .sequence(value), type: .prim(type), dict: dict)
        }
        
        init(value: Micheline, type: Micheline, dict: [ContractStorageEntry: ContractStorageEntry]) {
            self.value = value
            self.type = type
            self.dict = dict
        }
        
        subscript(key: ContractStorageEntry) -> ContractStorageEntry? {
            dict[key]
        }
    }
}

// MARK: ContractStorageEntry.BigMap

extension ContractStorageEntry {
    
    public struct BigMap: `Protocol`, BigMapHandler, Hashable {
        public let id: String
        
        public let value: Micheline
        public let type: Micheline
        
        init(from value: Micheline.Literal.Integer, type: Micheline.PrimitiveApplication) {
            self.init(id: value.value, value: .literal(.integer(value)), type: .prim(type))
        }
        
        init(id: String, value: Micheline, type: Micheline) {
            self.id = id
            self.value = value
            self.type = type
        }
    }
}

// MARK: Protocol

public protocol ContractStorageEntryProtocol {
    var value: Micheline { get }
    var type: Micheline { get }
}

public extension ContractStorageEntry.`Protocol` {
    
    var names: Set<String> {
        guard let type = try? type.asPrim() else {
            return []
        }
        
        return .init(type.annots.map { $0 })
    }
}
