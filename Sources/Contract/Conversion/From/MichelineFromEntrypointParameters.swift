//
//  MichelineFromEntrypointParameters.swift
//  
//
//  Created by Julia Samol on 27.07.22.
//

import TezosCore
import TezosMichelson

extension Micheline {
    
    init(from parameter: ContractEntrypointParameter, code: Micheline) throws {
        let meta = try ContractEntrypointParameter.Meta(from: code)
        try self.init(from: parameter, meta: meta)
    }
}

private extension Micheline {
    init(from parameter: ContractEntrypointParameter, meta: ContractEntrypointParameter.Meta) throws {
        switch meta {
        case .value(let value):
            try self.init(from: parameter, meta: value)
        case .object(let object):
            try self.init(from: parameter, meta: object)
        case .sequence(let sequence):
            try self.init(from: parameter, meta: sequence)
        case .map(let map):
            try self.init(from: parameter, meta: map)
        }
    }
    
    init(from parameter: ContractEntrypointParameter, meta: ContractEntrypointParameter.Meta.Value) throws {
        switch parameter {
        case .value(let value):
            guard let value = value.value else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = value
        case .object(var object):
            guard let named = meta.findValue(&object) else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            try self.init(from: named, meta: meta)
        default:
            throw TezosError.invalidValue("value and type mismatched")
        }
    }
    
    init(from parameter: ContractEntrypointParameter, meta: ContractEntrypointParameter.Meta.Object) throws {
        if let _ = try? meta.type.asPrim(Michelson._Type.Pair.self, Michelson.ComparableType.Pair.self) {
            try self.init(from: parameter, pairMeta: meta)
        } else if let _ = try? meta.type.asPrim(Michelson._Type.Option.self, Michelson.ComparableType.Option.self) {
            try self.init(from: parameter, optionMeta: meta)
        } else if let _ = try? meta.type.asPrim(Michelson._Type.Or.self, Michelson.ComparableType.Or.self) {
            try self.init(from: parameter, orMeta: meta)
        } else {
            try self.init(from: parameter, simpleObjectMeta: meta)
        }
    }
    
    init(from parameter: ContractEntrypointParameter, meta: ContractEntrypointParameter.Meta.Sequence) throws {
        switch parameter {
        case .value(let value):
            guard let value = value.asSequence() else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = value
        case .object(var object):
            guard let named = meta.findValue(&object) ?? object.findFirstSequence() else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = try .init(from: named, meta: meta)
        case .sequence(let sequence):
            guard meta.elements.count == 1 else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = .sequence(try sequence.elements.map({ try .init(from: $0, meta: meta.elements[0]) }))
        case .map(_):
            throw TezosError.invalidValue("value and type mismatched")
        }
    }
    
    init(from parameter: ContractEntrypointParameter, meta: ContractEntrypointParameter.Meta.Map) throws {
        switch parameter {
        case .value(let value):
            guard let value = value.asSequence(of: Michelson.Data.Elt.self) else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = value
        case .object(var object):
            guard let named = meta.findValue(&object) ?? object.findFirstMap() else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = try .init(from: named, meta: meta)
        case .map(let sequence):
            self = .sequence(try sequence.elements.map({
                .prim(.init(
                    prim: Michelson.Data.Elt.self,
                    args: [
                        try .init(from: $0.key, meta: meta.key),
                        try .init(from: $0.value, meta: meta.value)
                    ]
                ))
            }))
        case .sequence(_):
            throw TezosError.invalidValue("value and type mismatched")
        }
    }
    
    init(from parameter: ContractEntrypointParameter, pairMeta meta: ContractEntrypointParameter.Meta.Object) throws {
        switch parameter {
        case .value(let value):
            if let value = try? value.value?.asPrim(Michelson.Data.Pair.self) {
                self = .prim(value)
            } else {
                guard let namedMeta = value.findNextMeta(meta) else {
                    throw TezosError.invalidValue("value and type mismatched")
                }
                
                try self.init(from: .value(value), meta: namedMeta)
            }
        case .object(var object):
            guard meta.elements.count == 2 else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            guard let first = try meta.createArgMicheline(from: &object), let second = try meta.createArgMicheline(from: &object) else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = .prim(.init(
                prim: Michelson.Data.Pair.self,
                args: [first, second]
            ))
        default:
            throw TezosError.invalidValue("value and type mismatched")
        }
    }
    
