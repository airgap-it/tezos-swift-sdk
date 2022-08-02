//
//  AddressBytes.swift
//  
//
//  Created by Julia Samol on 15.06.22.
//

// MARK: Address

extension Address: BytesTaggedCodable {
    
    func encodeRawToBytes() throws -> [UInt8] {
        switch self {
        case .implicit(let implicit):
            return try implicit.encodeToBytes()
        case .originated(let originated):
            return try originated.encodeToBytes()
        }
    }
    
    enum Tag: BytesCodableTag {
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
        
        init(from value: Address) {
            switch value {
            case .implicit(_):
                self = .implicit
            case .originated(_):
                self = .originated
            }
        }
        
        func create(fromConsuming bytes: inout [UInt8]) throws -> Address {
            switch self {
            case .implicit:
                return .implicit(try .init(fromConsuming: &bytes))
            case .originated:
                return .originated(try .init(fromConsuming: &bytes))
            }
        }
    }
}

// MARK: ImplicitAddress

extension Address.Implicit: BytesTaggedCodable {
    
    func encodeRawToBytes() throws -> [UInt8] {
        switch self {
        case .tz1(let ed25519PublicKeyHash):
            return try ed25519PublicKeyHash.encodeToBytes()
        case .tz2(let secp256K1PublicKeyHash):
            return try secp256K1PublicKeyHash.encodeToBytes()
        case .tz3(let p256PublicKeyHash):
            return try p256PublicKeyHash.encodeToBytes()
        }
    }
    
    enum Tag: BytesCodableTag {
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
        
        init(from value: Address.Implicit) {
            switch value {
            case .tz1(_):
                self = .tz1
            case .tz2(_):
                self = .tz2
            case .tz3(_):
                self = .tz3
            }
        }
        
        func create(fromConsuming bytes: inout [UInt8]) throws -> Address.Implicit {
            switch self {
            case .tz1:
                return .tz1(try .init(fromConsuming: &bytes))
            case .tz2:
                return .tz2(try .init(fromConsuming: &bytes))
            case .tz3:
                return .tz3(try .init(fromConsuming: &bytes))
            }
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
    func isPadded<T: EncodedValue & Address.Originated.`Protocol`>(forKind kind: T.Type) -> Bool {
        guard count >= Address.Originated.targetSize else {
            return false
        }
        
        let upperBound = Swift.min(kind.bytesLength + kind.paddingLength, count)
        return self[kind.bytesLength..<upperBound].allSatisfy { $0 == Address.Originated.paddingValue }
    }
    
    mutating func consumePadding<T: EncodedValue & Address.Originated.`Protocol`>(forKind kind: T.Type) {
        let _ = consumeSubrange(0..<kind.paddingLength)
    }
}

private extension EncodedValue where Self: Address.Originated.`Protocol` {
    static var paddingLength: Int { Address.Originated.targetSize - Self.bytesLength }
}
