// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
        .library(
            name: "NetworkServiceTestHelper",
            targets: ["NetworkServiceTestHelper"]
        ),
        .library(
            name: "NetworkServiceAsyncBeta",
            targets: ["NetworkServiceAsyncBeta"]
        ),
        .library(
            name: "NetworkServiceTestHelperAsyncBeta",
            targets: ["NetworkServiceTestHelperAsyncBeta"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.1.0"),
        .package(
            name: "combine-schedulers",
            url: "https://github.com/pointfreeco/combine-schedulers.git",
            .upToNextMajor(from: "0.5.0")
        ),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: []
        ),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: [
                "NetworkService",
                .product(name: "OHHTTPStubs", package: "OHHTTPStubs"),
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
            ]
        ),
        .target(
            name: "NetworkServiceAsyncBeta",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-warn-concurrency"])
            ]
        ),
        .testTarget(
            name: "NetworkServiceAsyncBetaTests",
            dependencies: [
                "NetworkServiceAsyncBeta",
                .product(name: "OHHTTPStubs", package: "OHHTTPStubs"),
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
            ]
        ),
        .target(
            name: "NetworkServiceTestHelper",
            dependencies: [
                "NetworkService",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-warn-concurrency"])
            ]
        ),
        .testTarget(
            name: "NetworkServiceTestHelperTests",
            dependencies: [
                "NetworkServiceTestHelper",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
        .target(
            name: "NetworkServiceTestHelperAsyncBeta",
            dependencies: ["NetworkServiceAsyncBeta", .product(name: "CombineSchedulers", package: "combine-schedulers")]
        ),
        .testTarget(
            name: "NetworkServiceTestHelperAsyncBetaTests",
            dependencies: [
                "NetworkServiceTestHelperAsyncBeta",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
    ]
)
