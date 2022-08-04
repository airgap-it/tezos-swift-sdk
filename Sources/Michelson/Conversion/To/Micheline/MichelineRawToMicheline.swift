//
//  MichelineRawToMicheline.swift
//  
//
//  Created by Julia Samol on 16.06.22.
//

// MARK: Micheline.Literal

extension Micheline.Literal: ConvertibleToMicheline {
    public func toMicheline() -> Micheline {
        return .literal(self)
    }
}

extension Micheline.Literal.Integer: ConvertibleToMicheline {
    public func toMicheline() -> Micheline {
        return Micheline.Literal.integer(self).toMicheline()
    }
}

extension Micheline.Literal.String: ConvertibleToMicheline {
    public func toMicheline() -> Micheline {
        return Micheline.Literal.string(self).toMicheline()
    }
}

extension Micheline.Literal.Bytes: ConvertibleToMicheline {
    public func toMicheline() -> Micheline {
        return Micheline.Literal.bytes(self).toMicheline()
    }
}

// MARK: Micheline.PrimitiveApplication

extension Micheline.PrimitiveApplication: ConvertibleToMicheline {
    public func toMicheline() -> Micheline {
        return .prim(self)
    }
}

// MARK: Micheline.Sequence

extension Micheline.Sequence: ConvertibleToMicheline {
    public func toMicheline() -> Micheline {
        return .sequence(self)
    }
}
