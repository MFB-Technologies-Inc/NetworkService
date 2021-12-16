// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
        .library(
            name: "NetworkServiceTestHelper",
            targets: ["NetworkServiceTestHelper"]
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
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
            name: "NetworkServiceTestHelper",
            dependencies: ["NetworkService", .product(name: "CombineSchedulers", package: "combine-schedulers")]
        ),
        .testTarget(
            name: "NetworkServiceTestHelperTests",
            dependencies: [
                "NetworkServiceTestHelper",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ]
        ),
    ]
)
