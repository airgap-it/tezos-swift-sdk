//
//  HexString.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

public struct HexString: Hashable, Codable {
    static let prefix: String = "0x"
    
    let value: String
        
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
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let value = try String(from: decoder)
        try self.init(from: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
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
