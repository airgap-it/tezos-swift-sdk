# Tezos Swift SDK

[![stable](https://img.shields.io/github/v/tag/airgap-it/tezos-swift-sdk?label=stable&sort=semver)](https://github.com/airgap-it/tezos-swift-sdk/releases)
[![latest](https://img.shields.io/github/v/tag/airgap-it/tezos-swift-sdk?color=orange&include_prereleases&label=latest)](https://github.com/airgap-it/tezos-swift-sdk/releases)
[![license](https://img.shields.io/github/license/airgap-it/tezos-swift-sdk)](https://github.com/airgap-it/tezos-swift-sdk/blob/master/LICENSE)

A Swift library to interact with the Tezos blockchain.

## Use Cases

The Tezos Swift SDK ships with tools that can be used to:

*General*
  - convert a Base58 encoded string to bytes and vice versa

*Michelson/Micheline*
  - parse or create a Micheline JSON string
  - pack and unpack Micheline
  - convert Micheline to typed Michelson and vice versa

*Operations*
- create an unsigned or signed Tezos operation
- forge and unforge an operation
- sign an operation and verify the signature

*RPC*
- interact with a Tezos node
- estimate the operation fee

*Contract*
- read a contract's storage
- read BigMaps
- prepare contract calls

## Requirements

The Tezos Swift SDK requires:

- iOS 13
- macOS 10.15

## Modules Overview

The Tezos Swift SDK is a multi-package project. It has been designed to allow its users to use only the required minimum of functionality that meets their needs, thus optimizing the amount of redundant and unwanted code and dependencies.
The library modules can be divided into 3 categories:
- Core
- Plugin
- Default Provider

### Core Modules

The core modules are the basis for other modules. They are required for the SDK to work as expected.

| Core Module   | Description                                                          | Module Dependencies |
|---------------|----------------------------------------------------------------------|---------------------|
| `TezosCore`   | Provides base Tezos types and actions that can be performed on them. | ✖️                  |

### Plugin Modules
The plugin modules are optional and come with additional functionality. They should be registered in the appropriate core components before use.

| Plugin Module      | Description                                                                                                                                                                                                   | Module Dependencies                                                                  |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| `TezosMichelson`   | Provides [Michelson](https://tezos.gitlab.io/active/michelson.html) and [Micheline](https://tezos.gitlab.io/shell/micheline.html) types and actions, e.g. `pack`/`unpack`.                                    | `TezosCore`                                                                          |
| `TezosOperation`   | Provides Tezos Operation structures as defined in [the P2P message format](https://tezos.gitlab.io/shell/p2p_api.html) and actions that can be performed on them, e.g. `forge`/`unforge` and `sign`/`verify`. | `TezosCore` <br /> `TezosMichelson`                                                  |
| `TezosRPC`         | Provides a Tezos RPC client which should be used to interact with Tezos nodes.                                                                                                                                | `TezosCore` <br /> `TezosMichelson` <br /> `TezosOperation`                          |
| `TezosContract`    | Provides a Tezos contract handler which should be used to interact with Tezos contracts.                                                                                                                      | `TezosCore` <br /> `TezosMichelson` <br /> `TezosOperation` <br />`TezosRPC`         |

### Default Provider Modules
The default provider modules are optional and come with default implementations of various components that can be provided externally.

| Default Provider Module      | Description                                                                                                                                                                                                                           | Module Dependencies |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| `TezosCryptoDefault`         | Uses [Swift Crypto](https://github.com/apple/swift-crypto), [Swift-Sodium](https://github.com/jedisct1/swift-sodium) and [secp256k1.swift](https://github.com/GigaBitcoin/secp256k1.swift) to satisfy the cryptographic requirements. | `TezosCore`         |

## Setup

See the below guides to learn how to add the Tezos Swift SDK into your project.

### SPM

To add the Tezos Swift SDK with [the Swift Package Manager](https://swift.org/package-manager/), add the Tezos Swift SDK package dependency:

#### Xcode

Open the `Add Package Dependency` window (as described in [the official guide](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)) and enter the Tezos Swift SDK GitHub repository URL:
```
https://github.com/airgap-it/tezos-swift-sdk
```

#### Package.swift file

Add the following dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/airgap-it/tezos-swift-sdk", from: "x.y.z")
```

## Documentation

A high level guide on how to use the library can be found in the [docs](https://github.com/airgap-it/tezos-swift-sdk/tree/main/Docs).
To try out the library in action, see the [Samples](https://github.com/airgap-it/tezos-swift-sdk/tree/main/Samples).
