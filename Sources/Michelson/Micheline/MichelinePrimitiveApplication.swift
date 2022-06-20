//
//  MichelinePrimitiveApplication.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

import Foundation
import TezosCore

extension Micheline {
    
    public struct PrimitiveApplication: Hashable, Codable {
        public let prim: String
        public let args: [Micheline]
        public let annots: [String]
        
        public init(prim: String, args: [Micheline] = [], annots: [String] = []) throws {
            guard Self.isPrimValid(prim) else {
                throw TezosError.invalidValue("Invalid Micheline prim value (\(prim)).")
            }
            
            guard Self.areAnnotsValid(annots) else {
                throw TezosError.invalidValue("Invalid Micheline annot values (\(annots)).")
            }
            
            self.prim = prim
            self.args = args
            self.annots = annots
        }
        
        // MARK: Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let prim = try container.decode(String.self, forKey: .prim)
            let args = try container.decodeIfPresent([Micheline].self, forKey: .args)
            let annots = try container.decodeIfPresent([String].self, forKey: .annots)
            
            self.prim = prim
            self.args = args ?? []
            self.annots = annots ?? []
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(prim, forKey: .prim)
            
            if !args.isEmpty {
                try container.encode(args, forKey: .args)
            }
            
            if !annots.isEmpty {
                try container.encode(annots, forKey: .annots)
            }
        }
        
        public enum CodingKeys: String, CodingKey {
            case prim
            case args
            case annots
        }
    }
}

// MARK: Convinience Constructors

public extension Micheline.PrimitiveApplication {
    init(prim: String, args: [ConvertibleToMicheline], annots: [String] = []) throws {
        try self.init(prim: prim, args: args.map({ $0.toMicheline() }), annots: annots)
    }
    
    init<T : Michelson.Prim>(prim: T.Type, args: [Micheline] = [], annots: [String]) throws {
        try self.init(prim: prim.name, args: args, annots: annots)
    }
    
    init<T : Michelson.Prim>(prim: T.Type, args: [Micheline] = []) {
        self.prim = prim.name
        self.args = args
        self.annots = []
    }
    
    init<T : Michelson.Prim>(prim: T.Type, args: [ConvertibleToMicheline]) {
        self.init(prim: prim, args: args.map({ $0.toMicheline() }))
    }
}

// MARK: Utility Extensions

private extension Micheline.PrimitiveApplication {
    private static let primRegex: String = #"^[a-zA-Z_0-9]+$"#
    private static let annotRegex: String = #"^[@:$&%!?][_0-9a-zA-Z\\.%@]*$"#
    
    static func isPrimValid(_ prim: String) -> Bool {
        prim.range(of: Self.primRegex, options: .regularExpression) != nil
    }
    
    static func areAnnotsValid(_ annots: [String]) -> Bool {
        annots.allSatisfy { Self.isAnnotValid($0) }
    }
    
    static func isAnnotValid(_ annot: String) -> Bool {
        annot.range(of: Self.annotRegex, options: .regularExpression) != nil
    }
}
