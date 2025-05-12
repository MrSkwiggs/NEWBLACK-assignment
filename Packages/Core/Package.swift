// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Shared",
            targets: ["API"]
        ),
    ],
    dependencies: [
        .package(path: "../Networking")
    ],
    targets: [
        .target(
            name: "Shared",
            dependencies: [
                "API"
            ],
            path: "Sources/Shared"
        ),
        .target(
            name: "API",
            dependencies: [
                "Networking"
            ],
            path: "Sources/API"
        ),

        .testTarget(
            name: "CoreTests",
            dependencies: ["Shared"]
        ),
    ]
)
