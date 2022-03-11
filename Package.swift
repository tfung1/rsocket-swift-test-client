// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rsocket-swift-test-client",
    products: [
        .library(
            name: "rsocket-swift-test-client",
            targets: ["rsocket-swift-test-client"]),
        // Examples
        .executable(name: "request-response-client-example", targets: ["ClientExample", "rsocket-swift-test-client"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(
            url: "https://github.com/rsocket/rsocket-swift.git",
            .revision("6fc34008c188dd97f3f6526f3b438822b6428a11")
        ),
        .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", .exact("6.6.0")),
        .package(url: "https://github.com/apple/swift-nio", .exact("2.32.1")),
        .package(url: "https://github.com/apple/swift-nio-extras", .exact("1.8.0")),
        .package(url: "https://github.com/apple/swift-nio-transport-services", .exact("1.9.2")),
        .package(url: "https://github.com/apple/swift-nio-ssl", .exact("2.10.4")),
        .package(url: "https://github.com/apple/swift-argument-parser", .exact("0.4.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "rsocket-swift-test-client",
            dependencies: [
                .product(name: "RSocketCore", package: "rsocket-swift"),
                .product(name: "RSocketNIOChannel", package: "rsocket-swift"),
                .product(name: "RSocketReactiveSwift", package: "rsocket-swift"),
                .product(name: "RSocketWSTransport", package: "rsocket-swift"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "ReactiveSwift", package: "ReactiveSwift"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "rsocket-swift-test-clientTests",
            dependencies: [
                "rsocket-swift-test-client",
            ]
            ),
        // Examples
        .executableTarget(
            name: "ClientExample",
            dependencies: [
                "rsocket-swift-test-client",
            ],
            path: "Sources/Examples/RequestResponseClient"
        )
    ],
    swiftLanguageVersions: [.v5]
)
