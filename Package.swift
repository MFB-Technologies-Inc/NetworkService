// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: Product.products,
    dependencies: Package.Dependency.dependencies,
    targets: Target.targets
)

#if swift(>=5.5)
    extension Product {
        static let products: [Product] = [
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
        ]
    }

    extension Target {
        static let targets: [Target] = [
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
                    .unsafeFlags(["-Xfrontend", "-warn-concurrency"]),
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
                    .product(name: "CombineSchedulers", package: "combine-schedulers"),
                ],
                swiftSettings: [
                    .unsafeFlags(["-Xfrontend", "-warn-concurrency"]),
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
                dependencies: [
                    "NetworkServiceAsyncBeta",
                    .product(name: "CombineSchedulers", package: "combine-schedulers"),
                ]
            ),
            .testTarget(
                name: "NetworkServiceTestHelperAsyncBetaTests",
                dependencies: [
                    "NetworkServiceTestHelperAsyncBeta",
                    .product(name: "CombineSchedulers", package: "combine-schedulers"),
                ]
            ),
        ]
    }

    extension Package.Dependency {
        static let dependencies: [Package.Dependency] = [
            .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.1.0"),
            .package(
                name: "combine-schedulers",
                url: "https://github.com/pointfreeco/combine-schedulers.git",
                .upToNextMajor(from: "0.6.0")
            ),
        ]
    }

#else
    extension Product {
        static let products: [Product] = [
            .library(
                name: "NetworkService",
                targets: ["NetworkService"]
            ),
            .library(
                name: "NetworkServiceTestHelper",
                targets: ["NetworkServiceTestHelper"]
            ),
        ]
    }

    extension Target {
        static let targets: [Target] = [
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
                dependencies: [
                    "NetworkService",
                    .product(name: "CombineSchedulers", package: "combine-schedulers"),
                ]
            ),
            .testTarget(
                name: "NetworkServiceTestHelperTests",
                dependencies: [
                    "NetworkServiceTestHelper",
                    .product(name: "CombineSchedulers", package: "combine-schedulers"),
                ]
            ),
        ]
    }

    extension Package.Dependency {
        static let dependencies: [Package.Dependency] = [
            .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.1.0"),
            .package(
                name: "combine-schedulers",
                url: "https://github.com/pointfreeco/combine-schedulers.git",
                .upToNextMinor(from: "0.5.3")
            ),
        ]
    }
#endif
