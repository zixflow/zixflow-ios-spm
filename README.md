# Zixflow iOS SDK

Complete guide for integrating the Zixflow iOS SDK into your application.

## Table of Contents

1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Installation](#installation)
   - [Swift Package Manager (Recommended)](#swift-package-manager-recommended)
4. [Quick Start](#quick-start)
   - [UIKit Apps](#uikit-apps)
   - [SwiftUI Apps](#swiftui-apps)
5. [Core Features](#core-features)
6. [Push Notifications](#push-notifications)
7. [Location Tracking](#location-tracking)
8. [Advanced Configuration](#advanced-configuration)
9. [Platform-Specific Guides](#platform-specific-guides)
10. [Example Apps](#example-apps)
11. [API Reference](#api-reference)

---

## Introduction

The Zixflow iOS SDK enables you to send data from your iOS app to Zixflow, allowing you to track user behavior, send targeted push notifications, and more.

### SDK Modules

The SDK is organized into independent modules:

- **DataPipelines** (required): Core tracking, user identification, and event tracking
- **MessagingPushAPN**: Apple Push Notification (APNs) support
- **MessagingPushFCM**: Firebase Cloud Messaging (FCM) support
- **Location**: Location tracking capabilities

---

## Requirements

- **iOS**: 13.0 or higher
- **Swift**: 5.3 or higher
- **Xcode**: 13.0 or higher

---

## Installation

### Swift Package Manager (Recommended)

SPM is the recommended installation method for most projects.

#### Option 1: Xcode GUI

1. Open your project in Xcode
2. Navigate to **File** → **Add Package Dependencies...**
3. Enter the repository URL:
   ```
   https://github.com/zixflow/zixflow-ios-spm.git
   ```
4. Select version rule: **Up to Next Major** from `1.0.0`
5. Choose the modules you need:
   - `DataPipelines` (required)
   - `MessagingPushAPN` (for Apple push notifications)
   - `MessagingPushFCM` (for Firebase push notifications)
   - `Location` (for location tracking)
6. Click **Add Package**

#### Option 2: Package.swift

Add the SDK to your `Package.swift` file:

```swift
let package = Package(
    name: "YourApp",
    dependencies: [
        .package(
            url: "https://github.com/zixflow/zixflow-ios-spm.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "DataPipelines", package: "zixflow-ios-spm"),
                .product(name: "MessagingPushAPN", package: "zixflow-ios-spm")
            ]
        )
    ]
)
```

#### Import Modules

```swift
import ZixflowDataPipelines
import ZixflowMessagingPushAPN
import ZixflowLocation
```

---


## Quick Start

### UIKit Apps

For UIKit-based applications with AppDelegate:

#### 1. Initialize in AppDelegate

```swift
import UIKit
import ZixflowDataPipelines
import ZixflowMessagingPushAPN

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Zixflow SDK
        initializeZixflow()
        return true
    }

    func initializeZixflow() {
        // Configure the SDK
        let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")

            .autoTrackDeviceAttributes(true)          // Auto-track device info
            .trackApplicationLifecycleEvents(true)    // Track app lifecycle
            .logLevel(.debug)                         // Set log level
            .build()

        // Initialize core SDK
        Zixflow.initialize(withConfig: config)

        // Initialize push notifications (optional)
        MessagingPushAPN.initialize(
            withConfig: MessagingPushConfigBuilder()
                .autoFetchDeviceToken(true)
                .autoTrackPushEvents(true)
                .showPushAppInForeground(true)
                .build()
        )
    }
}
```

#### 2. Replace Configuration Values

- **YOUR_API_KEY**: Your Zixflow API key (from Zixflow dashboard)

---

### SwiftUI Apps

For SwiftUI applications with `@main` App struct:

#### 1. Create AppDelegate Class

```swift
import UIKit
import ZixflowDataPipelines
import ZixflowMessagingPushAPN

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Configure the SDK
        let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")

            .autoTrackDeviceAttributes(true)
            .trackApplicationLifecycleEvents(true)
            .logLevel(.debug)
            .build()

        Zixflow.initialize(withConfig: config)

        // Initialize messaging features
        MessagingPushAPN.initialize(
            withConfig: MessagingPushConfigBuilder()
                .autoFetchDeviceToken(true)
                .autoTrackPushEvents(true)
                .showPushAppInForeground(true)
                .build()
        )

        return true
    }
}
```

#### 2. Connect AppDelegate to SwiftUI App

```swift
import SwiftUI

@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

## Core Features

### User Identification

Identify users to track their activity:

```swift
import ZixflowDataPipelines

// Identify user with ID only
Zixflow.shared.identify(userId: "user@example.com")

// Identify user with additional attributes
Zixflow.shared.identify(
    userId: "user@example.com",
    traits: [
        "first_name": "John",
        "last_name": "Doe",
        "email": "user@example.com",
        "plan": "premium"
    ]
)
```

### Event Tracking

Track custom events:

```swift
// Simple event
Zixflow.shared.track(name: "Button Clicked")

// Event with properties
Zixflow.shared.track(
    name: "Product Purchased",
    properties: [
        "product_id": "123",
        "product_name": "Widget",
        "price": 29.99,
        "currency": "USD"
    ]
)

// Event with timestamp
Zixflow.shared.track(
    name: "Order Completed",
    properties: ["order_id": "ABC123"],
    timestamp: Date()
)
```

### Screen Tracking

Track screen views:

```swift
// Manual screen tracking
Zixflow.shared.screen(
    title: "Product Detail",
    properties: [
        "product_id": "123",
        "category": "Electronics"
    ]
)

// Enable automatic UIKit screen tracking (in configuration)
let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
    .autoTrackUIKitScreenViews()
    .build()
```

### Profile Attributes

Set user profile attributes:

```swift
// Set profile attributes
Zixflow.shared.setProfileAttributes([
    "age": 30,
    "gender": "male",
    "subscription_status": "active"
])
```

### Device Attributes

Set device attributes:

```swift
// Set device-specific attributes
Zixflow.shared.deviceAttributes = [
    "app_version": "2.1.0",
    "device_model": "iPhone 14 Pro",
    "os_version": "iOS 16.4"
]
```

### User Logout

Clear user identification when they log out:

```swift
// Clear identified user
Zixflow.shared.clearIdentify()
```

### Get Device Token

Retrieve the registered push notification device token:

```swift
if let deviceToken = Zixflow.shared.registeredDeviceToken {
    print("Device token: \(deviceToken)")
} else {
    print("Device token not yet registered")
}
```

---

## Push Notifications

Complete guide to implementing push notifications with Zixflow using Apple Push Notifications (APNs) or Firebase Cloud Messaging (FCM).

### Prerequisites

Before implementing push notifications:

1. **Add push service credentials to Zixflow dashboard** - Configure your APNs certificates or FCM server key in the Zixflow dashboard first
2. **Enable Push Notifications capability** in Xcode (see setup steps below)
3. **Install the appropriate push module**:
   - `ZixflowMessagingPushAPN` for Apple Push Notifications
   - `ZixflowMessagingPushFCM` for Firebase Cloud Messaging

---

### Apple Push Notifications (APNs)

Recommended for most iOS apps. Provides native iOS push notification support.

#### Step 1: Enable Push Notifications in Xcode

1. Select your project in Xcode
2. Go to **Target** → **Signing & Capabilities**
3. Click **+ Capability** → Add **Push Notifications**
4. Click **+ Capability** → Add **Background Modes**
5. Enable **Remote notifications** under Background Modes

#### Step 2: Initialize Zixflow Core SDK

Initialize the core Data Pipelines SDK first in your `AppDelegate`:

```swift
import UIKit
import ZixflowDataPipelines

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Zixflow SDK
        let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")

            .autoTrackDeviceAttributes(true)
            .trackApplicationLifecycleEvents(true)
            .logLevel(.debug)
            .build()

        Zixflow.initialize(withConfig: config)

        // Initialize push messaging (see Step 3)

        return true
    }
}
```

#### Step 3: Initialize MessagingPushAPN

Add push notification support after initializing the core SDK:

```swift
import ZixflowMessagingPushAPN

// In application(didFinishLaunchingWithOptions:)
MessagingPushAPN.initialize(
    withConfig: MessagingPushConfigBuilder()
        .autoFetchDeviceToken(true)        // Auto-request device token
        .autoTrackPushEvents(true)         // Auto-track delivered/opened metrics
        .showPushAppInForeground(true)     // Show notifications when app is active
        .build()
)
```

##### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `autoFetchDeviceToken` | Bool | `true` | Automatically retrieve and register device token |
| `autoTrackPushEvents` | Bool | `true` | Track `delivered` and `opened` metrics automatically |
| `showPushAppInForeground` | Bool | `true` | Display push notifications while app is in foreground |
| `appGroupId` | String? | `nil` | Custom App Group ID for delivery tracking (see Rich Push section) |

#### Step 4: Use ZixflowAppDelegateWrapper (Recommended)

For automatic push notification handling, use `ZixflowAppDelegateWrapper`:

```swift
import UIKit
import ZixflowDataPipelines
import ZixflowMessagingPushAPN

// Replace @main declaration
@main
class AppDelegateWithZixflowIntegration: ZixflowAppDelegateWrapper<AppDelegate> {}

// Your AppDelegate class (no @main attribute)
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Zixflow SDK
        let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
            
            .build()
        Zixflow.initialize(withConfig: config)

        // Initialize push notifications
        MessagingPushAPN.initialize(
            withConfig: MessagingPushConfigBuilder()
                .autoFetchDeviceToken(true)
                .autoTrackPushEvents(true)
                .showPushAppInForeground(true)
                .build()
        )

        return true
    }
}
```

**Benefits of `ZixflowAppDelegateWrapper`:**
- Automatically registers device tokens with Zixflow
- Handles push notification clicks
- Tracks push metrics (`delivered`, `opened`)
- No additional code required for basic push handling

#### Step 5: Identify Users

**Critical**: Device tokens must be associated with a user before push notifications can be delivered.

```swift
// Identify user when they log in
Zixflow.shared.identify(
    userId: "user@example.com",
    traits: [
        "email": "user@example.com",
        "first_name": "John",
        "last_name": "Doe"
    ]
)
```

**Important Notes:**
- Device tokens link to user profiles when you call `identify()`
- This ensures notifications are delivered to the correct user
- Always call `identify()` after user authentication

#### Step 6: Rich Push with Notification Service Extension

Add support for rich media (images, videos, GIFs) and reliable delivery tracking.

##### 1. Create Notification Service Extension

1. In Xcode: **File** → **New** → **Target**
2. Select **Notification Service Extension**
3. Name it (e.g., "NotificationServiceExtension")
4. Click **Finish** (activate scheme when prompted)

##### 2. Add SDK to Extension Target

**Swift Package Manager:**
1. Select your project
2. Go to the Notification Service Extension target
3. **General** → **Frameworks and Libraries**
4. Click **+** → Add `ZixflowMessagingPushAPN`

**CocoaPods:** Update your `Podfile`:
```ruby
target 'NotificationServiceExtension' do
  use_frameworks!
  pod 'ZixflowMessagingPushAPN', '~> 1.0'
end
```

Then run:
```bash
pod install
```

##### 3. Configure Notification Service Extension

Replace `NotificationService.swift` content:

```swift
import UserNotifications
import ZixflowMessagingPushAPN

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        // Initialize the SDK for the extension
        MessagingPushAPN.initializeForExtension(
            withConfig: MessagingPushConfigBuilder(apiKey: "YOUR_API_KEY")

                .logLevel(.debug)
                .build()
        )

        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // Let Zixflow SDK handle rich push and track delivery
            MessagingPushAPN.shared.didReceive(
                request,
                withContentHandler: contentHandler
            )
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called when extension is about to be terminated
        MessagingPushAPN.shared.serviceExtensionTimeWillExpire()

        if let contentHandler = contentHandler,
           let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
```

##### 4. Setup App Groups (Recommended)

App Groups enable delivery tracking data sharing between your main app and notification extension.

**Create App Group:**
1. Select your **main app target** → **Signing & Capabilities**
2. Click **+ Capability** → **App Groups**
3. Click **+** to add a new group with format: `group.{bundleId}.zixflow`
   - Example: `group.com.yourcompany.app.zixflow`
4. Repeat for your **Notification Service Extension target**

**Configure in Code:**

```swift
// In your main app's AppDelegate
MessagingPushAPN.initialize(
    withConfig: MessagingPushConfigBuilder()
        .autoFetchDeviceToken(true)
        .autoTrackPushEvents(true)
        .showPushAppInForeground(true)
        .appGroupId("group.com.yourcompany.app.zixflow")  // Your App Group ID
        .build()
)
```

**Note:** If you don't specify `appGroupId`, the SDK will automatically infer it from your bundle ID using the pattern `group.{bundleId}.zixflow`. Only set this if using a custom App Group name.

---

### Firebase Cloud Messaging (FCM)

Use FCM if you need cross-platform push support or already use Firebase services.

#### Step 1: Setup Firebase Project

1. Go to https://console.firebase.google.com
2. Create a new project or select existing project
3. Add your iOS app to the Firebase project
4. Download `GoogleService-Info.plist`
5. Add `GoogleService-Info.plist` to your Xcode project root

#### Step 2: Install Firebase SDK

**CocoaPods** (recommended for FCM):

```ruby
# Podfile
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  # Zixflow SDK
  pod 'ZixflowDataPipelines', '~> 1.0'
  pod 'ZixflowMessagingPushFCM', '~> 1.0'

  # Firebase
  pod 'FirebaseMessaging', '~> 10.0'
end
```

Install dependencies:
```bash
pod install
```

**Swift Package Manager:**

Add both Zixflow and Firebase packages to your project.

#### Step 3: Enable Push Capabilities

Follow the same Xcode capabilities setup as APNs (Step 1 of APNs section).

#### Step 4: Initialize Firebase and Zixflow

```swift
import UIKit
import FirebaseCore
import ZixflowDataPipelines
import ZixflowMessagingPushFCM

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Firebase first (before Zixflow)
        FirebaseApp.configure()

        // Initialize Zixflow SDK
        let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
            
            .autoTrackDeviceAttributes(true)
            .trackApplicationLifecycleEvents(true)
            .logLevel(.debug)
            .build()
        Zixflow.initialize(withConfig: config)

        // Initialize FCM messaging
        MessagingPushFCM.initialize(
            withConfig: MessagingPushConfigBuilder()
                .autoFetchDeviceToken(true)
                .autoTrackPushEvents(true)
                .showPushAppInForeground(true)
                .build()
        )

        return true
    }
}
```

#### Step 5: Identify Users

Same as APNs - identify users to associate device tokens:

```swift
Zixflow.shared.identify(
    userId: "user@example.com",
    traits: ["email": "user@example.com", "name": "John Doe"]
)
```

#### Step 6: Rich Push with FCM

Follow the same Notification Service Extension setup as APNs, but import FCM module:

```swift
import UserNotifications
import ZixflowMessagingPushFCM

class NotificationService: UNNotificationServiceExtension {
    // ... (same structure as APNs)

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        // Initialize for FCM
        MessagingPushFCM.initializeForExtension(
            withConfig: MessagingPushConfigBuilder(apiKey: "YOUR_API_KEY")
                
                .logLevel(.debug)
                .build()
        )

        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            MessagingPushFCM.shared.didReceive(request, withContentHandler: contentHandler)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        MessagingPushFCM.shared.serviceExtensionTimeWillExpire()
        // ... rest of implementation
    }
}
```

---

### Advanced Push Notification Features

#### Deep Links and Universal Links

Every Zixflow push notification may carry a `deeplink_url` at the top level and per-button deeplinks in `action_buttons`.

**Priority order for navigation:**
1. If an action button was tapped → use `action_buttons[index].deeplink`
2. If body was tapped → use `deeplink_url`
3. If neither is set → open app to default screen

**Handle deep links in notification response:**

```swift
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    let userInfo = response.notification.request.content.userInfo
    var deeplink: String?

    // Check if action button was tapped
    if response.actionIdentifier != UNNotificationDefaultActionIdentifier &&
       response.actionIdentifier != UNNotificationDismissActionIdentifier {
        let actionIndex = Int(response.actionIdentifier
            .replacingOccurrences(of: "ACTION_", with: "")) ?? -1
        let buttons = parseActionButtons(userInfo["action_buttons"])
        if actionIndex >= 0 && actionIndex < buttons.count {
            deeplink = buttons[actionIndex]["deeplink"] as? String
        }
    }

    // Fall back to main deeplink if no button deeplink
    if deeplink == nil || deeplink?.isEmpty == true {
        deeplink = userInfo["deeplink_url"] as? String
    }

    // Navigate to deeplink
    if let url = deeplink, !url.isEmpty {
        navigateTo(url)
    }

    completionHandler()
}

// Helper to navigate to deeplink
func navigateTo(_ urlString: String) {
    guard let url = URL(string: urlString) else { return }

    // Handle your app's custom URL scheme or universal links
    if url.host == "yourapp.com" {
        switch url.path {
        case "/sale":
            // Navigate to sale screen
            break
        case "/dashboard":
            // Navigate to dashboard
            break
        default:
            // Navigate to home
            break
        }
    } else {
        // External URL - open in Safari
        UIApplication.shared.open(url)
    }
}
```

**Or configure a deep link callback in SDK configuration:**

```swift
let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
    .deepLinkCallback { url in
        print("Deep link: \(url)")
        // Handle navigation
        if url.path == "/product" {
            // Navigate to product screen
            return true  // Return true if handled
        }
        return false  // Return false to open in browser
    }
    .build()
```

#### Push Notification Tracking

Zixflow automatically tracks push notification lifecycle events when using `ZixflowAppDelegateWrapper`. If you need custom tracking or are not using the wrapper, implement tracking manually.

##### Understanding Push Tracking Events

Zixflow tracks three key push notification events:

1. **Delivered** - When the notification arrives on the device
2. **Opened** - When the user taps the notification
3. **Action Clicked** - When the user taps an action button

##### The Push Payload

Zixflow injects special fields into every push notification's `userInfo`:

| Field | Purpose |
|-------|---------|
| `Zixflow-Delivery-ID` | Unique ID linking to the campaign delivery |
| `Zixflow-Delivery-Token` | The APNs token the notification was sent to |

Example payload:
```swift
[
  "Zixflow-Delivery-ID": "626533406292836846",
  "Zixflow-Delivery-Token": "dcFRlDhiRbehM1vg...",
  "title": "Flash Sale! 70% OFF",
  "body": "Limited time only — grab your deal now!",
  "deeplink_url": "https://yourapp.com/sale",
  "action_buttons": "[{\"name\":\"Shop Now\",\"deeplink\":\"https://yourapp.com/sale\"}]"
]
```

##### Manual Tracking Implementation

If not using `ZixflowAppDelegateWrapper`, implement `UNUserNotificationCenterDelegate`:

**1. Track Delivery (Foreground)**

```swift
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo      = notification.request.content.userInfo
        let deliveryId    = userInfo["Zixflow-Delivery-ID"] as? String ?? ""
        let deliveryToken = userInfo["Zixflow-Delivery-Token"] as? String ?? ""

        if !deliveryId.isEmpty && !deliveryToken.isEmpty {
            MessagingPushAPN.shared.trackMetric(
                deliveryID:  deliveryId,
                event:       .delivered,
                deviceToken: deliveryToken
            )
        }

        completionHandler([.banner, .sound, .badge])
    }
}
```

**2. Track Opened & Action Clicks**

```swift
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    let userInfo      = response.notification.request.content.userInfo
    let deliveryId    = userInfo["Zixflow-Delivery-ID"] as? String ?? ""
    let deliveryToken = userInfo["Zixflow-Delivery-Token"] as? String ?? ""

    // Always track opened first
    if !deliveryId.isEmpty && !deliveryToken.isEmpty {
        MessagingPushAPN.shared.trackMetric(
            deliveryID:  deliveryId,
            event:       .opened,
            deviceToken: deliveryToken
        )
    }

    // Track action button clicks
    if response.actionIdentifier != UNNotificationDefaultActionIdentifier &&
       response.actionIdentifier != UNNotificationDismissActionIdentifier {

        let actionIndex = Int(response.actionIdentifier
            .replacingOccurrences(of: "ACTION_", with: "")) ?? -1
        let buttons = parseActionButtons(userInfo["action_buttons"])
        let actionName = (actionIndex >= 0 && actionIndex < buttons.count)
            ? buttons[actionIndex]["name"] as? String ?? "Action \(actionIndex + 1)"
            : "Action \(actionIndex + 1)"
        let deeplink = (actionIndex >= 0 && actionIndex < buttons.count)
            ? buttons[actionIndex]["deeplink"] as? String ?? ""
            : ""

        Zixflow.shared.track(
            name: "Push Notification Action Clicked",
            properties: [
                "Zixflow-Delivery-ID":    deliveryId,
                "Zixflow-Delivery-Token": deliveryToken,
                "action_index":           actionIndex,
                "action_name":            actionName,
                "action_deeplink":        deeplink
            ]
        )

        // Navigate to deeplink if provided
        if !deeplink.isEmpty {
            navigateTo(deeplink)
        }
    }

    // Handle main deeplink
    if let deeplink = userInfo["deeplink_url"] as? String, !deeplink.isEmpty {
        navigateTo(deeplink)
    }

    completionHandler()
}

// Helper to parse action buttons JSON
func parseActionButtons(_ raw: Any?) -> [[String: Any]] {
    guard let jsonString = raw as? String,
          let data = jsonString.data(using: .utf8),
          let buttons = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
        return []
    }
    return buttons
}
```

**3. Register Delegate**

```swift
// In didFinishLaunchingWithOptions
UNUserNotificationCenter.current().delegate = self
```

**Note:** When using `ZixflowAppDelegateWrapper`, the SDK handles all tracking automatically. Only implement manual tracking if you need custom behavior or are not using the wrapper.

##### Decision Flowchart

Use this when deciding which SDK call to make for any notification interaction:

```
Notification received?
├── YES → trackMetric(.delivered)      [always, as soon as payload arrives]
│
User interacted?
├── Tapped notification body
│   └── trackMetric(.opened)           [with deliveryID + deviceToken]
│       └── Navigate to deeplink_url
│
└── Tapped action button
    ├── trackMetric(.opened)           [still track opened first]
    └── track("Push Notification Action Clicked")  [with action_index + action_name]
        └── Navigate to button's deeplink
