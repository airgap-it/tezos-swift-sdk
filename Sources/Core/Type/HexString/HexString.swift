//
//  HexString.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

import Foundation

public struct HexString: Hashable, Codable {
    fileprivate static let prefix: String = "0x"
    
    fileprivate let value: String
        
    private init(_ value: String) {
        self.value = value.removingPrefix(HexString.prefix)
    }
    
    public init(from string: String) throws {
        guard string.isHex() else {
            throw TezosError.invalidValue("Invalid hex string (\(string)).")
        }
        
        self.init(string)
    }
    
    public init(from bytes: [UInt8]) {
        self.init(bytes.map { b in String(format: "%02x", b) }.joined())
    }
    
    public func count(withPrefix prefixed: Bool = false) -> Int {
        String(self, withPrefix: prefixed).count
    }
}

// MARK: String <- HexString

public extension String {
    init(_ source: HexString, withPrefix prefixed: Bool = false) {
        self = prefixed ? HexString.prefix + source.value : source.value
    }
}

// MARK: Array <- HexString

public extension Array where Element == UInt8 {
    init(from source: HexString) {
        var bytes = [UInt8]()
        bytes.reserveCapacity(source.value.count / 2)
        
        for (position, index) in source.value.indices.enumerated() {
            guard position % 2 == 0 else { continue }
            
            let byteRange = index..<source.value.index(index, offsetBy: 2)
            let byteSlice = source.value[byteRange]
            let byte = UInt8(byteSlice, radix: 16)! // `value` has been already tested for a valid hex string
            bytes.append(byte)
        }
        
        self = bytes
    }
}

// MARK: Utility Extensions

public extension HexString {
    static func regex(withPrefix prefixMode: RegexPrefixMode = .optional) -> String {
        let prefixRegex: String = {
            switch prefixMode {
            case .required:
                return HexString.prefix
            case .optional:
                return "(\(HexString.prefix))?"
            case .none:
                return ""
            }
        }()
        
        return "^\(prefixRegex)([0-9a-fA-F]{2})*$"
    }
    
    enum RegexPrefixMode {
        case required
        case optional
        case none
    }
}

private extension String {
    func isHex() -> Bool {
        range(of: HexString.regex(), options: .regularExpression) != nil
    }
}
