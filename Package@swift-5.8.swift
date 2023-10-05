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
        .target(name: "NetworkService"),
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

package.targets.strictConcurrency()

extension Array where Element == Target {
    func strictConcurrency() {
        forEach { target in
            target.swiftSettings = (target.swiftSettings ?? [])
                + [.enableUpcomingFeature("StrictConcurrency")]
        }
    }
}

extension Package.Dependency {
    static let dependencies: [Package.Dependency] = [
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.1.0"),
        .package(
            url: "https://github.com/pointfreeco/combine-schedulers.git",
            from: "1.0.0"
        ),
    ]
}
