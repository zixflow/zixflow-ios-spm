// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Zixflow",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Zixflow",
            targets: ["Zixflow"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Zixflow",
            path: "Zixflow.xcframework"
        )
    ]
)
