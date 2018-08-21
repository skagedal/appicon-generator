// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "appicon-generator",
    products: [
        .library(
            name: "AppIconGeneratorCore",
            type: .static,
            targets: ["AppIconGeneratorCore"]
        ),
       .executable(
           name: "appicon-generator",
           targets: ["appicon-generator"]
       )
    ],
    targets: [
        .target(
            name: "AppIconGeneratorCore"),
       .target(
           name: "appicon-generator",
           dependencies: ["AppIconGeneratorCore"])
    ]
)