    init(from parameter: ContractEntrypointParameter, optionMeta meta: ContractEntrypointParameter.Meta.Object) throws {
        switch parameter {
        case .value(let value):
            if let value = value.value {
                self = .prim(.init(
                    prim: Michelson.Data.Some.self,
                    args: [value]
                ))
            } else {
                self = .prim(.init(prim: Michelson.Data.None.self))
            }
        case .object(var object):
            guard meta.elements.count == 1 else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            guard let arg = try { () -> Micheline? in
                guard !object.elements.isEmpty else {
                    return nil
                }
                
                return try meta.elements[0].createArgMicheline(from: &object)
            }() else {
                self = .prim(.init(prim: Michelson.Data.None.self))
                return
            }
            
            self = .prim(.init(
                prim: Michelson.Data.Some.self,
                args: [arg]
            ))
        default:
            throw TezosError.invalidValue("value and type mismatched")
        }
    }
    
    init(from parameter: ContractEntrypointParameter, orMeta meta: ContractEntrypointParameter.Meta.Object) throws {
        switch parameter {
        case .value(let value):
            if let value = try? value.value?.asPrim(Michelson.Data.Left.self, Michelson.Data.Right.self) {
                self = .prim(value)
            } else {
                guard let namedMeta = value.findNextMeta(meta) else {
                    throw TezosError.invalidValue("value and type mismatched")
                }
                
                self = try namedMeta.createDirectedMicheline(from: .value(value))
            }
        case .object(let object):
            guard let reducedMeta = meta.extract(object) else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = try reducedMeta.createDirectedMicheline(from: .object(object))
        default:
            throw TezosError.invalidValue("value and type mismatched")
        }
    }
    
    init(from parameter: ContractEntrypointParameter, simpleObjectMeta meta: ContractEntrypointParameter.Meta.Object) throws {
        switch parameter {
        case .value(let value):
            guard let namedMeta = value.findNextMeta(meta) else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = try .init(from: .value(value), meta: namedMeta)
        case .object(let object):
            guard meta.elements.count == 1 else {
                throw TezosError.invalidValue("value and type mismatched")
            }
            
            self = try .init(from: .object(object), meta: meta.elements[0])
        default:
            throw TezosError.invalidValue("value and type mismatched")
        }
    }
}

// MARK: ContractEntrypointParameter.Meta

private extension ContractEntrypointParameter {
    
    indirect enum Meta: ContractEntrypointParameterMetaProtocol {
        typealias `Protocol` = ContractEntrypointParameterMetaProtocol
        
        case value(Value)
        case object(Object)
        case sequence(Sequence)
        case map(Map)
        
        init(from code: Micheline, trace: Micheline.Trace = .root()) throws {
            guard let primCode = try? code.asPrim() else {
                throw TezosError.invalidValue("entrypoint code")
            }
            
            try self.init(from: primCode)
        }
        
        private init(from code: Micheline.PrimitiveApplication, trace: Micheline.Trace = .root()) throws {
            if code.args.isEmpty || (try? code.asPrim(Michelson._Type.BigMap.self, Michelson._Type.Lambda.self)) != nil {
                self = .value(.init(type: .prim(code), trace: trace))
            } else if let type = try? code.asPrim(Michelson._Type.List.self, Michelson._Type.Set.self) {
                guard type.args.count == 1 else {
                    throw TezosError.invalidValue("entrypoint code")
                }
                
                self = .sequence(.init(
                    type: .prim(type),
                    trace: trace,
                    elements: [try .init(from: type.args[0], trace: .node(.init(0)))]
                ))
            } else if let type = try? code.asPrim(Michelson._Type.Map.self) {
                guard type.args.count == 2 else {
                    throw TezosError.invalidValue("entrypoint code")
                }
                
                self = .map(.init(
                    type: .prim(type),
                    trace: trace,
                    key: try .init(from: type.args[0], trace: .node(.init(0))),
                    value: try .init(from: type.args[1], trace: .node(.init(1)))
                ))
            } else if let type = try? code.asPrim(Michelson._Type.allPrims), !type.args.isEmpty {
                guard type.args.count <= 2 else {
                    throw TezosError.invalidValue("entrypoint code")
                }
                
                self = .object(.init(
                    type: .prim(type),
                    trace: trace,
                    elements: try type.args.enumerated().map { try .init(from: $1, trace: .node(.init($0))) }
                ))
            } else {
                throw TezosError.invalidValue("entrypoint code")
            }
        }
        
        var type: Micheline {
            switch self {
            case .value(let value):
                return value.type
            case .object(let object):
                return object.type
            case .sequence(let sequence):
                return sequence.type
            case .map(let map):
                return map.type
            }
        }
        
        var trace: Micheline.Trace {
            switch self {
            case .value(let value):
                return value.trace
            case .object(let object):
                return object.trace
            case .sequence(let sequence):
                return sequence.trace
            case .map(let map):
                return map.trace
            }
        }
        
        var namedTraces: [String: Micheline.Trace] {
            switch self {
            case .object(let object):
                return object.namedTraces
            default:
                return names.reduce(into: [:]) { (acc, name) in
                    acc[name] = trace
                }
            }
        }
        
        func trace(name: String) -> Micheline.Trace? {
            switch self {
            case .value(let value):
                return value.trace(name: name)
            case .object(let object):
                return object.trace(name: name)
            case .sequence(let sequence):
                return sequence.trace(name: name)
            case .map(let map):
                return map.trace(name: name)
            }
        }
        
        func asMeta() -> ContractEntrypointParameter.Meta {
            self
        }
    }
}

