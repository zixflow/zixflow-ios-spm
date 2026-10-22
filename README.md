# Zixflow iOS SDK

Prebuilt XCFrameworks for the Zixflow iOS SDK, distributed with Swift Package Manager and CocoaPods.

**Latest release:** `1.5.0`

## Swift Package Manager

In Xcode: File > Add Package Dependencies, enter `https://github.com/zixflow/zixflow-ios-spm.git`, choose version `1.5.0`,
then add the products you need. Or in `Package.swift`:

```swift
.package(url: "https://github.com/zixflow/zixflow-ios-spm.git", from: "1.5.0")
```

| Product | Import |
| --- | --- |
| `DataPipelines` | `import ZixflowDataPipelines` |
| `MessagingPushAPN` | `import ZixflowMessagingPushAPN` |
| `MessagingPushFCM` | `import ZixflowMessagingPushFCM` |
| `MessagingInApp` | `import ZixflowMessagingInApp` |
| `MessagingInbox` | `import ZixflowMessagingInbox` |
| `Location` | `import ZixflowLocation` |
| `ZixflowAnalytics` | `import ZixflowAnalytics` (analytics client on its own) |
| `Jist` | `import Jist` (installed with MessagingInbox) |

## CocoaPods

```ruby
pod 'Zixflow/DataPipelines', '1.5.0'
pod 'Zixflow/MessagingPushAPN', '1.5.0'
# also: Zixflow/MessagingPushFCM, Zixflow/MessagingInApp, Zixflow/MessagingInbox, Zixflow/Location
```

Each `Zixflow/<Module>` subspec installs the `Zixflow<Module>` binary pod, which downloads its
XCFramework from this repository's `1.5.0` tag.

## Requirements

iOS 13+, Xcode 16+.

## License

MIT — see [LICENSE](LICENSE).
