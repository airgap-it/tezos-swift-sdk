//
//  Watermark.swift
//  
//
//  Created by Julia Samol on 07.07.22.
//

public enum Watermark: BytesTag {    
    case blockHeader(_ chainID: [UInt8])
    case endorsement(_ chainID: [UInt8])
    case genericOperation
    case custom(_ bytes: [UInt8])
    
    public var value: [UInt8] {
        switch self {
        case .blockHeader(let chainID):
            return [1] + chainID
        case .endorsement(let chainID):
            return [2] + chainID
        case .genericOperation:
            return [3]
        case .custom(let bytes):
            return bytes
        }
    }
}