```

**Key Points:**
- Always track `.delivered` when the notification arrives
- Always track `.opened` before tracking action clicks
- Action button taps fire both `.opened` and the action clicked event
- Use the `Zixflow-Delivery-ID` and `Zixflow-Delivery-Token` from the payload for all tracking calls

#### Manual Device Token Registration

If you disable `autoFetchDeviceToken`, register manually:

```swift
// In AppDelegate
func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
    // Register token with Zixflow
    MessagingPushAPN.shared.registerDeviceToken(apnDeviceToken: deviceToken)
}

func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
) {
    print("Failed to register for remote notifications: \(error)")
    MessagingPushAPN.shared.deleteDeviceToken()
}
```

#### Action Buttons

Action buttons allow users to interact with notifications without opening the app. The `action_buttons` field in the push payload is a JSON-encoded string.

**Payload format:**
```
"[{\"name\":\"Shop Now\",\"deeplink\":\"https://yourapp.com/sale\"},{\"name\":\"Remind Me\",\"deeplink\":\"\"}]"
```

**Parsed structure:**
```json
[
  { "name": "Shop Now",  "deeplink": "https://yourapp.com/sale" },
  { "name": "Remind Me", "deeplink": "" }
]
```

**iOS Requirements:**

iOS requires action buttons to be pre-registered at app launch:

```swift
// In AppDelegate.didFinishLaunchingWithOptions
let actions = [
    UNNotificationAction(identifier: "ACTION_0", title: "Action 1", options: .foreground),
    UNNotificationAction(identifier: "ACTION_1", title: "Action 2", options: .foreground),
]
let category = UNNotificationCategory(
    identifier: "ZX_2BTN",
    actions: actions,
    intentIdentifiers: [],
    options: []
)
UNUserNotificationCenter.current().setNotificationCategories([category])
```

**Rules:**
- Maximum **2 buttons** per notification (iOS system limit)
- Button index is **0-based** (leftmost = index 0)
- `deeplink` may be empty — handle gracefully
- Button labels in pre-registration can be generic ("Action 1", "Action 2")
- The actual button names from the payload are tracked in analytics via `action_name`

#### Remove Device Token

When user logs out or disables notifications:

```swift
// Delete device token from Zixflow
MessagingPushAPN.shared.deleteDeviceToken()