private extension ContractEntrypointParameter.Meta {
    
    struct Value: `Protocol` {
        let type: Micheline
        let trace: Micheline.Trace
        
        func trace(name: String) -> Micheline.Trace? {
            guard names.contains(name) else {
                return nil
            }
            
            return trace
        }
        
        func asMeta() -> ContractEntrypointParameter.Meta {
            .value(self)
        }
    }
}

private extension ContractEntrypointParameter.Meta {
    
    class Object: `Protocol` {
        let type: Micheline
        let trace: Micheline.Trace
        
        let elements: [ContractEntrypointParameter.Meta]
        lazy var namedTraces: [String: Micheline.Trace] = {
            guard names.isEmpty else {
                return names.reduce(into: [:]) { (acc, name) in
                    acc[name] = trace
                }
            }
            
            return elements
                .map { element in element.namedTraces.mapValues { element.trace + $0 } }
                .reduce(into: [:]) { (acc, next) in acc.merge(next, uniquingKeysWith: { $1 }) }
        }()
        
        init(type: Micheline, trace: Micheline.Trace, elements: [ContractEntrypointParameter.Meta]) {
            self.type = type
            self.trace = trace
            self.elements = elements
        }
        
        func trace(name: String) -> Micheline.Trace? {
            namedTraces[name]
        }
        
        func asMeta() -> ContractEntrypointParameter.Meta {
            .object(self)
        }
    }
}

private extension ContractEntrypointParameter.Meta {
    
    struct Sequence: `Protocol` {
        let type: Micheline
        let trace: Micheline.Trace
        
        let elements: [ContractEntrypointParameter.Meta]
        
        func trace(name: String) -> Micheline.Trace? {
            nil
        }
        
        func asMeta() -> ContractEntrypointParameter.Meta {
            .sequence(self)
        }
    }
}

private extension ContractEntrypointParameter.Meta {
    
    struct Map: `Protocol` {
        let type: Micheline
        let trace: Micheline.Trace
        
        let key: ContractEntrypointParameter.Meta
        let value: ContractEntrypointParameter.Meta
        
        func trace(name: String) -> Micheline.Trace? {
            nil
        }
        
        func asMeta() -> ContractEntrypointParameter.Meta {
            .map(self)
        }
    }
}

private protocol ContractEntrypointParameterMetaProtocol {
    var type: Micheline { get }
    var trace: Micheline.Trace { get }
    
    func trace(name: String) -> Micheline.Trace?
    
    func asMeta() -> ContractEntrypointParameter.Meta
}

private extension ContractEntrypointParameter.Meta.`Protocol` {
    var names: Set<String> {
        guard let primType = try? type.asPrim() else {
            return []
        }
        
        return .init(primType.annots)
    }
}

// MARK: Micheline.Trace

private extension Micheline {
    
    indirect enum Trace {
        case root(Root = .init())
        case node(Node)
        
        static func +(lhs: Trace, rhs: Trace) -> Trace {
            switch lhs {
            case .root(let root):
                return .root(root + rhs)
            case .node(let node):
                return .node(node + rhs)
            }
        }
        
        func hasNext() -> Bool {
            switch self {
            case .root(let root):
                return root.next != nil
            case .node(let node):
                return node.next != nil
            }
        }
    }
}

private extension Micheline.Trace {
    
    struct Root {
        let next: Micheline.Trace?
        
        init(next: Micheline.Trace? = nil) {
            self.next = next
        }
        
        static func +(lhs: Root, rhs: Micheline.Trace) -> Root {
            let next: Micheline.Trace = {
                if let lhsNext = lhs.next {
                    return lhsNext + rhs
                } else {
                    return rhs
                }
            }()
            
            return .init(next: next)
        }
    }
}

private extension Micheline.Trace {
    
    struct Node {
        let direction: Direction
        let next: Micheline.Trace?
        
        init(direction: Direction, next: Micheline.Trace? = nil) {
            self.direction = direction
            self.next = next
        }
        
        init(_ directionRawValue: Int, next: Micheline.Trace? = nil) {
            self.direction = .init(rawValue: directionRawValue % Direction.allCases.count)!
            self.next = next
        }
        
