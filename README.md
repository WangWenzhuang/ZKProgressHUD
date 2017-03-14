![(logo)](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/Demo/image%402x.png)

# ZKProgressHUD

[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)
[![CocoaPods](https://img.shields.io/badge/pod-v0.5-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)
[![platform](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)
[![platform](https://img.shields.io/badge/contact-1020304029%40qq.com-brightgreen.svg)](https://github.com/WangWenzhuang/ZKProgressHUD)

A easy-to-use HUD for your iOS app.

## Requirements

* iOS 8.0 +

* Xcode 8 +

* Swift 3.0 +

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

### show

```swift
ZKProgressHUD.show()
// Simulation time consuming operation
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.hide()
    }
})
```

### show with status

```swift
ZKProgressHUD.show("loading")
// Simulation time consuming operation
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.hide()
    }
})
```

### showProgress

```swift
ZKProgressHUD.showProgress(1 / 10)
```

### showImage

```swift
ZKProgressHUD.showImage(UIImage(named: "image"))
```

### showImage with status

```swift
ZKProgressHUD.showImage(UIImage(named: "image"), status: "Hello world")
```

### showInfo

```swift
ZKProgressHUD.showInfo("Hello world")
```

### showSuccess

```swift
ZKProgressHUD.showSuccess("Hello world")
```

### showError

```swift
ZKProgressHUD.showError("Hello world")
```

### showMessage

```swift
ZKProgressHUD.showMessage("Hello world")
```

### hide

```swift
ZKProgressHUD.hide()
```

### hide with delay

```swift
ZKProgressHUD.hide(delay: 3)
```

## Customization

`ZKProgressHUD` can be customized via the following methods:

```swift
setMaskStyle (_ maskStyle : ZKProgressHUDMaskStyle )

setMaskBackgroundColor(_ color: UIColor)

setForegroundColor(_ color: UIColor)

setBackgroundColor(_ color: UIColor)

setFont(_ font: UIFont)

setCornerRadius(_ cornerRadius: CGFloat)

setAnimationStyle(_ animationStyle : ZKProgressHUDAnimationStyle )

setHideDelay(_ hideDelay: Int)
```

## TODO

* GIF image display