// Also clear user identity
Zixflow.shared.clearIdentify()
```

---

### Testing Push Notifications

#### 1. Verify Device Token Registration

Check if device token is registered:

```swift
if let deviceToken = Zixflow.shared.registeredDeviceToken {
    print("Device token registered: \(deviceToken)")
} else {
    print("Device token not yet registered")
}
```

#### 2. Enable Debug Logging

Use debug logging to troubleshoot:

```swift
let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
    .logLevel(.debug)  // Enable verbose logging
    .build()
```

#### 3. Test on Physical Device

**Important:** Push notifications require a physical iOS device. The iOS Simulator cannot receive push notifications.

#### 4. Send Test Push from Zixflow

1. Log into Zixflow dashboard
2. Navigate to **Messaging** → **Push Notifications**
3. Create a test push notification
4. Send to a specific user (using `userId` from `identify()`)

---

### Best Practices

1. **Always identify users** before sending push notifications
2. **Use Notification Service Extension** for rich push and reliable delivery tracking
3. **Configure App Groups** for delivery metric persistence
4. **Handle permission requests gracefully** - explain value to users
5. **Test thoroughly** on physical devices across iOS versions
6. **Enable debug logging** during development
7. **Handle deep links** to provide seamless user experience
8. **Monitor metrics** in Zixflow dashboard to track engagement

---

## Location Tracking

Track user location to enable location-based messaging.

### 1. Add Location Permissions to Info.plist

Add these keys to your `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We use your location to send relevant notifications</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We use your location to send relevant notifications</string>
```

### 2. Initialize Location Module

```swift
import ZixflowLocation