        static func +(lhs: Node, rhs: Micheline.Trace) -> Node {
            let next: Micheline.Trace = {
                if let lhsNext = lhs.next {
                    return lhsNext + rhs
                } else {
                    return rhs
                }
            }()
            
            return .init(direction: lhs.direction, next: next)
        }
        
        enum Direction: Int, CaseIterable {
            case left = 0
            case right = 1
        }
    }
}

// MARK: Utility Extensions

private extension ContractEntrypointParameter.`Protocol` {
    
    func findNextMeta(_ meta: ContractEntrypointParameter.Meta.Object) -> ContractEntrypointParameter.Meta? {
        guard let name = name else {
            return nil
        }
        
        let trace = meta.trace(name: name)
        switch trace {
        case .node(let node):
            return meta.elements[node.direction.rawValue]
        default:
            return nil
        }
    }
}

private extension ContractEntrypointParameter.Value {
    
    func asSequence(of prim: Michelson.Prim.Type? = nil) -> Micheline? {
        guard let value = value, case let .sequence(sequence) = value else {
            return nil
        }
        
        guard let prim = prim else {
            return .sequence(sequence)
        }
        
        guard sequence.allSatisfy({ (try? $0.asPrim(prim)) != nil }) else {
            return nil
        }
        
        return .sequence(sequence)
    }
}

private extension ContractEntrypointParameter.Object {
    
    mutating func findFirstSequence() -> ContractEntrypointParameter? {
        elements.consume {
            if case .sequence(_) = $0 {
                return true
            } else {
                return false
            }
        }
    }
    
    mutating func findFirstMap() -> ContractEntrypointParameter? {
        elements.consume {
            if case .map(_) = $0 {
                return true
            } else {
                return false
            }
        }
    }
    
    mutating func extract(using meta: ContractEntrypointParameter.Meta) -> ContractEntrypointParameter? {
        let reducedElements = elements.consumeAll(where: { meta.describes($0) })
        
        if reducedElements.isEmpty {
            switch meta {
            case .value(_):
                return elements.consume(at: 0)
            default:
                return .object(self)
            }
        } else if reducedElements.count == 1, let name = reducedElements[0].name, let trace = meta.trace(name: name), !trace.hasNext() {
            return reducedElements[0]
        } else {
            return .object(.init(elements: reducedElements))
        }
    }
}

private extension ContractEntrypointParameter.Meta {
    
    func describes(_ value: ContractEntrypointParameter) -> Bool {
        guard let name = value.name else {
            return false
        }
        
        switch self {
        case .object(let object):
            return object.names.contains(name) || object.namedTraces.contains(where: { $0.key == name })
        default:
            return names.contains(name)
        }
    }
}

private extension ContractEntrypointParameter.Meta.`Protocol` {
    
    func findValue(_ value: inout ContractEntrypointParameter.Object) -> ContractEntrypointParameter? {
        value.elements.consume {
            guard let name = $0.name else {
                return false
            }
            
            return names.contains(name)
        }
    }
    
    func createArgMicheline(from value: inout ContractEntrypointParameter.Object) throws -> Micheline? {
        guard let arg = value.extract(using: asMeta()) else {
            return nil
        }
        
        
        return try .init(from: arg, meta: asMeta())
    }
    
    func createDirectedMicheline(from value: ContractEntrypointParameter) throws -> Micheline {
        guard let prim = trace.directedPrim() else {
            throw TezosError.invalidValue("entrypoint code")
        }
        
        return .prim(try .init(
            prim: prim.name,
            args: [
                try .init(from: value, meta: asMeta())
            ]
        ))
    }
}

private extension ContractEntrypointParameter.Meta.Object {
    
    func extract(_ value: ContractEntrypointParameter.Object) -> ContractEntrypointParameter.Meta? {
        var namedValues: [Micheline.Trace] = namedTraces
            .compactMap {
                if value.fields.contains($0.key) {
                    return $0.value
                } else {
                    return nil
                }
            }
        
        if namedValues.isEmpty {
            namedValues = [.node(.init(0))]
        }
        
        guard let direction = namedValues
            .map({ (trace) -> Micheline.Trace.Node.Direction? in
                switch trace {
                case .root(_):
                    return nil
                case .node(let node):
                    return node.direction
                }
            })
            .reversed()
            .reduce(nil, { (acc, next) -> Micheline.Trace.Node.Direction? in
                if next != acc {
                    return nil
                } else {
                    return next
                }
            })
        else {
            return nil
        }
        
        return elements[safe: direction.rawValue]
    }
}

private extension Micheline.Trace {
    
    func directedPrim() -> Michelson.Prim.Type? {
        switch self {
        case .root(_):
            return nil
        case .node(let node):
            switch node.direction {
            case .left:
                return Michelson.Data.Left.self
            case .right:
                return Michelson.Data.Right.self
            }
        }
    }
}
