![(logo)](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/Demo/image%402x.png)

# ZKProgressHUD

![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)
![CocoaPods](https://img.shields.io/badge/pod-v0.5-brightgreen.svg)
![platform](https://img.shields.io/badge/platform-iOS-brightgreen.svg)
![contact](https://img.shields.io/badge/contact-1020304029%40qq.com-brightgreen.svg)

iOS App 上易于使用的 HUD

![demo](https://github.com/WangWenzhuang/ZKProgressHUD/blob/master/demo.gif)

## 运行环境

* iOS 8.0 +

* Xcode 8 +

* Swift 3.0 +

## 安装

### CocoaPods

你可以使用 [CocoaPods](http://cocoapods.org/) 安装 `ZKProgressHUD`，在你的 `Podfile` 中添加：

```ogdl
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'ZKProgressHUD'
end
```
### 手动安装

* 拖动 `ZKProgressHUD` 文件夹到您的项目

* 将 `ZKProgressHUD.bundle` 添加到项目资源中 `Targets->Build Phases->Copy Bundle Resources`

## 使用

### 导入 `ZKProgressHUD`

```swift
import ZKProgressHUD
```

### 显示加载

```swift
ZKProgressHUD.show()
// Simulation time consuming operation
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.hide()
    }
})
```

### 显示加载和文字

```swift
ZKProgressHUD.show("loading")
// Simulation time consuming operation
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.hide()
    }
})
```

### 显示进度

```swift
ZKProgressHUD.showProgress(1 / 10)
```

### 显示图片

```swift
ZKProgressHUD.showImage(UIImage(named: "image"))
```

### 显示图片和文字

```swift
ZKProgressHUD.showImage(UIImage(named: "image"), status: "Hello world")
```

### 显示信息样式

```swift
ZKProgressHUD.showInfo("Hello world")
```

### 显示成功

```swift
ZKProgressHUD.showSuccess("Hello world")
```

### 显示错误

```swift
ZKProgressHUD.showError("Hello world")
```

### 显示消息（无图）

```swift
ZKProgressHUD.showMessage("Hello world")
```

### 隐藏

```swift
ZKProgressHUD.hide()
```

### 延迟隐藏

```swift
ZKProgressHUD.hide(delay: 3)
```

## 自定义😏


`ZKProgressHUD` 可以通过下面方法进行自定义:

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

## 待实现💪

* 显示 Gif 图片

* 重构代码