let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
    .addModule(LocationModule(
        config: LocationConfig(mode: .onAppStart)
    ))
    .build()

Zixflow.initialize(withConfig: config)
```

### 3. Location Update Modes

- **`.onAppStart`**: Request location once when app starts
- **`.onDemand`**: Request location manually when needed

### 4. Manual Location Update

```swift
// Request location update manually
Zixflow.location.requestLocationUpdate()

// Set last known location
if let location = locationManager.location {
    Zixflow.location.setLastKnownLocation(location)
}
```

---

## Advanced Configuration

### Configuration Options

```swift
let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")

    // Logging: Set log level for debugging
    .logLevel(.debug)  // .error, .info, .debug

    // Auto-tracking: Automatically track device info
    .autoTrackDeviceAttributes(true)

    // Lifecycle events: Track app open, close, etc.
    .trackApplicationLifecycleEvents(true)

    // Screen tracking: Auto-track UIKit screen views
    .autoTrackUIKitScreenViews()

    // Screen view configuration
    .screenViewUse(screenView: .InApp)  // or .all

    // Custom endpoints (advanced)
    .apiHost("dev-events.zixflow.in")
    .cdnHost("custom-cdn.example.com")

    // Event batching
    .flushAt(20)          // Send events after 20 tracked
    .flushInterval(30)    // Or every 30 seconds

    // Deep linking callback
    .deepLinkCallback { url in
        print("Deep link received: \(url)")
        // Handle deep link navigation
        return true  // Return true if handled
    }

    // Location tracking
    .addModule(LocationModule(
        config: LocationConfig(mode: .onAppStart)
    ))

    .build()
