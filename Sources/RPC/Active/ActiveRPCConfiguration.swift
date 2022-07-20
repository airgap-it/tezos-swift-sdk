//
//  ActiveRPCConfiguration.swift
//  
//
//  Created by Julia Samol on 13.07.22.
//

import Foundation

public typealias GetBlockConfiguration = BlockGetConfiguration

public typealias GetBigMapConfiguration = BlockContextBigMapsBigMapGetConfiguration
public typealias GetBigMapValueConfiguration = BlockContextBigMapsBigMapValueGetConfiguration

public typealias GetConstantsConfiguration = BlockContextConstantsGetConfiguration

public typealias GetContractDetailsConfiguration = BlockContextContractsContractGetConfiguration
public typealias GetBalanceConfiguration = BlockContextContractsContractBalanceGetConfiguration
public typealias GetCounterConfiguration = BlockContextContractsContractCounterGetConfiguration
public typealias GetDelegateConfiguration = BlockContextContractsContractDelegateGetConfiguration
public typealias GetEntrypointsConfiguration = BlockContextContractsContractEntrypointsGetConfiguration
public typealias GetEntrypointConfiguration = BlockContextContractsContractEntrypointsEntrypointGetConfiguration
public typealias GetManagerKeyConfiguration = BlockContextContractsContractManagerKeyGetConfiguration
public struct GetScriptConfiguration: BaseConfiguration {
    public let unparsingMode: RPCScriptParsing
    public let headers: [HTTPHeader]
    
    public init(unparsingMode: RPCScriptParsing = .readable, headers: [HTTPHeader] = []) {
        self.unparsingMode = unparsingMode
        self.headers = headers
    }
}
public struct GetStorageConfiguration {
    public let unparsingMode: RPCScriptParsing
    public let headers: [HTTPHeader]
    
    public init(unparsingMode: RPCScriptParsing = .readable, headers: [HTTPHeader] = []) {
        self.unparsingMode = unparsingMode
        self.headers = headers
    }
}

public typealias GetDelegateDetailsConfiguration = BlockContextDelegatesDelegateGetConfiguration
public typealias GetCurrentFrozenDepositsConfiguration = BlockContextDelegatesCurrentFrozenDepositsGetConfiguration
public typealias IsDeactivatedConfiguration = BlockContextDelegatesDeactivatedGetConfiguration
public typealias GetDelegatedBalanceConfiguration = BlockContextDelegatesDelegatedBalanceGetConfiguration
public typealias GetDelegatedContractsConfiguration = BlockContextDelegatesDelegatedContractsGetConfiguration
public typealias GetFrozenDepositsConfiguration = BlockContextDelegatesFrozenDepositsGetConfiguration
public typealias GetFrozenDepositsLimitConfiguration = BlockContextDelegatesFrozenDeposistsLimitGetConfiguration
public typealias GetFullBalanceConfiguration = BlockContextDelegatesFullBalanceGetConfiguration
public typealias GetGracePeriodConfiguration = BlockContextDelegatesGracePeriodGetConfiguration
public typealias GetParticipationConfiguration = BlockContextDelegatesParticipationGetConfiguration
public typealias GetStakingBalanceConfiguration = BlockContextDelegatesStakingBalanceGetConfiguration
public typealias GetVotingPowerConfiguration = BlockContextDelegatesVotingPowerGetConfiguration

public typealias GetSaplingStateDiffConfiguration = BlockContextSaplingStateGetDiffGetConfiguration

public typealias GetBlockHeaderConfiguration = BlockHeaderGetConfiguration

public typealias PreapplyOperationsConfiguration = BlockHelpersPreapplyOperationsPostConfiguration
public typealias RunOperationConfiguration = BlockHelpersScriptsRunOperationPostConfiguration

public typealias GetOperationsConfiguration = BlockOperationsGetConfiguration
