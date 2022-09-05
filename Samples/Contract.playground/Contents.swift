import TezosMichelson
import TezosContract

async {
    // MARK: Create
    
    let tezosDomains = TezosContract.create(nodeURL: tezosNode, address: try .init(base58: "KT1GFYUFQRT4RsNbtG2NU23woUyMp5tx9gx2"))
    
    // MARK: Get Storage
    
    let storage = try await tezosDomains.storage.get()
    
    guard case let .object(objectEntry) = storage else { throw Error.unexpectedValue }
    
    guard case let .bigMap(actions) = objectEntry["%actions"] else { throw Error.unexpectedValue }
    print("actions.id = \(actions.id)") // actions.id = 17073
    
    guard case let .object(store) = objectEntry["%store"] else { throw Error.unexpectedValue }
    
    guard case let .bigMap(records) = store["%records"] else { throw Error.unexpectedValue }
    print("records.id = \(records.id)") // records.id = 17077
    
    guard case let .bigMap(reverseRecords) = store["%reverse_records"] else { throw Error.unexpectedValue }
    print("reverseRecords.id = \(reverseRecords.id)") // reverseRecords.id = 17078
    
    // MARK: Get Value From BigMap
    
    let record = try await records.get(forKey: .bytes("aabbcc.jak".bytes))
    guard case let .object(addressEntry) = record else { throw Error.unexpectedValue }
    let address = try Michelson(from: addressEntry.value)
        .tryAs(Michelson.Data.Some.self).value
        .tryAs(Michelson.Data.StringConstant.self)
    
    print("address = \(address.value)") // address = "tz1Yj8M1R1VnDr8NsKRsJckgWxe1gj8QqZNS"
    
    let reverseRecord = try await reverseRecords.get(forKey: .string("tz1Yj8M1R1VnDr8NsKRsJckgWxe1gj8QqZNS"))
    guard case let .object(nameEntry) = reverseRecord else { throw Error.unexpectedValue }
    let name = try Michelson(from: nameEntry.value)
        .tryAs(Michelson.Data.Some.self).value
        .tryAs(Michelson.Data.ByteSequenceConstant.self)
    
    print("name = \(String(bytes: try [UInt8](hex: name.value)))") // name = "aabbcc.jak"
    
    // MARK: Prepare Entrypoint Call
    
    let transfer = tezosDomains.entrypoint(.named("transfer"))
    let unsigned = try await transfer(
        source: try .init(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"),
        parameters: .sequence(.init(
            .object(.init(
                .value(.init(try .string("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"), name: "%from_")),
                .sequence(.init(
                    .object(.init(
                        .value(.init(try .string("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"), name: "%to_")),
                        .value(.init(.int(0), name: "%token_id")),
                        .value(.init(.int(100), name: "%amount"))
                    )),
                    name: "%txs"
                ))
            ))
        )),
        configuredWith: .init(
            fee: try .init(505),
            limits: try .init(
                gas: "1521",
                storage: "100"
            )
        )
    )
}
