// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SVGKit",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "SVGKit",
            targets: ["SVGKit"]
        ),
        .library(
            name: "SVGKitSwift",
            targets: ["SVGKitSwift"]
        )
    ],
    targets: [
        .target(
            name: "SVGKit",
            path: "Source",
            exclude: [
                "SwiftUI additions"
            ],
            resources: [.process("Resources/PrivacyInfo.xcprivacy")],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("privateHeaders"),
                .define("NS_BLOCK_ASSERTIONS", to: "1", .when(configuration: .release))
            ]
        ),
        .target(
            name: "SVGKitSwift",
            dependencies: [
                "SVGKit"
            ],
            path: "Source/SwiftUI additions"
        )
    ]
)
