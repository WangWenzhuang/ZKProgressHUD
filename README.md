# ZKProgressHUD

[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)
[![CocoaPods](https://img.shields.io/badge/pod-v0.5-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)
[![platform](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)
[![platform](https://img.shields.io/badge/contact-1020304029%40qq.com-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)

A easy-to-use HUD for your iOS app.

## Requirements

- iOS 8.0 +
- Xcode 8 +
- Swift 3.0 +

## Installation

### CocoaPods

You can use [CocoaPods](http://cocoapods.org/) to install `ZKProgressHUD` by adding it to your `Podfile`:

```ogdl
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'ZKProgressHUD'
end
```
### Manually

* Drag the `ZKProgressHUD` folder into your project.
* Take care that `ZKProgressHUD.bundle` is added to `Targets->Build Phases->Copy Bundle Resources`.

## Usage

### Import library

```swift
import ZKProgressHUD
```

### Loading

```swift
ZKProgressHUD.loading()
// Simulation time consuming operation
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.hide()
    }
})
```

### Loading and message

```swift
ZKProgressHUD.loading()
// Simulation time consuming operation
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.loading("loading")
    }
})
```

### Message

```swift
ZKProgressHUD.message("Hello world")
```

### Image

```swift
ZKProgressHUD.image(UIImage(named: "image")!)
```

### Image and message

```swift
ZKProgressHUD.image(UIImage(named: "image")!, status: "Hello world")
```

### Info

```swift
ZKProgressHUD.showInfo("Hello world")
```

### Success

```swift
ZKProgressHUD.showSuccess("Hello world")
```

### Error

```swift
ZKProgressHUD.showError("Hello world")
```

### Hide

```swift
ZKProgressHUD.hide()
```

### Delay hide

```swift
ZKProgressHUD.hide(delay: 3)
```
