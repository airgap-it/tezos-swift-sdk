//
//  MichelineSequence.swift
//  
//
//  Created by Julia Samol on 13.06.22.
//

extension Micheline {
    public typealias Sequence = [Micheline]
}

public protocol MichelineSequenceProtocol: Micheline.`Protocol` {
    
}

extension Micheline.Sequence {
    public typealias `Protocol` = MichelineSequenceProtocol
}

extension Micheline.Sequence: MichelineProtocol {
    public func asMicheline() -> Micheline {
        .sequence(self)
    }
}

extension Micheline.Sequence: MichelineSequenceProtocol {

}
