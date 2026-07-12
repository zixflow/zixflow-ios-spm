// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Zixflow",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "DataPipelines", targets: ["ZixflowDataPipelines"]),
        .library(name: "MessagingPushAPN", targets: ["ZixflowMessagingPushAPN"]),
        .library(name: "MessagingPushFCM", targets: ["ZixflowMessagingPushFCM"]),
        .library(name: "MessagingInApp", targets: ["ZixflowMessagingInApp"]),
        .library(name: "Location", targets: ["ZixflowLocation"])
    ],
    targets: [
        .binaryTarget(
            name: "ZixflowDataPipelines",
            path: "ZixflowDataPipelines.xcframework"
        ),
        .binaryTarget(
            name: "ZixflowMessagingPushAPN",
            path: "ZixflowMessagingPushAPN.xcframework"
        ),
        .binaryTarget(
            name: "ZixflowMessagingPushFCM",
            path: "ZixflowMessagingPushFCM.xcframework"
        ),
        .binaryTarget(
            name: "ZixflowMessagingInApp",
            path: "ZixflowMessagingInApp.xcframework"
        ),
        .binaryTarget(
            name: "ZixflowLocation",
            path: "ZixflowLocation.xcframework"
        )
    ]
)
