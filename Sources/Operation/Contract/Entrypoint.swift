//
//  Entrypoint.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation

extension Operation {
    
    public enum Entrypoint: Hashable {
        case `default`
        case root
        case `do`
        case setDelegate
        case removeDelegate
        case named(String)
        
        public init(from string: String) {
            let rawValue = RawValues.allCases.first(where: { $0.rawValue == string })
            self = rawValue?.toEntrypoint() ?? .named(string)
        }
        
        public var value: String {
            switch self {
            case .`default`:
                return RawValues.`default`.rawValue
            case .root:
                return RawValues.root.rawValue
            case .`do`:
                return RawValues.`do`.rawValue
            case .setDelegate:
                return RawValues.setDelegate.rawValue
            case .removeDelegate:
                return RawValues.removeDelegate.rawValue
            case .named(let string):
                return string
            }
        }
        
        public var tag: [UInt8] {
            switch self {
            case .`default`:
                return [0]
            case .root:
                return [1]
            case .`do`:
                return [2]
            case .setDelegate:
                return [3]
            case .removeDelegate:
                return [4]
            case .named(_):
                return [255]
            }
        }
        
        private enum RawValues: String, CaseIterable {
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
    }
}
