//
//  MichelineToBytes.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation
import TezosCore

// MARK: Micheline

extension Micheline: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        if Literal.recognizesTag(bytes) {
            self = .literal(try .init(fromConsuming: &bytes))
        } else if PrimitiveApplication.recognizesTag(bytes) {
            self = .prim(try .init(fromConsuming: &bytes))
        } else if Sequence.recognizesTag(bytes) {
            self = .sequence(try .init(fromConsuming: &bytes))
        } else {
            throw TezosError.invalidValue("Unknown Micheline encoding tag.")
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .literal(let content):
            return try content.encodeToBytes()
        case .prim(let content):
            return try content.encodeToBytes()
        case .sequence(let content):
            return try content.encodeToBytes()
        }
    }
}

// MARK: Micheline.Literal

extension Micheline.Literal: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let tag = Tag(from: bytes)
        switch tag {
        case .int:
            self = .integer(try Self.decodeLiteralInteger(fromConsuming: &bytes))
        case .string:
            self = .string(try Self.decodeLiteralString(fromConsuming: &bytes))
        case .bytes:
            self = .bytes(try Self.decodeLiteralBytes(fromConsuming: &bytes))
        default:
            throw TezosError.invalidValue("Invalid Micheline literal encoding tag.")
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .integer(let content):
            return Tag.int + content.encodeToBytes()
        case .string(let content):
            return Tag.string + (try encodeString(content.value))
        case .bytes(let content):
            return Tag.bytes + (try encodeBytes([UInt8](from: content)))
        }
    }
    
    private static func decodeLiteralInteger(fromConsuming bytes: inout [UInt8]) throws -> Integer {
        guard Tag(fromConsuming: &bytes) == .int else {
            throw TezosError.invalidValue("Invalid Micheline integer encoding tag.")
        }
        
        return try Integer(fromConsuming: &bytes)
    }
    
    private static func decodeLiteralString(fromConsuming bytes: inout [UInt8]) throws -> String {
        guard Tag(fromConsuming: &bytes) == .string else {
            throw TezosError.invalidValue("Invalid Micheline string encoding tag.")
        }
        
        return try String(try decodeString(fromConsuming: &bytes))
    }
    
    private static func decodeLiteralBytes(fromConsuming bytes: inout [UInt8]) throws -> Bytes {
        guard Tag(fromConsuming: &bytes) == .bytes else {
            throw TezosError.invalidValue("Invalid Micheline bytes encoding tag.")
        }
        
        return Bytes(try decodeBytes(fromConsuming: &bytes))
    }
}

extension Micheline.Literal: Taggable {
    fileprivate static var tags: [Tag] = [.int, .string, .bytes]
}

// MARK: Micheline.PrimitiveApplication

extension Micheline.PrimitiveApplication: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Unknown Micheline primitive application encoding tag.")
        }
        
        switch tag {
        case .primNoArgsNoAnnots:
            self = try decodePrimNoArgsNoAnnots(fromConsmuing: &bytes)
        case .primNoArgsSomeAnnots:
            self = try decodePrimNoArgsSomeAnnots(fromConsmuing: &bytes)
        case .prim1ArgNoAnnots:
            self = try decodePrim1ArgNoAnnots(fromConsmuing: &bytes)
        case .prim1ArgSomeAnnots:
            self = try decodePrim1ArgSomeAnnots(fromConsmuing: &bytes)
        case .prim2ArgsNoAnnots:
            self = try decodePrim2ArgsNoAnnots(fromConsmuing: &bytes)
        case .prim2ArgsSomeAnnots:
            self = try decodePrim2ArgsSomeAnnots(fromConsmuing: &bytes)
        case .primGeneric:
            self = try decodePrimGeneric(fromConsmuing: &bytes)
        default:
            throw TezosError.invalidValue("Invalid Micheline primitive application encoding tag.")
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        if args.isEmpty {
            return annots.isEmpty ? (try encodePrimNoArgsNoAnnots(self)) : (try encodePrimNoArgsSomeAnnots(self))
        } else if args.count == 1 {
            return annots.isEmpty ? (try encodePrim1ArgNoAnnots(self)) : (try encodePrim1ArgSomeAnnots(self))
        } else if args.count == 2 {
            return annots.isEmpty ? (try encodePrim2ArgsNoAnnots(self)) : (try encodePrim2ArgsSomeAnnots(self))
        } else {
            return try encodePrimGeneric(self)
        }
    }
    
    
}

