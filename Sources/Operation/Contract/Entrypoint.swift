//
//  Entrypoint.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation

public enum Entrypoint: Hashable, Codable {
    case `default`
    case root
    case `do`
    case setDelegate
    case removeDelegate
    case named(String)
    
    public init(from string: String) {
        let staticValue = StaticValue.allCases.first(where: { $0.rawValue == string })
        self = staticValue?.toEntrypoint() ?? .named(string)
    }
    
    public var value: String {
        switch self {
        case .`default`:
            return StaticValue.`default`.rawValue
        case .root:
            return StaticValue.root.rawValue
        case .`do`:
            return StaticValue.`do`.rawValue
        case .setDelegate:
            return StaticValue.setDelegate.rawValue
        case .removeDelegate:
            return StaticValue.removeDelegate.rawValue
        case .named(let string):
            return string
        }
    }
    
    public var tag: [UInt8] {
        switch self {
        case .`default`:
            return Tag.`default`.rawValue
        case .root:
            return Tag.root.rawValue
        case .`do`:
            return Tag.`do`.rawValue
        case .setDelegate:
            return Tag.setDelegate.rawValue
        case .removeDelegate:
            return Tag.removeDelegate.rawValue
        case .named(_):
            return Tag.named.rawValue
        }
    }
    
    enum StaticValue: String, CaseIterable {
        case `default` = "default"
        case root = "root"
        case `do` = "do"
        case setDelegate = "set_delegate"
        case removeDelegate = "remove_delegate"
        
        func toEntrypoint() -> Entrypoint {
            switch self {
            case .`default`:
                return .`default`
            case .root:
                return .root
            case .`do`:
                return .`do`
            case .setDelegate:
                return .setDelegate
            case .removeDelegate:
                return .removeDelegate
            }
        }
    }
    
    enum Tag: RawRepresentable, CaseIterable {
        typealias RawValue = [UInt8]
        
        private static let defaultTag: [UInt8] = [0]
        private static let rootTag: [UInt8] = [1]
        private static let doTag: [UInt8] = [2]
        private static let setDelegateTag: [UInt8] = [3]
        private static let removeDelegateTag: [UInt8] = [4]
        private static let namedTag: [UInt8] = [255]
        
        case `default`
        case root
        case `do`
        case setDelegate
        case removeDelegate
        case named
        
        init?(rawValue: RawValue) {
            switch rawValue {
            case Self.defaultTag:
                self = .`default`
            case Self.rootTag:
                self = .root
            case Self.doTag:
                self = .`do`
            case Self.setDelegateTag:
                self = .setDelegate
            case Self.removeDelegateTag:
                self = .removeDelegate
            case Self.namedTag:
                self = .named
            default:
                return nil
            }
        }
        
        var rawValue: RawValue {
            switch self {
            case .`default`:
                return Self.defaultTag
            case .root:
                return Self.rootTag
            case .`do`:
                return Self.doTag
            case .setDelegate:
                return Self.setDelegateTag
            case .removeDelegate:
                return Self.removeDelegateTag
            case .named:
                return Self.namedTag
            }
        }
        
        func toStaticValue() -> StaticValue? {
            switch self {
            case .`default`:
                return .`default`
            case .root:
                return .root
            case .`do`:
                return .`do`
            case .setDelegate:
                return .setDelegate
            case .removeDelegate:
                return .removeDelegate
            case .named:
                return nil
            }
        }
    }
}
