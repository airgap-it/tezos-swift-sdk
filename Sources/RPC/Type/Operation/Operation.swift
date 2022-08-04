//
//  Operation.swift
//  
//
//  Created by Julia Samol on 11.07.22.
//

import TezosCore

// MARK: RPCOperation

public struct RPCOperation: Hashable, Codable {
    public let `protocol`: ProtocolHash
    public let chainID: ChainID
    public let hash: OperationHash
    public let branch: BlockHash
    public let contents: [Content]
    public let signature: Signature?
    public let metadata: RPCOperationMetadata?
    
    public init(
        `protocol`: ProtocolHash,
        chainID: ChainID,
        hash: OperationHash,
        branch: BlockHash,
        contents: [Content] = [],
        signature: Signature? = nil,
        metadata: RPCOperationMetadata? = nil
    ) {
        self.protocol = `protocol`
        self.chainID = chainID
        self.hash = hash
        self.branch = branch
        self.contents = contents
        self.signature = signature
        self.metadata = metadata
    }
    
    enum CodingKeys: String, CodingKey {
        case `protocol`
        case chainID = "chain_id"
        case hash
        case branch
        case contents
        case signature
        case metadata
    }
}

// MARK: ApplicableOperation

public struct RPCApplicableOperation: Hashable, Codable {
    public let `protocol`: ProtocolHash
    public let branch: BlockHash
    public let contents: [RPCOperation.Content]
    public let signature: Signature
    
    public init(`protocol`: ProtocolHash, branch: BlockHash, contents: [RPCOperation.Content] = [], signature: Signature) {
        self.protocol = `protocol`
        self.branch = branch
        self.contents = contents
        self.signature = signature
    }
}

// MARK: AppliedOperation

public struct RPCAppliedOperation: Hashable, Codable {
    public let contents: [RPCOperation.Content]
    public let signature: Signature?
    
    public init(contents: [RPCOperation.Content] = [], signature: Signature? = nil) {
        self.contents = contents
        self.signature = signature
    }
}

// MARK: InjectableOperation

public struct RPCInjectableOperation: Hashable, Codable {
    public let branch: BlockHash
    public let data: String
    
    public init(branch: BlockHash, data: String) {
        self.branch = branch
        self.data = data
    }
}

// MARK: RunnableOperation

public struct RPCRunnableOperation: Hashable, Codable {
    public let branch: BlockHash
    public let contents: [RPCOperation.Content]
    public let signature: Signature
    public let chainID: ChainID
    
    public init(branch: BlockHash, contents: [RPCOperation.Content] = [], signature: Signature, chainID: ChainID) {
        self.branch = branch
        self.contents = contents
        self.signature = signature
        self.chainID = chainID
    }
    
    // MARK: Codable
    
    public init(from decoder: Decoder) throws {
        let delegate = try CodableDelegate(from: decoder)
        self.init(
            branch: delegate.operation.branch,
            contents: delegate.operation.contents,
            signature: delegate.operation.signature,
            chainID: delegate.chainID
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        let delegate = CodableDelegate(operation: .init(branch: branch, contents: contents, signature: signature), chainID: chainID)
        try delegate.encode(to: encoder)
    }
}

extension RPCRunnableOperation {
    
    private struct CodableDelegate: Hashable, Codable {
        let operation: Content
        let chainID: ChainID
        
        struct Content: Hashable, Codable {
            let branch: BlockHash
            let contents: [RPCOperation.Content]
            let signature: Signature
        }
        
        enum CodingKeys: String, CodingKey {
            case operation
            case chainID = "chain_id"
        }
    }
}