extension Micheline.PrimitiveApplication: Taggable {
    fileprivate static var tags: [Tag] = [
        .primNoArgsNoAnnots,
        .primNoArgsSomeAnnots,
        .prim1ArgNoAnnots,
        .prim1ArgSomeAnnots,
        .prim2ArgsNoAnnots,
        .prim2ArgsSomeAnnots,
        .primGeneric,
    ]
}

// MARK: Micheline.Sequence

extension Micheline.Sequence: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes), tag == .sequence else {
            throw TezosError.invalidValue("Invalid Micheline sequence encoding tag.")
        }
        
        bytes.removeSubrange(0..<tag.value.count)
        self = try decodeSequence(fromConsuming: &bytes)
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        let bytes = try encodeSequence(self)
        return Tag.sequence + bytes
    }
}

extension Micheline.Sequence: Taggable {
    fileprivate static var tags: [Tag] = [.sequence]
}

// MARK: Utility Functions: Decode

private func decodeString(fromConsuming bytes: inout [UInt8]) throws -> String {
    let length = try Int32(fromConsuming: &bytes)
    return try String(fromConsuming: &bytes, count: Int(length))
}

private func decodeBytes(fromConsuming bytes: inout [UInt8]) throws -> [UInt8] {
    let length = try Int32(fromConsuming: &bytes)
    return bytes.consumeSubrange(0..<Int(length))
}

private func decodePrimNoArgsNoAnnots(fromConsmuing bytes: inout [UInt8]) throws -> Micheline.PrimitiveApplication {
    guard Tag(fromConsuming: &bytes) == .primNoArgsNoAnnots else {
        throw TezosError.invalidValue("Invalid Micheline primitive application without args and annotations encoding tag.")
    }
    
    let prim = try decodePrim(fromConsmuing: &bytes)
    
    return try .init(prim: prim)
}

private func decodePrimNoArgsSomeAnnots(fromConsmuing bytes: inout [UInt8]) throws -> Micheline.PrimitiveApplication {
    guard Tag(fromConsuming: &bytes) == .primNoArgsSomeAnnots else {
        throw TezosError.invalidValue("Invalid Micheline primitive application without args and with some annotations encoding tag.")
    }
    
    let prim = try decodePrim(fromConsmuing: &bytes)
    let annots = try decodeAnnots(fromConsmuing: &bytes)
    
    return try .init(prim: prim, annots: annots)
}

private func decodePrim1ArgNoAnnots(fromConsmuing bytes: inout [UInt8]) throws -> Micheline.PrimitiveApplication {
    guard Tag(fromConsuming: &bytes) == .prim1ArgNoAnnots else {
        throw TezosError.invalidValue("Invalid Micheline primitive application with 1 arg and no annotations encoding tag.")
    }
    
    let prim = try decodePrim(fromConsmuing: &bytes)
    let arg = try Micheline(fromConsuming: &bytes)
    
    return try .init(prim: prim, args: [arg])
}

private func decodePrim1ArgSomeAnnots(fromConsmuing bytes: inout [UInt8]) throws -> Micheline.PrimitiveApplication {
    guard Tag(fromConsuming: &bytes) == .prim1ArgSomeAnnots else {
        throw TezosError.invalidValue("Invalid Micheline primitive application with 1 arg and some annotations encoding tag.")
    }
    
    let prim = try decodePrim(fromConsmuing: &bytes)
    let arg = try Micheline(fromConsuming: &bytes)
    let annots = try decodeAnnots(fromConsmuing: &bytes)
    
    return try .init(prim: prim, args: [arg], annots: annots)
}

