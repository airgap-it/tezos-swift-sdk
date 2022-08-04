//
//  Limits.swift
//  
//
//  Created by Julia Samol on 18.07.22.
//

import BigInt
import TezosCore

public struct Limits: Hashable {
    public let perOperation: Operation
    public let perBlock: Block

    public init(perOperation: Operation, perBlock: Block) {
        self.perOperation = perOperation
        self.perBlock = perBlock
    }
    
    public init() {
        self.init(gasPerOperation: Default.perOperationGas, gasPerBlock: Default.perBlockGas, storagePerOperation: Default.perOperationStorage)
    }
    
    public init(gasPerOperation: UInt = Default.perOperationGas, gasPerBlock: UInt = Default.perBlockGas, storagePerOperation: UInt = Default.perOperationStorage) {
        self.init(perOperation: .init(gas: gasPerOperation, storage: storagePerOperation), perBlock: .init(gas: gasPerBlock))
    }

    public init(gasPerOperation: String = .init(Default.perOperationGas), gasPerBlock: String = .init(Default.perBlockGas), storagePerOperation: String = .init(Default.perOperationStorage)) throws {
        self.init(perOperation: try .init(gas: gasPerOperation, storage: storagePerOperation), perBlock: try .init(gas: storagePerOperation))
    }

    public struct Operation: Hashable {
        static var zero: Operation { .init(gas: BigUInt.zero, storage: BigUInt.zero) }
        
        let gasBigUInt: BigUInt
        let storageBigUInt: BigUInt
        
        public var gas: String {
            gasBigUInt.value
        }
        
        public var storage: String {
            storageBigUInt.value
        }
        
        public init(gas: UInt, storage: UInt) {
            self.init(gas: BigUInt(gas), storage: BigUInt(storage))
        }
        
        public init(gas: String, storage: String) throws {
            guard let gas = BigUInt(gas, radix: 10) else {
                throw TezosError.invalidValue("Invalid gas per operation limit value (\(gas)).")
            }
            
            guard let storage = BigUInt(storage, radix: 10) else {
                throw TezosError.invalidValue("Invalid storage per operation limit value (\(storage)).")
            }
            
            self.init(gas: gas, storage: storage)
        }
        
        init(gas: BigUInt, storage: BigUInt) {
            self.gasBigUInt = gas
            self.storageBigUInt = storage
        }
        
        static func +(lhs: Operation, rhs: Operation) -> Operation {
            .init(gas: lhs.gasBigUInt + rhs.gasBigUInt, storage: lhs.storageBigUInt + rhs.storageBigUInt)
        }
    }

    public struct Block: Hashable {
        static var zero: Block { .init(gas: BigUInt.zero) }
        
        let gasBigUInt: BigUInt
        
        public var gas: String {
            gasBigUInt.value
        }
        
        public init(gas: UInt) {
            self.init(gas: BigUInt(gas))
        }
        
        public init(gas: String) throws {
            guard let gas = BigUInt(gas, radix: 10) else {
                throw TezosError.invalidValue("Invalid gas per block limit value (\(gas)).")
            }
            
            self.init(gas: gas)
        }
        
        init(gas: BigUInt) {
            self.gasBigUInt = gas
        }
        
        static func +(lhs: Block, rhs: Block) -> Block {
            .init(gas: lhs.gasBigUInt + rhs.gasBigUInt)
        }
    }
}

// MARK: Defaults

extension Limits {
    
    public enum Default {
        public static let perOperationGas: UInt = 1_040_000
        public static let perOperationStorage: UInt = 60_000
        
        public static let perBlockGas: UInt = 5_200_000
    }
}
