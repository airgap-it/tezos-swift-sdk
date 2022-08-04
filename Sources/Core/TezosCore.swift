//
//  TezosCore.swift
//  
//
//  Created by Julia Samol on 03.08.22.
//

public struct TezosCore: TezosModule {
    static public var builder: Builder = .init()
    
    public struct Builder: TezosModuleBuilder {
        public func build() throws -> TezosCore {
            .init()
        }
    }
}
