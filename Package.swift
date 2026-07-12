// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Zixflow",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "DataPipelines", targets: ["DataPipelines"]),
        .library(name: "MessagingPushAPN", targets: ["MessagingPushAPN"]),
        .library(name: "MessagingPushFCM", targets: ["MessagingPushFCM"]),
        .library(name: "MessagingInApp", targets: ["MessagingInApp"]),
        .library(name: "Location", targets: ["Location"])
    ],
    targets: [
        .binaryTarget(
            name: "DataPipelines",
            path: "DataPipelines.xcframework"
        ),
        .binaryTarget(
            name: "MessagingPushAPN",
            path: "MessagingPushAPN.xcframework"
        ),
        .binaryTarget(
            name: "MessagingPushFCM",
            path: "MessagingPushFCM.xcframework"
        ),
        .binaryTarget(
            name: "MessagingInApp",
            path: "MessagingInApp.xcframework"
        ),
        .binaryTarget(
            name: "Location",
            path: "Location.xcframework"
        )
    ]
)
