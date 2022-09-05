//
//  TezosCore.swift
//  
//
//  Created by Julia Samol on 03.08.22.
//

struct TezosCore: TezosModule {
    static var builder: Builder = .init()
    
    struct Builder: TezosModuleBuilder {
        func build() throws -> TezosCore {
            .init()
        }
    }
}