```


### Log Levels

Control SDK logging verbosity:

```swift
.logLevel(.error)  // Errors only
.logLevel(.info)   // Errors + informational messages
.logLevel(.debug)  // All messages (use in development)
```

### Deep Link Handling

Handle universal links from push notifications:

```swift
let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
    .deepLinkCallback { url in
        // Parse and handle the deep link
        if url.path == "/product" {
            // Navigate to product screen
            return true
        }
        return false  // Return false to open in browser
    }
    .build()
```


---

## Platform-Specific Guides

### UIKit vs SwiftUI

#### UIKit Initialization

Use `AppDelegate` for UIKit apps:

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize SDK here
        Zixflow.initialize(withConfig: config)
        return true
    }
}
```

#### SwiftUI Initialization

Use `@UIApplicationDelegateAdaptor` for SwiftUI apps:

```swift
@main
struct YourApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

#### Screen Tracking Differences

- **UIKit**: Enable automatic screen tracking with `.autoTrackUIKitScreenViews()`
- **SwiftUI**: Manual screen tracking recommended:

```swift
// In SwiftUI views
.onAppear {
    Zixflow.shared.screen(title: "Home Screen")
}
```

---

### visionOS Support

The SDK supports visionOS with limited features.

#### Supported Features

- Core DataPipelines (user identification, event tracking)
- Apple Push Notifications (APNs)
- Location tracking

#### Unsupported Features

- Firebase Cloud Messaging (FCM)

#### visionOS Setup

```swift
import ZixflowDataPipelines

