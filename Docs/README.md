# Address

The Tezos Swift SDK comes with support for the **tz**, **KT** and **zet** addresses. The addresses, however, can't be used
as plain strings across the library. To improve typing and compile-time checks, a few wrapper address types have been
introduced:

**tz**, **KT**
- `Address` (enum)
    - **tz**
      - `Address.Implicit` (enum)
      - **tz1**
        - `Ed25519PublicKeyHash`
      - **tz2**
        - `Secp256K1PublicKeyHash`
      - **tz3**
        - `P256PublicKeyHash`
    - **KT**
      - `Address.Originated` (enum)`
      - **KT1**
        - `ContractHash`

**zet1**
- `SaplingAddress`

Different types may be required depending on the use case. 

## `Address` (type)

`Address` is the most general address type that covers all the **tz** and **KT** addresses. It is an enum with associated values: `.implicit(Address.Implicit)` and `.originated(Address.Originated)`. 

To create an `Address` instance use its constructor:

```swift
import TezosCore

let tz1Address = try Address(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e")
let tz2Address = try Address(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
let tz3Address = try Address(base58: "tz3Nk25g51knuzFZZz2DeA5PveaQYmCtV68B")
let kt1Address = try Address(base58: "KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7")
```

or use one of the actual `struct`s that represent an address:

```swift
import TezosCore

let tz1Address = try Ed25519PublicKeyHash("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e").asAddress()
let tz2Address = try Secp256K1PublicKeyHash("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e").asAddress()
let tz3Address = try P256PublicKeyHash("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e").asAddress()
let kt1Address = try ContractHash("KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7").asAddress()
```

### `Address.Implicit` (type)

`Address.Implicit` is an address type that covers all the **tz** addresses. It is an enum with associated values: `.tz1(Ed25519PublicKeyHash)`, `.tz2(Secp256K1PublicKeyHash)` and `.tz3(P256PublicKeyHash)`. 

To create an `ImplicitAddress` instance use its constructor:

```swift
import TezosCore

let tz1ImplicitAddress = try Address.Implicit(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e")
let tz2ImplicitAddress = try Address.Implicit(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
let tz3ImplicitAddress = try Address.Implicit(base58: "tz3Nk25g51knuzFZZz2DeA5PveaQYmCtV68B")
```

or use one of the actual `struct`s that represent an address:

```swift
import TezosCore

let tz1ImplicitAddress = try Ed25519PublicKeyHash(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e").asImplicitAddress()
let tz2ImplicitAddress = try Secp256K1PublicKeyHash(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e").asImplicitAddress()
let tz3ImplicitAddress = try P256PublicKeyHash(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e").asImplicitAddress()
```

`Address.Implicit` can also be easily transformed to `Address`:

```swift
import TezosCore

let tz1Address = try Address.Implicit(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e").asAddress()
let tz2Address = try Address.Implicit(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy").asAddress()
let tz3Address = try Address.Implicit(base58: "tz3Nk25g51knuzFZZz2DeA5PveaQYmCtV68B").asAddress()
```

### `Address.Originated` (type)

`Address.Originated` is an address type that covers all the **KT** addresses. It is an enum with associated values: `.kt1(ContractHsh)`.

To create an `Address.Originated` instance use its constructor:

```swift
import TezosCore

let kt1OriginatedAddress = try Address.Originated(base58: "KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7")
```

or use one of the actual `struct`s that represent an address:

```swift
import TezosCore

let kt1OriginatedAddress = try ContractHash(base58: "KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7").asOriginatedAddress()
```

`Address.Originated` can also be easily trasformed to `Address`:

```swift
import TezosCore

let kt1Address = Address.Originated(base58: "KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7").asAddress()
```

# Base58 Encoded Data

Similarly to the addresses, the use of a plain string Base58 encoded data (i.e. string values whose data type can be 
recognized by their Base58 prefix, e.g. **sig**, **Net**, **expr**, etc.) is not supported. The data must be first wrapped
in its responding type before it can be used in the library, for example:

```swift
import TezosCore

let blockHash = try BlockHash(base58: "BLrUSnmhoWczorTYG8utWTLcD8yup6MX1MCehXG8f8QWew8t1N8")
let chainID = try ChainID(base58: "NetXPduhFKtb9SG")
let ed25519PublicKey = try Ed25519PublicKey(base58: "edpktmJqEE79FtfdWse1gqnUey1vNBkB3zNV99Pi95SRAs8NMatczG")
```

# Micheline

The Tezos Swift SDK provides various features to make working with Micheline expressions easier. It can help developers
to deserialize and serialize expressions to a JSON string, pack and unpack it using an optional schema or convert it to
a better typed `Michelson` structure.

All features mentioned in this section are provided in the `TezosMichelson` package.

## JSON Serialization

Micheline types are `Codable` which means they can be deserialized and serialized to a JSON string out of the box:

```swift
import Foundation
import TezosMichelson

let micheline = try JSONDecoder().decode(Micheline.self, from: .init(#"{ "int": "10" }"#.utf8))
let json = String(data: try JSONEncoder().encode(micheline), encoding: .utf8)
```

## Create an Expression

Sometimes it may be useful to create a Micheline expression directly in the code, for example to define a packing schema
or provide contract call parameters.

The examples below present how to create Micheline expressions. Each example features a reference JSON to help you
understand what the final expression is going to look like.

### Literals

#### Int

JSON
```json
{
  "int": "10"
}
```

Expression
```swift
import TezosMichelson

let int: Micheline = .int(10)
```

#### String

JSON
```json
{
  "string": "value"
}
```

Expression
```swift
import TezosMichelson

let string: Micheline = try .string("value")
```

#### Bytes

JSON
```json
{
  "bytes": "0a"
}
```

Expression
```swift
import TezosMichelson

let bytes: Micheline = try .bytes("0a")
```

### Prims

#### Data

JSON
```json
{
  "prim": "Pair",
  "args": [
    {
      "prim": "Some",
      "args": [
        {
          "int": "10"
        }
      ]
    },
    {
      "prim": "Left",
      "args": [
        {
          "string": "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"
        }
      ]
    }
  ]
}
```

Expression
```swift
import TezosMichelson

let pair: Micheline = .data(
    prim: .pair,
    args: [
        .data(
            prim: .some,
            args: [.int(10)]
        ),
        .data(
            prim: .left,
            args: [try .string("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e")]
        )
    ]
)
```

#### Instruction

JSON
```json
{
  "prim": "MAP",
  "args": [
    [
      {
        "prim": "DIG",
        "args": [
          {
            "int": "2"
          }
        ]
      },
      {
        "prim": "DUP"
      },
      {
        "prim": "DUG",
        "args": [
          {
            "int": "3"
          }
        ]
      },
      {
        "prim": "SWAP"
      }
    ]
  ]
}
```

Expression
```swift
import TezosMichelson

let pair: Micheline = .instruction(
    prim: .map,
    args: [
        .sequence([
            .instruction(
                prim: .dig,
                args: [.int(2)]
            ),
            .instruction(prim: .dup),
            .instruction(
                prim: .dug,
                args: [.int(3)]
            ),
            .instruction(prim: .swap)
        ])
    ]
)
```

#### Types

JSON
```json
{
  "prim": "pair",
  "args": [
    {
      "prim": "option",
      "args": [
        {
          "prim": "nat",
          "annots": [
            "%nat"
          ]
        }
      ]
    },
    {
      "prim": "or",
      "args": [
        {
          "prim": "address",
          "annots": [
            "%address"
          ]
        },
        {
          "prim": "bytes",
          "annots": [
            "%bytes"
          ]
        }
      ]
    }
  ]
}
```

Expression
```swift
import TezosMichelson

let pair: Micheline = .comparableType(
    prim: .pair,
    args: [
        .comparableType(
            prim: .option,
            args: [
                try .comparableType(prim: .nat, annots: ["%nat"])
            ]
        ),
        .comparableType(
            prim: .or,
            args: [
                try .comparableType(prim: .address, annots: ["%address"]),
                try .comparableType(prim: .bytes, annots: ["%bytes"])
            ]
        )
    ]
)
```

### Sequences

JSON
```json
[
  {
    "prim": "DUP"
  },
  {
    "prim": "CDR"
  },
  {
    "prim": "SWAP"
  }
]
```

Expression
```swift
import TezosMichelson

let pair: Micheline = .sequence([
    .instruction(prim: .dup),
    .instruction(prim: .cdr),
    .instruction(prim: .swap)
])
```

## Pack and Unpack

To serialize a Micheline expression to its optimized binary representation use `packToBytes(usingSchema:)`,
to deserialize a Micheline expression from the optimized binary representation use `init(fromPacked:)`:

```swift
import TezosMichelson

let micheline: Micheline = try .string("tz1ZBuF2dQ7E1b32bK3g1Qsah4pvWqpM4b4A")
let schema: Micheline = .comparableType(prim: .address)

let packedBytes = try micheline.packToBytes(usingSchema: schema) // = [5, 10, 0, 0, 0, 22, 0, 0, 148, 160, 186, 39, 22, 158, 216, 217, 124, 31, 71, 109, 230, 21, 108, 36, 130, 219, 251, 61]
let unpackedFromBytes = try Micheline(fromPacked: packedBytes, usingSchema: schema) // = { "string": "tz1ZBuF2dQ7E1b32bK3g1Qsah4pvWqpM4b4A" }
```

# `Michelson` (type)

The `Michelson` type is the SDK representation of the Smart Contract language. It provides a much
more strictly typed interface than `Micheline` and it can be converted to a Micheline expression
or created out of it.

## Create Expression

`Michelson` splits into `Michelson.Data`, `Michelson.Instruction`, `Michelson.`Type`` and `Michelson.ComparableType`
types, defined based on [the grammar specification](https://tezos.gitlab.io/active/michelson.html#full-grammar):

- `Michelson`
  -  `Michelson.Data`
    - ...
    - `Michelson.Instruction (: MichelsonData)`
      - ...
  - `Michelson.`Type``
    - ...
    - `Michelson.ComparableType`
      - ...

The examples below present how to create Michelson expressions. Each example features a reference JSON to help you
understand what the final expression (in Micheline) is going to look like.

### MichelsonData

JSON
```json
{
  "prim": "Pair",
  "args": [
    {
      "prim": "Some",
      "args": [
        {
          "int": "10"
        }
      ]
    },
    {
      "prim": "Left",
      "args": [
        {
          "string": "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"
        }
      ]
    }
  ]
}
```

Expression
```swift
import TezosMichelson

let michelson: Michelson = .data(
    .pair(try .init(
        .some(.init(value: .int(.init(10)))),
        .left(.init(value: try .string(.init("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"))))
    ))
)

```

### MichelsonInstruction

JSON
```json
{
  "prim": "MAP",
  "args": [
    [
      {
        "prim": "DIG",
        "args": [
          {
            "int": "2"
          }
        ]
      },
      {
        "prim": "DUP"
      },
      {
        "prim": "DUG",
        "args": [
          {
            "int": "3"
          }
        ]
      },
      {
        "prim": "SWAP"
      }
    ]
  ]
}
```

Expression
```swift
import TezosMichelson

let michelson: Michelson = .data(
    .instruction(
        .map(.init(expression: .init(
            .dig(.init(n: 2)),
            .dup(.init()),
            .dug(.init(n: 3)),
            .swap(.init())
        )))
    )
)
```

### MichelsonType

JSON
```json
{
  "prim": "pair",
  "args": [
    {
      "prim": "option",
      "args": [
        {
          "prim": "nat",
          "annots": [
            "%nat"
          ]
        }
      ]
    },
    {
      "prim": "or",
      "args": [
        {
          "prim": "address",
          "annots": [
            "%address"
          ]
        },
        {
          "prim": "chest_key",
          "annots": [
            "%chest_key"
          ]
        }
      ]
    }
  ]
}
```

```swift
import TezosMichelson

let michelson: Michelson = .type(
    .pair(try .init(
        .comparable(
            .option(.init(
                type: .nat(.init(metadata: .init(typeName: try .init(value: "%nat"))))
            ))
        ),
        .or(.init(
            lhs: .comparable(
                .address(.init(metadata: .init(typeName: try .init(value: "%address"))))
            ),
            rhs: .chestKey(.init(metadata: .init(typeName: try .init(value: "%chest_key"))))
        ))
    ))
)
```

### MichelsonComparableType

JSON
```json
{
  "prim": "pair",
  "args": [
    {
      "prim": "option",
      "args": [
        {
          "prim": "nat",
          "annots": [
            "%nat"
          ]
        }
      ]
    },
    {
      "prim": "or",
      "args": [
        {
          "prim": "address",
          "annots": [
            "%address"
          ]
        },
        {
          "prim": "bytes",
          "annots": [
            "%bytes"
          ]
        }
      ]
    }
  ]
}
```

```swift
import TezosMichelson

let michelson: Michelson = .type(
    .comparable(
        .pair(try .init(
            .option(.init(
                type: .nat(.init(metadata: .init(typeName: try .init(value: "%nat"))))
            )),
            .or(.init(
                lhs: .address(.init(metadata: .init(typeName: try .init(value: "%address")))),
                rhs: .bytes(.init(metadata: .init(typeName: try .init(value: "%bytes"))))
            ))
        ))
    )
)
```

## Micheline Conversion

To convert values between the `Michelson` and `Micheline` types use the`init(from:)` constructors defined for both types:

```swift
import it.airgap.tezos.michelson.MichelsonComparableType
import it.airgap.tezos.michelson.MichelsonType
import it.airgap.tezos.michelson.converter.toMicheline
import it.airgap.tezos.michelson.converter.toMichelson

let pair: Michelson = .type(
    .pair(try .init(
        .comparable(
            .option(.init(
                type: .nat(.init())
            ))
        ),
        .or(.init(
            lhs: .comparable(.unit(.init())),
            rhs: .map(.init(
                keyType: .bytes(.init()),
                valueType: .comparable(.address(.init()))
            ))
        ))
    ))
)

let micheline = try Micheline(from: pair)
let michelson = try Michelson(from: micheline)
```

# Operation

The Tezos Swift SDK comes with means to create Tezos operations, forge and sign them.

All features mentioned in this section are provided in the `TezosOperation` module.

## Create

To create a `TezosOperation` instance use its constructor:

```swift
import TezosCore
import TezosOperation

let unsigned = TezosOperation(
    branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"),
    contents: [
        .transaction(.init(
            source: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"),
            counter: .init(UInt(1)),
            amount: .init(1000),
            destination: try .init(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
        ))
    ]
)

let signed = TezosOperation(
    branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"),
    contents: [
        .transaction(.init(
            source: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"),
            counter: .init(UInt(1)),
            amount: .init(1000),
            destination: try .init(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
        ))
    ],
    signature: try .init(base58: "sigTAzhy1HsZDLNETmuf9RuinhXRb5jvmscjCoPPBujWZgFmCFLffku7JXYtu8aYQFVHnCUghmd4t39RuR6ANV76bCCYTR9u")
)
```

or explicitly use one of the `TezosOperation` types constructor. `TezosOperation` can be either `TezosOperation.Unsigned` or `TezosOperation.Signed`:

```swift
import TezosCore
import TezosOperation

let unsigned = TezosOperation.Unsigned(
    branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"),
    contents: [
        .transaction(.init(
            source: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"),
            counter: .init(UInt(1)),
            amount: .init(1000),
            destination: try .init(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
        ))
    ]
).asOperation()

let signed = TezosOperation.Signed(
    branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"),
    contents: [
        .transaction(.init(
            source: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"),
            counter: .init(UInt(1)),
            amount: .init(1000),
            destination: try .init(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
        ))
    ],
    signature: try .init(base58: "sigTAzhy1HsZDLNETmuf9RuinhXRb5jvmscjCoPPBujWZgFmCFLffku7JXYtu8aYQFVHnCUghmd4t39RuR6ANV76bCCYTR9u")
).asOperation()
```

## Forge

To forge an operation use the `forge` method, to unforge an operation use `init(fromForged:)` 
or `unforgeFromString`.

```swift
import TezosCore
import TezosOperation

let operation = TezosOperation(
    branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"),
    contents: [
        .transaction(.init(
            source: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"),
            counter: .init(UInt(1)),
            amount: .init(1000),
            destination: try .init(base58: "tz2AjVPbMHdDF1XwHVhUrTg6ZvqY83AYhJEy")
        ))
    ]
)

let forgedBytes = try operation.forge()
let unforgedFromBytes = try TezosOperation(fromForged: forgedBytes)
```

## Sign and Verify

Sign an operation with the `sign(with:)` method:

```swift
import TezosCore
import TezosOperation

let secretKey = try Ed25519SecretKey(base58: "edskRv7VyXGVZb8EsrR7D9XKUbbAQNQGtALP6QeB16ZCD7SmmJpzyeneJVg3Mq56YLbxRA1kSdAXiswwPiaVfR3NHGMCXCziuZ")

let unsigned = TezosOperation(branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"))
let signed = try unsigned.sign(with: secretKey.asSecretKey())
```

*Note: If you sign `TezosOperation.Signed`, the old signature will be discarded and replaced with the new one.*

You can also generate the signature only by calling `sign(_:)` on the secret key:

```swift
import TezosCore
import TezosOperation

let secretKey = try Ed25519SecretKey(base58: "edskRv7VyXGVZb8EsrR7D9XKUbbAQNQGtALP6QeB16ZCD7SmmJpzyeneJVg3Mq56YLbxRA1kSdAXiswwPiaVfR3NHGMCXCziuZ")

let unsigned = TezosOperation(branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"))
let signature = try secretKey.sign(unsigned)
```

To verify the operation's signature call `verify(with:)` on the signed operation or `verify(_:)` on the public key:

```swift
import TezosCore
import TezosOperation

let publicKey = try Ed25519PublicKey(base58: "edpkttZKC51wemRqL2QxwpMnEKxWnbd35pq47Y6xsCHp5M1f7LN8NP")

let signed = TezosOperation.Signed(
    branch: try .init(base58: "BMdhifZkcb5i9D6FnBi19SSBjft3sYaeKDAsEBgbsRLPTihQQJU"),
    signature: try .init(base58: "edsigtyqcyfipEAqFVexKahDjtQkzFgAkd9MroyYHnxxUVHAi4oSBJSezwiKaoNpH9NkY34cNuR4nrL6s8oPWVstQp9h2f7iGQF")
)

let isSignatureValid1 = try signed.verify(with: publicKey.asPublicKey())
let isSignatureValid2 = try publicKey.verify(signed)
```

# RPC

You can use the Tezos Swift SDK to directly interact with a Tezos node. This means that the library provides the developers
with tools to easily make HTTP request to fetch the node's data or inject operations. Additionally, the SDK can estimate
the minimum fee that is required to inject an operation.

All features mentioned in this section are provided in the `TezosRPC` package.

## Interact With a Node

Create a `TezosRPC` instance and use its interface to make calls to a node of your choice:

```swift
import TezosRPC

let tezosRPC = TezosRPC<URLSessionHTTP>.create(nodeURL: URL(string: "https://testnet-tezos.giganode.io")!)

let block = try await tezosRPC.getBlock()
let balance = try await tezosRPC.getBalance(contractID: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c"))
```

More advanced users can also use the interface that has been designed to be a direct mapping of the actual HTTP paths, 
as defined in the [shell](https://tezos.gitlab.io/shell/rpc.html) and [active](https://tezos.gitlab.io/active/rpc.html)
RPC reference documentation:

```swift
import TezosRPC

let tezosRPC = TezosRPC<URLSessionHTTP>.create(nodeURL: URL(string: "https://testnet-tezos.giganode.io")!)

let block = try await tezosRPC.chains.main.blocks.head.get()
let balance = try await tezosRPC.chains.main.blocks.head.context.contracts(contractID: try .init(base58: "tz1PwXjsrgYBi9wpe3tFhazJpt7JMTVzBp5c")).balance.get()
```

## Estimate the Operation Fee

You can estimate the minimum fee required for the operation to be injected with the `minFee(operation:)` method
defined for `TezosRPC`:

```swift
import TezosRPC

let tezosRPC = TezosRPC<URLSessionHTTP>.create(nodeURL: URL(string: "https://testnet-tezos.giganode.io")!)

let branch = try await tezosRPC.getBlock().hash
let operation = TezosOperation(branch = branch)
let operationWithFee = try await tezosRPC.minFee(operation: operation)
```

# Contract

The Tezos Swift SDK exposes a Smart Contract handler whose purpose is to simplify the interaction with contract's
storage and code. The handler ships with methods to read a contract's storage and prepare operations with parameters
matching the contract's code.

You can create the handler with the factory method:

```swift
import TezosCore
import TezosContract

let contract = TezosContract.create(
    nodeURL: URL(string: "https://tezos-jakartanet-node.prod.gke.papers.tech")!,
    address: try .init(base58: "KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7")
)
```

All features mentioned in this section are provided in the `TezosContract` module.

## Read the Storage

To read the contract's storage with the handler, simply call:

```swift
import TezosCore
import TezosContract

let contract = TezosContract.create(
    nodeURL: URL(string: "https://tezos-jakartanet-node.prod.gke.papers.tech")!,
    address: try .init(base58: "KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7")
)
let storageEntry = try await contract.storage.get()
```

The returned `storageEntry` will be of the `ContractStorageEntry` type or `nil` if the storage couldn't be read. 
The `ContractStorageEntry` type is meant to be a handler for the storage values which will allow you to access the data
even if you're not familiar with the exact contract's storage structure and just want to access a piece of data by its
annotation. The `ContractStorageEntry` value may be one of the following:
- `ContractStorageEntry.Value`\
Holds a raw value, for example a string literal.


- `ContractStorageEntry.Object`\
Holds an object-like structure, mapped from, for example, a `pair` primitive application.
The value's arguments are also `ContractStorageEntry` and can be referenced by their annotations, if any.


- `ContractStorageEntry.Sequence`\
Holds a list of `ContractStorageEntry` values, mapped from a Micheline sequence.


- `ContractStorageEntry.Map`\
Holds a map of `ContractStorageEntry` values where the keys are also of the `ContractStorageEntry` type.
Created from a sequence of `Elt` objects.


- `ContractStorageEntry.BigMap`\
Holds a BigMap id and can further fetch the BigMap value which is also mapped to the `ContractStorageEntry` handler.

To better understand how to read data from `ContractStorageEntry`, let's assume the contract's storage is of a type
defined as follows:
```json
{
  "prim": "pair",
  "args": [
    {
      "prim": "big_map",
      "args": [
        {
          "prim": "address"
        },
        {
          "prim": "nat",
          "annots": [
            ":balance"
          ]
        }
      ],
      "annots": [
        "%ledger"
      ]
    },
    {
      "prim": "pair",
      "args": [
        {
          "prim": "address",
          "annots": [
            "%admin"
          ]
        },
        {
          "prim": "pair",
          "args": [
            {
              "prim": "bool",
              "annots": [
                "%paused"
              ]
            },
            {
              "prim": "nat",
              "annots": [
                "%total_supply"
              ]
            }
          ]
        }
      ],
      "annots": ["%fields"]
    }
  ]
}
```

and the returned value in Micheline is:

```json
{
  "prim": "Pair",
  "args": [
    {
      "int": "51296"
    },
    {
      "prim": "Pair",
      "args": [
        {
          "bytes": "0000a7848de3b1fce76a7ffce2c7ce40e46be33aed7c"
        },
        {
          "prim": "Pair",
          "args": [
            {
              "prim": "True"
            },
            {
              "int": "20"
            }
          ]
        }
      ]
    }
  ]
}
```

The individual values from the storage could be read as below:
```swift
let storageEntry = try await contract.storage.get()

guard case let .object(objectEntry) = storageEntry else { return }
guard case let .object(fields) = objectEntry["%fields"] else { return }

let ledger = objectEntry["%ledger"].value // = { "int": "51296" }
let admin = fields["%admin"].value // = { "bytes": "0000a7848de3b1fce76a7ffce2c7ce40e46be33aed7c" }
let paused = fields["%paused"].value // = { "prim": "True" }
let totalSupply = fields["%total_supply"].value // = { "int": "20" }
```

If you don't want to use the handler and process the storage value as raw Micheline, you can access it with the
`value` property defined for `ContractStorageEntry`:

```swift
let storageEntry = try await contract.storage.get()
let micheline = storageEntry?.value
```

### Read a BigMap

When one of the contract's storage value is of the `ContractStorageEntry.BigMap` type, you can use that handler to further fetch the BigMap
data. The example below fetches the value stored under the `"my_key"` key, if `storageEntry` is a BigMap handler.

```swift
if case let .bigMap(bigMapEntry) = storageEntry {
    let bigMapValue = try await bigMapEntry.get(forKey: try .string("my_key"))
}
```

## Prepare a Call

To prepare a contract call with the handler, first create an entrypoint handler:

```swift
import TezosCore
import TezosContract

let contract = TezosContract.create(
    nodeURL: URL(string: "https://tezos-jakartanet-node.prod.gke.papers.tech")!,
    address: try .init(base58: "KT1HNqxFJxnmUcX8wF915wxxaAAU4ixDwWQ7")
)

let `default` = contract.entrypoint()
let transfer = contract.entrypoint(.named("transfer"))
```

You can then invoke the entrypoint handler. The handler takes 2 required arguments, the source of the call and
parameters. The parameters can be provided as plain Micheline:

```swift
import TezosContract

let unsigned = try await transfer(
    source: try .init(base58: "tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"),
    parameters: .sequence([
        .data(
            prim: .pair,
            args: [
                try .string("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"),
                .sequence([
                    .data(
                        prim: .pair,
                        args: [
                            try .string("tz1fJGtrdmckD3VkiDxqUEci5h4gGcvocw6e"),
                            .data(
                                prim: .pair,
                                args: [
                                    .int(0),
                                    .int(100)
                                ]
                            )
                        ]
                    )
                ])
            ]
        )
    ])
)
```

or with the custom contract entrypoint parameters builder:

```swift
import TezosContract

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
    ))
)
```

The library will generate a Micheline value from the object description specified with the builder based on the entrypoint's code.
The values will be placed based on their annotations, if **any is provided** or based on their order if **no annotation was specified for any value**.

By default, the entrypoint handler will also estimate the minimum fee for the operation it generates. However, you can override 
this behaviour by provided **both** the `fee` and `limits` arguments.
