// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SmartCodable",
    platforms: [.macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v5), .visionOS(.v1)],
    products: [
        .library(
            name: "SmartCodable",
            targets: ["SmartCodable"]
        ),
    ],
    dependencies: [
        //.package(url: "")
    ],
    targets: [
        .target(
            name: "SmartCodable",
            dependencies: [
                
            ],
            path: "SmartCodable/Classes"
        ),
        .testTarget(
            name: "SmartCodableTests",
            dependencies: ["SmartCodable"]
        )
        
    ],
   swiftLanguageVersions: [.v5]
)
