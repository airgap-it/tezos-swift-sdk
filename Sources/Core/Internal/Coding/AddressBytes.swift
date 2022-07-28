//
//  AddressBytes.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

// MARK: Address

extension Address: BytesCodable {   
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Bytes `\(bytes)` are not valid Tezos address bytes.")
        }
        
        bytes.removeSubrange(0..<tag.value.count)
        
        switch tag {
        case .implicit:
            self = .implicit(try .init(fromConsuming: &bytes))
        case .originated:
            self = .originated(try .init(fromConsuming: &bytes))
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .implicit(let implicit):
            return Tag.implicit + (try implicit.encodeToBytes())
        case .originated(let originated):
            return Tag.originated + (try originated.encodeToBytes())
        }
    }
    
    private enum Tag: BytesTagIterable {
        case implicit
        case originated
        
        var value: [UInt8] {
            switch self {
            case .implicit:
                return [0]
            case .originated:
                return [1]
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
}

// MARK: ImplicitAddress

extension Address.Implicit: BytesCodable {
    public init(fromConsuming bytes: inout [UInt8]) throws {
        guard let tag = Tag(from: bytes) else {
            throw TezosError.invalidValue("Bytes `\(bytes)` are not valid Tezos implicit address bytes.")
        }
        
        bytes.removeSubrange(0..<tag.value.count)
        
        switch tag {
        case .tz1:
            self = .tz1(try .init(fromConsuming: &bytes))
        case .tz2:
            self = .tz2(try .init(fromConsuming: &bytes))
        case .tz3:
            self = .tz3(try .init(fromConsuming: &bytes))
        }
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .tz1(let ed25519PublicKeyHash):
            return Tag.tz1 + (try ed25519PublicKeyHash.encodeToBytes())
        case .tz2(let secp256K1PublicKeyHash):
            return Tag.tz2 + (try secp256K1PublicKeyHash.encodeToBytes())
        case .tz3(let p256PublicKeyHash):
            return Tag.tz3 + (try p256PublicKeyHash.encodeToBytes())
        }
    }
    
    private enum Tag: BytesTagIterable {
        case tz1
        case tz2
        case tz3
        
        var value: [UInt8] {
            switch self {
            case .tz1:
                return [0]
            case .tz2:
                return [1]
            case .tz3:
                return [2]
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
}

// MARK: OriginatedAddress

extension Address.Originated: BytesCodable {
    fileprivate static let targetSize = 21
    fileprivate static let paddingValue: UInt8 = 0
    
    public init(fromConsuming bytes: inout [UInt8]) throws {
        let kind = ContractHash.self
        guard bytes.isPadded(forKind: kind) else {
            throw TezosError.invalidValue("Bytes `\(bytes)` are not valid Tezos originated address bytes.")
        }
        
        self = .contract(try .init(fromConsuming: &bytes))
        bytes.consumePadding(forKind: kind)
    }
    
    public func encodeToBytes() throws -> [UInt8] {
        switch self {
        case .contract(let contractHash):
            return try contractHash.encodeToBytes().padEnd(targetSize: Self.targetSize)
        }
    }
}

private extension Array where Element == UInt8 {
    func isPadded<T: EncodedValue>(forKind kind: T.Type) -> Bool {
        guard count >= Address.Originated.targetSize else {
            return false
        }
        
        let upperBound = Swift.min(kind.bytesLength + kind.paddingLength, count)
        return self[kind.bytesLength..<upperBound].allSatisfy { $0 == Address.Originated.paddingValue }
    }
    
    mutating func consumePadding<T: EncodedValue>(forKind kind: T.Type) {
        let _ = consumeSubrange(0..<kind.paddingLength)
    }
}

private extension EncodedValue {
    static var paddingLength: Int { Address.Originated.targetSize - Self.bytesLength }
}
