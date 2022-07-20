//
//  SignatureUtils.swift
//  
//
//  Created by Julia Samol on 19.07.22.
//

import TezosCore

extension Signature {
    static var placeholder: Signature {
        .edsig(try! .init(base58: "edsigtXomBKi5CTRf5cjATJWSyaRvhfYNHqSUGrn4SdbYRcGwQrUGjzEfQDTuqHhuA8b2d8NarZjz8TRf65WkpQmo423BtomS8Q"))
    }
    
    var isPlaceholder: Bool {
        base58 == Self.placeholder.base58
    }
}
