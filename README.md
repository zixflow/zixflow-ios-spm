# Zixflow iOS SDK - SPM Distribution

This repository contains the pre-built XCFrameworks for the Zixflow iOS SDK, distributed via Swift Package Manager.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/zixflow/zixflow-ios-spm.git", from: "1.3.0")
]
```

Then add the specific modules you need:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "DataPipelines", package: "zixflow-ios-spm"),
        .product(name: "MessagingPushAPN", package: "zixflow-ios-spm"),
        // Add other modules as needed
    ]
)
```

Or add it directly in Xcode:
1. Go to File > Add Package Dependencies
2. Enter the repository URL: `https://github.com/zixflow/zixflow-ios-spm.git`
3. Select the version: `1.3.0`
4. Choose the modules you want to add to your target

## Available Modules

- **DataPipelines** - Customer identification and event tracking
- **MessagingPushAPN** - Apple Push Notification support
- **MessagingPushFCM** - Firebase Cloud Messaging support
- **MessagingInApp** - In-app messaging functionality
- **Location** - Location tracking functionality
- **MessagingInbox** - Visual Notification Inbox (renders with Jist)
- **Jist** - Jist renderer (installed automatically with MessagingInbox)

## Usage

Import the modules you need:

```swift
import ZixflowDataPipelines
import ZixflowMessagingPushAPN
import ZixflowLocation
```

## Current Version

**Latest Release:** `1.3.0`

## Documentation

For full documentation, example apps, and usage guides, please visit the [main repository](https://github.com/zixflow/zixflow-ios).

## License

See the [main repository](https://github.com/zixflow/zixflow-ios) for license information.
