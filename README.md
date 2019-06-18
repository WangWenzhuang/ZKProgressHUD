QQ 交流群：570590309，欢迎进群交流！

![(logo)](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/Demo/image%402x.png)

# ZKProgressHUD

![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)
![CocoaPods](https://img.shields.io/badge/pod-v5.1-brightgreen.svg)
![platform](https://img.shields.io/badge/platform-iOS-brightgreen.svg)

iOS App 上极易于使用的 HUD。

![demo](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/demo.gif)

## 近期更新

> * 适配 Swift 5
> * 增加 **isShowing** 属性，用于判断是否已经显示
> * 增加 **onlyOnceFont** 参数，用于临时显示一次的字体，不影响全局默认字体；
> * 增加 **autoDismissDelay** 参数，用于临时使用自动消失时间，不影响全局默认自动消失时间；

## 实现功能

- [x] 显示加载和文字信息
- [x] 显示 Gif 加载和文字信息
- [x] 显示进度
- [x] 显示图片和文字信息
- [x] 显示情景信息（info、success、error）
- [x] 显示 Toast 样式信息
- [x] 遮罩自定义显示
- [x] 显示动画
- [x] 自定义（背景色、前景色、字体、自动消失间隔秒、遮罩、动画类型、毛玻璃效果...），满足极大多数场景
- [x] 显示完成回调
- [x] 临时显示字体
- [x] 临时使用自动消失时间

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

如果使用 Swift 5 请使用最新版*5.0.1*

```ogdl
pod 'ZKProgressHUD', '5.0.1'
```

如果使用 Swift 4.2 请使用最新版*3.5*版本

```ogdl
pod 'ZKProgressHUD', '3.5'
```

如果使用 Swift 4.0 请使用*3.1*版本

```ogdl
pod 'ZKProgressHUD', '3.1'
```

如果使用 Swift 3.2 请使用*1.5*版本

```ogdl
pod 'ZKProgressHUD', '1.5'
```

### 手动安装

* 拖动 `ZKProgressHUD` 文件夹到您的项目
* 将 `ZKProgressHUD.bundle` 添加到项目资源中 `Targets->Build Phases->Copy Bundle Resources`

## 快速使用

### 导入 `ZKProgressHUD`

```swift
import ZKProgressHUD
```

### 显示完成回调（新增）

```swift
ZKProgressHUD.showMessage("开始使用 ZKProgressHUD 吧", completion: {
    // 输入代码
})
```

回调支持的函数有：

* showImage
* showMessage
* showInfo
* showSuccess
* showError

### 显示加载

```swift
ZKProgressHUD.show()
```

### 显示加载和文字

```swift
ZKProgressHUD.show("正在拼命的加载中🏃🏃🏃")
```

### 显示 Gif 加载

```swift
ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: "loding", withExtension: "gif"), gifSize: 80)
```

### 显示 Gif 和文字加载

```swift
ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: "loding", withExtension: "gif"), gifSize: 80, status: "正在拼命的加载中🏃🏃🏃")
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
ZKProgressHUD.showImage(UIImage(named: "image"), status: "图片会自动消失😏😏😏")
```

### 显示情景 -> 信息❗️

```swift
ZKProgressHUD.showInfo("Star 一下吧😙😙😙")
```

### 显示情景 -> 成功✅

```swift
ZKProgressHUD.showSuccess("操作成功👏👏👏")
```

### 显示情景 -> 错误❌

```swift
ZKProgressHUD.showError("出现错误了😢😢😢")
```

### 显示 Toast 样式信息

```swift
ZKProgressHUD.showMessage("开始使用 ZKProgressHUD 吧")
```

### 隐藏

```swift
ZKProgressHUD.dismiss()
```

### 延迟隐藏

```swift
ZKProgressHUD.dismiss(delay: 3)
```

## 自定义显示样式

![style1](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style1.jpeg)
![style2](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style2.jpeg)
![style3](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style3.jpeg)
![style4](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style4.jpeg)
![style5](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style5.jpeg)
![style6](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style6.jpeg)

### 设置遮罩样式，默认值：.visible

```swift
/// 隐藏
/// hide
    
/// 显示
/// visible
setMaskStyle (_ maskStyle: ZKProgressHUDMaskStyle)
```

### 设置动画显示/隐藏样式，默认值：.fade

```swift
/// 淡入/淡出（默认）
/// fade

/// 缩放
/// zoom

/// 飞入
/// flyInto
setAnimationShowStyle (_ animationShowStyle: ZKProgressHUDAnimationShowStyle)
```

### 设置遮罩背景色，默认值：.black

```swift
setMaskBackgroundColor(_ color: UIColor)
```

### 设置前景色，默认值：.white（前景色在设置 effectStyle 值时会自动适配，如果要使用自定义前景色，在调用 setEffectStyle 方法后调用 setForegroundColor 方法即可）

```swift
setForegroundColor(_ color: UIColor)
```

### 设置 HUD 毛玻璃效果（与 backgroundColor 互斥，如果设置毛玻璃效果不是.none，则根据样式自动设置前景色），默认值：.dark

```swift
setEffectStyle(_ hudEffectStyle: ZKProgressHUDEffectStyle)
```

### 设置 HUD 毛玻璃透明度，默认值：1

```swift
setEffectAlpha(_ effectAlpha: CGFloat)
```

### 设置 HUD 背景色（与 effectStyle 互斥，如果设置背景色，effectStyle = .none），默认值：UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.8)

```swift
setBackgroundColor(_ color: UIColor)
```

### 设置字体，默认值：UIFont.boldSystemFont(ofSize: 15)

```swift
setFont(_ font: UIFont)
```

### 设置圆角，默认值：6

```swift
setCornerRadius(_ cornerRadius: CGFloat)
```

### 设置加载动画样式动画样式，默认值：circle

```swift
/// 圆圈
/// circle

/// 系统样式（菊花）
/// system
setAnimationStyle(_ animationStyle: ZKProgressHUDAnimationStyle)
```

### 设置自动隐藏延时秒数，默认值：2

```swift
setAutoDismissDelay(_ delay: Int)
```
