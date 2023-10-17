
import PackageDescription

let package = Package(
    name: "SmartCodable",
    platforms: [.iOS(.v13)],
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
                "SmartCodable"
            ],
            path: "SmartCodable/Classes"
        )
    ]
)