//
//  MichelsonUtils.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

extension Michelson {
    static func recognizePrim(_ prim: String) -> [Prim] {
        Prim.allRawValues.filter { $0.name == prim }.compactMap { .init(rawValue: $0) }
    }
    
    static func recognizePrim(_ tag: [UInt8]) -> [Prim] {
        Prim.allRawValues.filter { $0.tag == tag }.compactMap { .init(rawValue: $0) }
    }
}
