import Foundation
import TezosCore

public let tezosNode: URL = .init(string: "https://testnet-tezos.giganode.io")!

public extension Array where Element == UInt8 {
    
    func toHex() -> String {
        .init(HexString(from: self))
    }
}
