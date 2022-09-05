import Foundation
import TezosCore

public let tezosNode: URL = .init(string: "https://testnet-tezos.giganode.io")!

public enum Error: Swift.Error {
    case unexpectedValue
}

extension Array where Element == UInt8 {
    
    init(hex: String) throws {
        self.init(from: try HexString(from: hex))
    }
}
