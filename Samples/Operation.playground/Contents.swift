import TezosCore
import TezosOperation
import TezosRPC

async {
    let tezosRPC = TezosRPC.create(nodeURL: tezosNode)
    
    let branch = try await tezosRPC.getBlock().hash
    let counter = try await tezosRPC.getCounter(contractID: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"))!
    
    // MARK: Create
    
    let unsigned = TezosOperation(
        branch: branch,
        contents: [
            .transaction(.init(
                source: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"),
                counter: try .init(counter),
                amount: try .init(1000),
                destination: try .init(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
            ))
        ]
    )
    
    let signed = TezosOperation(
        branch: branch,
        contents: [
            .transaction(.init(
                source: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"),
                counter: try .init(counter),
                amount: try .init(1000),
                destination: try .init(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
            ))
        ],
        signature: try .init(base58: "sigTAzhy1HsZDLNETmuf9RuinhXRb5jvmscjCoPPBujWZgFmCFLffku7JXYtu8aYQFVHnCUghmd4t39RuR6ANV76bCCYTR9u")
    )
    
    // MARK: Estimate Fee
    
    let unsignedWithFee = try await tezosRPC.minFee(operation: unsigned.asOperation())

    // MARK: Sign
    
    let secretKey = try Ed25519SecretKey(base58: "edskSA787kkcN7ZF9imyuArKxSYApt6YmQ2oNwKKH9PxFAux8fzrFmE6tzBecnbTRCW1jqN7S8crRoSbrczRxy3TwnycPCJKNr")
    let publicKey = try Ed25519PublicKey(base58: "edpkvVEnevzUZS5x1MsyTpAzsa87rY7h9N7vFaQdeM2BmXcRmZxriH")
    
    let signedWithFee = try unsignedWithFee.sign(with: secretKey.asSecretKey())
    let signature = try secretKey.sign(unsigned)
    
    assert(try! signed.verify(with: publicKey.asPublicKey()))
    assert(try! publicKey.verify(signedWithFee))

    // MARK: Inject
    
    let forged = try signedWithFee.forge()
    
    try await tezosRPC.injectOperation(forged.toHex())
}