private func decodePrim2ArgsNoAnnots(fromConsmuing bytes: inout [UInt8]) throws -> Micheline.PrimitiveApplication {
    guard Tag(fromConsuming: &bytes) == .prim2ArgsNoAnnots else {
        throw TezosError.invalidValue("Invalid Micheline primitive application with 2 args and no annotations encoding tag.")
    }
    
    let prim = try decodePrim(fromConsmuing: &bytes)
    
    let arg1 = try Micheline(fromConsuming: &bytes)
    let arg2 = try Micheline(fromConsuming: &bytes)
    
    return try .init(prim: prim, args: [arg1, arg2])
}

private func decodePrim2ArgsSomeAnnots(fromConsmuing bytes: inout [UInt8]) throws -> Micheline.PrimitiveApplication {
    guard Tag(fromConsuming: &bytes) == .prim2ArgsSomeAnnots else {
        throw TezosError.invalidValue("Invalid Micheline primitive application with 2 args and some annotations encoding tag.")
    }
    
    let prim = try decodePrim(fromConsmuing: &bytes)
    
    let arg1 = try Micheline(fromConsuming: &bytes)
    let arg2 = try Micheline(fromConsuming: &bytes)
    
    let annots = try decodeAnnots(fromConsmuing: &bytes)
    
    return try .init(prim: prim, args: [arg1, arg2], annots: annots)
}

private func decodePrimGeneric(fromConsmuing bytes: inout [UInt8]) throws -> Micheline.PrimitiveApplication {
    guard Tag(fromConsuming: &bytes) == .primGeneric else {
        throw TezosError.invalidValue("Invalid Micheline generic primitive application encoding tag.")
    }
    
    let prim = try decodePrim(fromConsmuing: &bytes)
    let args = try decodeSequence(fromConsuming: &bytes)
    let annots = try decodeAnnots(fromConsmuing: &bytes)
    
    return try .init(prim: prim, args: args, annots: annots)
}

private func decodePrim(fromConsmuing bytes: inout [UInt8]) throws -> String {
    guard let byte = bytes.consume(at: 0) else {
        throw TezosError.invalidValue("Invalid Micheline primitive application encoded value.")
    }
    
    guard let prim = Michelson.recognizePrim([byte]).first else {
        throw TezosError.invalidValue("Unknown Micheline prim tag (\(byte)).")
    }
    
    return prim.name
}

private func decodeAnnots(fromConsmuing bytes: inout [UInt8]) throws -> [String] {
    let string = try decodeString(fromConsuming: &bytes)
    return string.split(separator: " ").compactMap { $0.isEmpty ? nil : String($0) }
}

private func decodeSequence(fromConsuming bytes: inout [UInt8]) throws -> [Micheline] {
    let length = try Int32(fromConsuming: &bytes)
    var bytes = bytes.consumeSubrange(0..<Int(length))
    
    return try [Micheline](fromConsuming: &bytes) { try Micheline(fromConsuming: &$0) }
}


// MARK: Utility Functions: Encode

private func encodeString(_ string: Swift.String) throws -> [UInt8] {
    let bytes = try string.encodeToBytes()
    return try encodeBytes(bytes)
}

private func encodeBytes(_ bytes: [UInt8]) throws -> [UInt8] {
    let length = try Int32(bytes.count).encodeToBytes()
    return length + bytes
}

private func encodePrimNoArgsNoAnnots(_ value: Micheline.PrimitiveApplication) throws -> [UInt8] {
    let bytes = try encodePrim(value.prim)
    return Tag.primNoArgsNoAnnots + bytes
}

private func encodePrimNoArgsSomeAnnots(_ value: Micheline.PrimitiveApplication) throws -> [UInt8] {
    let bytes = (try encodePrim(value.prim)) + (try encodeAnnots(value.annots))
    return Tag.primNoArgsNoAnnots + bytes
}

