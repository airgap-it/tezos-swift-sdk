//
//  StringWrapper.swift
//  
//
//  Created by Julia Samol on 09.06.22.
//

public protocol StringWrapper {
    static var regex: String { get }
    
    var value: String { get }
    
    init<S: StringProtocol>(_ value: S) throws
}

// MARK: Defaults

public extension StringWrapper {
    static func isValid<S: StringProtocol>(value: S) -> Bool {
        value.range(of: Self.regex, options: .regularExpression) != nil
    }
}
