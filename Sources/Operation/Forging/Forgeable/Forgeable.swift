//
//  Forgeable.swift
//  
//
//  Created by Julia Samol on 02.08.22.
//

public protocol ToForged {
    func forge() throws -> [UInt8]
}

public protocol FromForged {
    init(fromForged bytes: [UInt8]) throws
}

protocol FromForgedConsuming: FromForged {
    init(fromForgedConsuming bytes: inout [UInt8]) throws
}

extension FromForgedConsuming {
    public init(fromForged bytes: [UInt8]) throws {
        var bytes = bytes
        try self.init(fromForgedConsuming: &bytes)
    }
}

public typealias Forgeable = FromForged & ToForged
typealias ForgeableConsuming = FromForgedConsuming & ToForged
