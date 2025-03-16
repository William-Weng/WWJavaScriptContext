// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWJavaScriptContext",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWJavaScriptContext", targets: ["WWJavaScriptContext"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWJavaScriptContext", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
