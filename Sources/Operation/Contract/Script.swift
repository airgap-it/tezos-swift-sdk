//
//  Script.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation
import TezosMichelson

extension TezosOperation {
    
    public struct Script: Hashable {
        public let code: Micheline
        public let storage: Micheline
        
        public init(code: Micheline, storage: Micheline) {
            self.code = code
            self.storage = storage
        }
    }
}
