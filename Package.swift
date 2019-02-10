// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "appicon-generator",
    products: [
        .library(
            name: "AppIconKit",
            type: .static,
            targets: ["AppIconKit"]
        ),
       .executable(
           name: "appicon-generator",
           targets: ["appicon-generator"]
       )
    ],
    dependencies: [
        // Adding SwiftLint as a dependency lets us do `swift run swiftlint`.
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1")
    ],
    targets: [
        .target(
            name: "AppIconKit"
        ),
        .target(
            name: "AppIconGeneratorCore",
            dependencies: ["AppIconKit"]
        ),
        .target(
            name: "appicon-generator",
            dependencies: ["AppIconKit", "AppIconGeneratorCore"]
        ),
        .testTarget(
            name: "AppIconGeneratorTests",
            dependencies: ["AppIconKit", "AppIconGeneratorCore"]
        )
    ]
)
