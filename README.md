# DeviceInfo
[![Latest release](http://img.shields.io/github/release/benjaminsnorris/DeviceInfo.svg)](https://github.com/benjaminsnorris/DeviceInfo/releases)
[![GitHub license](https://img.shields.io/github/license/benjaminsnorris/DeviceInfo.svg)](/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)](https://swift.org/package-manager)

A simple library providing device information for iOS apps. Includes services for device info, version info, and launch count info.

1. [Requirements](#requirements)
2. [Usage](#usage)
  - [Launch count information](#launch-count-information)
  - [Device information](#device-information)
3. [Integration](#integration)
  - [Carthage](#carthage)
  - [Swift Package Manager](#swift-package-manager)
  - [Git Submodules](#git-submodules)


## Requirements
- iOS 9.0+
- Xcode 7


## Usage
Import the module into any file where you need to display, capture, or record device information.
```swift
import DeviceInfo
```

### Launch count information
A common need is to make adjustments in your app, or display different content for a user’s first launch of the app or a new version. You can use the `LaunchCountService` to accomplish this easily.

```swift
import DeviceInfo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var launchCountService = LaunchCountService()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    if launchCountService.launchCountForAllVersions == 0 {
      // Show welcome information
    } else if launchCountService.launchCountForCurrentVersion == 0 {
      // Show update information
    }
    launchCountService.incrementLaunchCountForCurrentVersion()
    return true
  }

}
```

### Device information
Often you will want to capture basic information about the device and configuration of your users. You can use the `DeviceInfoService` to make this simple.

```swift
import DeviceInfo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var deviceInfoService = DeviceInfoService()
  var networkAccess = NetworkAccess() // Your custom network access object

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    networkAccess.put("/devices", parameters: deviceInfoService.deviceInfoDictionary())
    return true
  }

  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let setToTrim = NSCharacterSet( charactersInString: "<>" )
    let tokenString = deviceToken.description.stringByTrimmingCharactersInSet(setToTrim).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    networkAccess.put("/devices", parameters: deviceInfoService.deviceInfoDictionary(tokenString))
  }

}
```

*Note: This example shows both capturing device information in the `application(_:didFinishLaunchingWithOptions:)` function as well as after registering for remote notifications. In a production app, you would typically do one or the other, but not both.*


## Integration
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate DeviceInfo into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "benjaminsnorris/DeviceInfo" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `DeviceInfo.framework` into your Xcode project.

### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `DeviceInfo` by adding the proper description to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PACKAGE_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/benjaminsnorris/DeviceInfo.git", majorVersion: 1)
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development. For more information check out its [GitHub Page](https://github.com/apple/swift-package-manager)


### Git Submodules

- If you don't already have a `.xcworkspace` for your project, create one. ([Here's how](https://developer.apple.com/library/ios/recipes/xcode_help-structure_navigator/articles/Adding_an_Existing_Project_to_a_Workspace.html))

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add DeviceInfo as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/benjaminsnorris/DeviceInfo.git Vendor/DeviceInfo
```

- Open the new `DeviceInfo` folder, and drag the `DeviceInfo.xcodeproj` into the Project Navigator of your application's Xcode workspace.

    > It should not be nested underneath your application's blue project icon. Whether it is above or below your application's project does not matter.

- Select `DeviceInfo.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Linked Frameworks and Libraries" section.
- Select `DeviceInfo.framework` inside the `Workspace` folder.
- Click on the `+` button under the "Embedded Binaries" section.
- Select `DeviceInfo.framework` nested inside your project.
- An extra copy of `DeviceInfo.framework` will show up in "Linked Frameworks and Libraries". Delete one of them (it doesn't matter which one).
- And that's it!