let config = SDKConfigBuilder(apiKey: "YOUR_API_KEY")
    .logLevel(.debug)
    .build()

Zixflow.initialize(withConfig: config)
```

---

## Example Apps

The SDK includes complete example applications:

### APN-UIKit Sample (SPM + UIKit)
**Location**: `/Apps/APN-UIKit/`

Demonstrates:
- Swift Package Manager installation
- UIKit integration
- Apple Push Notifications
- Location tracking
- Event tracking
- User identification

### CocoaPods-FCM Sample (CocoaPods + SwiftUI)
**Location**: `/Apps/CocoaPods-FCM/`

Demonstrates:
- CocoaPods installation
- SwiftUI integration
- Firebase Cloud Messaging
- Rich push notifications
- Settings configuration UI

### VisionOS Sample
**Location**: `/Apps/VisionOS/`

Demonstrates:
- visionOS compatibility
- Limited feature set
- APNs integration

### Running Example Apps

```bash
# Setup sample app
make setup_sample_app app=APN-UIKit
# or
make setup_sample_app app=CocoaPods-FCM
```

---

## API Reference

### Zixflow Core

```swift
// Initialize SDK
Zixflow.initialize(withConfig: SDKConfig)

// Identify user
Zixflow.shared.identify(userId: String, traits: [String: Any]?)

