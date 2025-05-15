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
        .library(
            name: "SharedMocks",
            targets: ["Mocks"]
        )
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMinor(from: "2.5.0"))
    ],
    targets: [
        .target(
            name: "Shared",
            dependencies: [
                "API",
                "Factory"
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
        .target(
            name: "Mocks",
            dependencies: ["Shared"],
            path: "Mocks"
        ),

        .testTarget(
            name: "SharedTests",
            dependencies: ["Shared", "Mocks"],
            path: "Tests/Shared"
        ),
        .testTarget(
            name: "APITests",
            dependencies: ["API"],
            path: "Tests/API"
        ),
    ]
)
