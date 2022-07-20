//
//  ChainsRPCConfiguration.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation
import TezosCore

public typealias ChainsChainPatchConfiguration = HeadersOnlyConfiguration

public struct ChainsChainBlocksGetConfiguration: BaseConfiguration {
    public let length: UInt32?
    public let head: BlockHash?
    public let minDate: String?
    public let headers: [HTTPHeader]
    
    public init(length: UInt32? = nil, head: BlockHash? = nil, minDate: String? = nil, headers: [HTTPHeader] = []) {
        self.length = length
        self.head = head
        self.minDate = minDate
        self.headers = headers
    }
}

public typealias ChainsChainChainIDGetConfiguration = HeadersOnlyConfiguration

public typealias ChainsChainInvalidBlocksGetConfiguration = HeadersOnlyConfiguration
public typealias ChainsChainInvalidBlocksBlockGetConfiguration = HeadersOnlyConfiguration
public typealias ChainsChainInvalidBlocksBlockDeleteConfiguration = HeadersOnlyConfiguration

public typealias ChainsChainIsBootstrappedGetConfiguration = HeadersOnlyConfiguration

public typealias ChainsChainLevelsCabooseGetConfiguration = HeadersOnlyConfiguration
public typealias ChainsChainLevelsCheckpointGetConfiguration = HeadersOnlyConfiguration
public typealias ChainsChainLevelsSavepointGetConfiguration = HeadersOnlyConfiguration
