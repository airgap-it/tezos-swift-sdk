//
//  MichelsonUtils.swift
//  
//
//  Created by Julia Samol on 14.06.22.
//

import Foundation

extension Michelson {
    static func recognizePrim(_ prim: String) -> [Prim.Type] {
        allPrims.filter { $0.name == prim }
    }
    
    static func recognizePrim(_ tag: [UInt8]) -> [Prim.Type] {
        allPrims.filter { $0.tag == tag }
    }
}