private func encodePrim1ArgNoAnnots(_ value: Micheline.PrimitiveApplication) throws -> [UInt8] {
    let bytes = (try encodePrim(value.prim)) + (try value.args[0].encodeToBytes())
    return Tag.prim1ArgNoAnnots + bytes
}

private func encodePrim1ArgSomeAnnots(_ value: Micheline.PrimitiveApplication) throws -> [UInt8] {
    let bytes = (try encodePrim(value.prim)) +
        (try value.args[0].encodeToBytes()) +
        (try encodeAnnots(value.annots))
    
    return Tag.prim1ArgSomeAnnots + bytes
}

private func encodePrim2ArgsNoAnnots(_ value: Micheline.PrimitiveApplication) throws -> [UInt8] {
    let bytes = (try encodePrim(value.prim)) +
        (try value.args[0].encodeToBytes()) +
        (try value.args[1].encodeToBytes())
    
    return Tag.prim2ArgsNoAnnots + bytes
}

private func encodePrim2ArgsSomeAnnots(_ value: Micheline.PrimitiveApplication) throws -> [UInt8] {
    let bytes = (try encodePrim(value.prim)) +
        (try value.args[0].encodeToBytes()) +
        (try value.args[1].encodeToBytes()) +
        (try encodeAnnots(value.annots))
    
    return Tag.prim2ArgsSomeAnnots + bytes
}

private func encodePrimGeneric(_ value: Micheline.PrimitiveApplication) throws -> [UInt8] {
    let bytes = (try encodePrim(value.prim)) + (try encodeSequence(value.args)) + (try encodeAnnots(value.annots))
    
    return Tag.primGeneric + bytes
}

private func encodePrim(_ prim: String) throws -> [UInt8] {
    guard let prim = Michelson.recognizePrim(prim).first else {
        throw TezosError.invalidValue("Unknown Micheline prim (\(prim)).")
    }
    
    return prim.tag
}

private func encodeAnnots(_ annots: [String]) throws -> [UInt8] {
    let joined = annots.joined(separator: " ")
    return try encodeString(joined)
}

private func encodeSequence(_ nodes: [Micheline]) throws -> [UInt8] {
    let bytes = try nodes.encodeToBytes(encodingWith: { try $0.encodeToBytes() })
    return try encodeBytes(bytes)
}

// MARK: Tag

private enum Tag: BytesTag {
    case int
    case string
    case sequence
    case primNoArgsNoAnnots
    case primNoArgsSomeAnnots
    case prim1ArgNoAnnots
    case prim1ArgSomeAnnots
    case prim2ArgsNoAnnots
    case prim2ArgsSomeAnnots
    case primGeneric
    case bytes
    
    var value: [UInt8] {
        switch self {
        case .int:
            return [0]
        case .string:
            return [1]
        case .sequence:
            return [2]
        case .primNoArgsNoAnnots:
            return [3]
        case .primNoArgsSomeAnnots:
            return [4]
        case .prim1ArgNoAnnots:
            return [5]
        case .prim1ArgSomeAnnots:
            return [6]
        case .prim2ArgsNoAnnots:
            return [7]
        case .prim2ArgsSomeAnnots:
            return [8]
        case .primGeneric:
            return [9]
        case .bytes:
            return [10]
        }
    }
    
    init?(from bytes: [UInt8]) {
        guard let found = Self.recognize(from: bytes) else {
            return nil
        }
        
        self = found
    }
    
    init?(fromConsuming bytes: inout [UInt8]) {
        guard let found = Self.recognize(fromConsuming: &bytes) else {
            return nil
        }
        
        self = found
    }
}

private protocol Taggable {
    static var tags: [Tag] { get }
}

private extension Taggable {
    static func recognizesTag(_ bytes: [UInt8]) -> Bool {
        guard let tag = Tag(from: bytes) else {
            return false
        }
        
        return tags.contains(tag)
    }
}
