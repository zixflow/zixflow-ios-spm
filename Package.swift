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
        .library(name: "Location", targets: ["Location"]),
        .library(name: "MessagingInbox", targets: ["MessagingInbox"]),
        // Jist (Visual Inbox renderer) — also published here by zixflow/jist's ios/release.sh.
        .library(name: "Jist", targets: ["Jist"])
    ],
    targets: [
        // Wrapper targets (with dependencies)
        .target(
            name: "DataPipelines",
            dependencies: [
                "ZixflowDataPipelines",
                "ZixflowInternalCommon",
                "ZixflowTrackingMigration",
                "ZixflowAnalytics",
                "JSONSafeEncoding",
                "Sovran",
                "LDSwiftEventSource"
            ],
            path: "Sources/DataPipelines"
        ),
        .target(
            name: "MessagingPushAPN",
            dependencies: [
                "ZixflowMessagingPushAPN",
                "ZixflowMessagingPush",
                "ZixflowInternalCommon"
            ],
            path: "Sources/MessagingPushAPN"
        ),
        .target(
            name: "MessagingPushFCM",
            dependencies: [
                "ZixflowMessagingPushFCM",
                "ZixflowMessagingPush",
                "ZixflowInternalCommon"
            ],
            path: "Sources/MessagingPushFCM"
        ),
        .target(
            name: "MessagingInApp",
            dependencies: [
                "ZixflowMessagingInApp",
                "ZixflowInternalCommon",
                "ZixflowAnalytics"
            ],
            path: "Sources/MessagingInApp"
        ),
        .target(
            name: "Location",
            dependencies: [
                "ZixflowLocation",
                "ZixflowInternalCommon"
            ],
            path: "Sources/Location"
        ),
        .target(
            name: "MessagingInbox",
            dependencies: [
                "ZixflowMessagingInbox",
                "ZixflowMessagingInApp",
                "ZixflowInternalCommon",
                "ZixflowAnalytics",
                "Jist"
            ],
            path: "Sources/MessagingInbox",
            // The prebuilt ZixflowMessagingInbox (built with ZIXFLOW_BINARY_DISTRIBUTION) looks these
            // up in this target's bundle, "Zixflow_MessagingInbox.bundle".
            resources: [
                .process("Resources/ZixflowInboxAssets.xcassets"),
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        ),

        // Binary XCFrameworks
        .binaryTarget(name: "ZixflowDataPipelines", path: "ZixflowDataPipelines.xcframework"),
        .binaryTarget(name: "ZixflowMessagingPushAPN", path: "ZixflowMessagingPushAPN.xcframework"),
        .binaryTarget(name: "ZixflowMessagingPushFCM", path: "ZixflowMessagingPushFCM.xcframework"),
        .binaryTarget(name: "ZixflowMessagingInApp", path: "ZixflowMessagingInApp.xcframework"),
        .binaryTarget(name: "ZixflowLocation", path: "ZixflowLocation.xcframework"),
        .binaryTarget(name: "ZixflowInternalCommon", path: "ZixflowInternalCommon.xcframework"),
        .binaryTarget(name: "ZixflowTrackingMigration", path: "ZixflowTrackingMigration.xcframework"),
        .binaryTarget(name: "ZixflowAnalytics", path: "ZixflowAnalytics.xcframework"),
        .binaryTarget(name: "ZixflowMessagingPush", path: "ZixflowMessagingPush.xcframework"),
        .binaryTarget(name: "LDSwiftEventSource", path: "LDSwiftEventSource.xcframework"),
        .binaryTarget(name: "Sovran", path: "Sovran.xcframework"),
        .binaryTarget(name: "JSONSafeEncoding", path: "JSONSafeEncoding.xcframework"),
        .binaryTarget(name: "ZixflowMessagingInbox", path: "ZixflowMessagingInbox.xcframework"),
        .binaryTarget(name: "Jist", path: "Jist.xcframework")
    ]
)