// Track event
Zixflow.shared.track(name: String, properties: [String: Any]?)

// Track screen
Zixflow.shared.screen(title: String, properties: [String: Any]?)

// Set profile attributes
Zixflow.shared.setProfileAttributes([String: Any])

// Set device attributes
Zixflow.shared.deviceAttributes = [String: Any]

// Clear user identification
Zixflow.shared.clearIdentify()

// Get device token
Zixflow.shared.registeredDeviceToken: String?
```

### SDKConfigBuilder

```swift
SDKConfigBuilder(apiKey: String)
    
    .logLevel(ZixflowLogLevel)
    .autoTrackDeviceAttributes(Bool)
    .trackApplicationLifecycleEvents(Bool)
    .autoTrackUIKitScreenViews()
    .screenViewUse(screenView: ScreenView)
    .apiHost(String)
    .cdnHost(String)
    .flushAt(Int)
    .flushInterval(Double)
    .deepLinkCallback((URL) -> Bool)
    .addModule(Module)
    .build() -> SDKConfig
```

### MessagingPushAPN

```swift
// Initialize
MessagingPushAPN.initialize(withConfig: MessagingPushConfig)

// Configuration
MessagingPushConfigBuilder()
    .autoFetchDeviceToken(Bool)
    .autoTrackPushEvents(Bool)
    .showPushAppInForeground(Bool)
    .appGroupId(String?)
    .build() -> MessagingPushConfig
```

### Location

```swift
// Configuration
LocationModule(config: LocationConfig)
LocationConfig(mode: LocationMode)

enum LocationMode {
    case onAppStart  // Request location on app launch
    case onDemand    // Request location manually
}

// Manual location update
Zixflow.location.requestLocationUpdate()
Zixflow.location.setLastKnownLocation(CLLocation)
```

