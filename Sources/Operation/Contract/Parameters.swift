//
//  Parameters.swift
//  
//
//  Created by Julia Samol on 05.07.22.
//

import Foundation
import TezosMichelson

extension TezosOperation {
    
    public struct Parameters: Hashable {
        public let entrypoint: Entrypoint
        public let value: Micheline
        
        public init(entrypoint: Entrypoint, value: Micheline) {
            self.entrypoint = entrypoint
            self.value = value
        }
    }
}
