//
//  BlockRPCConfiguration.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

public typealias BlockGetConfiguration = HeadersOnlyConfiguration

public struct BlockContextBigMapsBigMapGetConfiguration: BaseConfiguration {
    public let offset: UInt32?
    public let length: UInt32?
    public let headers: [HTTPHeader]
    
    public init(offset: UInt32? = nil, length: UInt32? = nil, headers: [HTTPHeader] = []) {
        self.offset = offset
        self.length = length
        self.headers = headers
    }
}
public typealias BlockContextBigMapsBigMapValueGetConfiguration = HeadersOnlyConfiguration

public typealias BlockContextConstantsGetConfiguration = HeadersOnlyConfiguration

public typealias BlockContextContractsContractGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractBalanceGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractCounterGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractDelegateGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractEntrypointsGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractEntrypointsEntrypointGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractManagerKeyGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractScriptGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractScriptNormalizedPostConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractSingleSaplingGetDiffGetConfiguration = BlockContextSaplingStateGetDiffGetConfiguration
public typealias BlockContextContractsContractStorageGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextContractsContractStorageNormalizedPostConfiguration = HeadersOnlyConfiguration

public typealias BlockContextDelegatesDelegateGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesCurrentFrozenDepositsGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesDeactivatedGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesDelegatedBalanceGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesDelegatedContractsGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesFrozenDepositsGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesFrozenDeposistsLimitGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesFullBalanceGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesGracePeriodGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesParticipationGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesStakingBalanceGetConfiguration = HeadersOnlyConfiguration
public typealias BlockContextDelegatesVotingPowerGetConfiguration = HeadersOnlyConfiguration

public struct BlockContextSaplingStateGetDiffGetConfiguration: BaseConfiguration {
    public let commitmentOffset: UInt64?
    public let nullifierOffset: UInt64?
    public let headers: [HTTPHeader]
    
    public init(commitmentOffset: UInt64? = nil, nullifierOffset: UInt64? = nil, headers: [HTTPHeader] = []) {
        self.commitmentOffset = commitmentOffset
        self.nullifierOffset = nullifierOffset
        self.headers = headers
    }
}

public typealias BlockHeaderGetConfiguration = HeadersOnlyConfiguration

public typealias BlockHelpersPreapplyOperationsPostConfiguration = HeadersOnlyConfiguration
public typealias BlockHelpersScriptsRunOperationPostConfiguration = HeadersOnlyConfiguration

public typealias BlockOperationsGetConfiguration = HeadersOnlyConfiguration
