// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: Product.products,
    dependencies: Package.Dependency.dependencies,
    targets: Target.targets
)

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
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
            ],
            swiftSettings: .shared
        ),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: [
                .product(name: "CustomDump", package: "swift-custom-dump"),
                "NetworkService",
                .product(name: "OHHTTPStubs", package: "OHHTTPStubs"),
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
            ],
            swiftSettings: .shared
        ),
        .target(
            name: "NetworkServiceTestHelper",
            dependencies: [
                "NetworkService",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ],
            swiftSettings: .shared
        ),
        .testTarget(
            name: "NetworkServiceTestHelperTests",
            dependencies: [
                "NetworkServiceTestHelper",
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
                .product(name: "CustomDump", package: "swift-custom-dump"),
            ],
            swiftSettings: .shared
        ),
    ]
}

extension [SwiftSetting] {
    static let shared: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableExperimentalFeature("StrictConcurrency"),
    ]
}

extension Package.Dependency {
    static let dependencies: [Package.Dependency] = [
        .package(
            url: "https://github.com/AliSoftware/OHHTTPStubs.git",
            from: "9.1.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/combine-schedulers.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/apple/swift-http-types.git",
            from: "1.0.0"
        ),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump.git", from: "1.0.0"),
    ]
}
