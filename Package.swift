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
    targets: [
        .target(
            name: "AppIconKit"),
       .target(
           name: "appicon-generator",
           dependencies: ["AppIconKit"])
    ]
)
