// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TezosSwiftSDK",
    platforms: [
        .macOS(.v12),
        .iOS(.v10),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "TezosCore", targets: ["TezosCore"]),
        .library(name: "TezosMichelson", targets: ["TezosMichelson"]),
        .library(name: "TezosOperation", targets: ["TezosOperation"]),
        .library(name: "TezosRPC", targets: ["TezosRPC"]),
        .library(name: "TezosContract", targets: ["TezosContract"]),
        .library(name: "TezosCryptoDefault", targets: ["TezosCryptoDefault"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/keefertaylor/Base58Swift.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/attaswift/BigInt.git", .upToNextMajor(from: "5.3.0")),
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/jedisct1/swift-sodium.git", .upToNextMajor(from: "0.9.1")),
        .package(url: "https://github.com/GigaBitcoin/secp256k1.swift.git", .upToNextMajor(from: "0.6.0")),
//        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TezosCore",
            dependencies: ["Base58Swift", "BigInt"],
            path: "Sources/Core"),
        .target(
            name: "TezosMichelson",
            dependencies: ["TezosCore"],
            path: "Sources/Michelson"),
        .target(
            name: "TezosOperation",
            dependencies: ["TezosCore", "TezosMichelson"],
            path: "Sources/Operation"),
        .target(
            name: "TezosRPC",
            dependencies: ["TezosCore", "TezosMichelson", "TezosOperation"],
            path: "Sources/RPC"),
        .target(
            name: "TezosContract",
            dependencies: [
                "TezosCore",
                "TezosMichelson",
                "TezosOperation",
                "TezosRPC",
                .product(name: "OrderedCollections", package: "swift-collections")
            ],
            path: "Sources/Contract"),
        .target(
            name: "TezosCryptoDefault",
            dependencies: [
                "TezosCore",
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Clibsodium", package: "swift-sodium"),
                .product(name: "secp256k1", package: "secp256k1.swift"),
            ],
            path: "Sources/Crypto/Default"),
        
        // Tests
        .target(
            name: "TezosTestUtils",
            dependencies: ["TezosCore", "TezosMichelson"],
            path: "Tests/_Utils"),
        .testTarget(
            name: "TezosMichelsonTests",
            dependencies: ["TezosCore", "TezosMichelson", "TezosTestUtils"],
            path: "Tests/Michelson"),
        .testTarget(
            name: "TezosOperationTests",
            dependencies: [
                "TezosCore",
                "TezosOperation",
                "TezosTestUtils",
                .product(name: "Clibsodium", package: "swift-sodium"),
            ],
            path: "Tests/Operation"),
        .testTarget(
            name: "TezosRPCTests",
            dependencies: [
                "TezosCore",
                "TezosOperation",
                "TezosRPC",
                "TezosTestUtils",
            ],
            path: "Tests/RPC"),
        .testTarget(
            name: "TezosContractTests",
            dependencies: [
                "TezosCore",
                "TezosMichelson",
                "TezosOperation",
                "TezosRPC",
                "TezosContract",
                "TezosTestUtils",
            ],
            path: "Tests/Contract"),
        .testTarget(
            name: "TezosCryptoDefaultTests",
            dependencies: [
                "TezosCore",
                "TezosCryptoDefault",
                "TezosTestUtils",
            ],
            path: "Tests/Crypto/Default"),
    ]
)
