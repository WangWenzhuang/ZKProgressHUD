![(logo)](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/Demo/image%402x.png)

# ZKProgressHUD

![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)
![CocoaPods](https://img.shields.io/badge/pod-v1.1-brightgreen.svg)
![platform](https://img.shields.io/badge/platform-iOS-brightgreen.svg)
![contact](https://img.shields.io/badge/contact-1020304029%40qq.com-brightgreen.svg)

iOS App 上极易于使用的 HUD。

![demo](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/demo.gif)

## 实现功能😌

- [x] 显示加载 ➕ 文字 
- [x] 显示 Gif 加载 ➕ 文字
- [x] 显示进度
- [x] 显示图片 ➕ 文字
- [x] 显示情景信息（info、success、error）
- [x] 显示 Tost 样式信息
- [x] 遮罩自定义显示
- [x] 自定义（背景色、前景色、字体、自动消失间隔秒、遮罩、动画类型...），满足极大多数场景

## 待实现💪

- [ ] 动画显示类型

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

## 快速使用

### 导入 `ZKProgressHUD`

```swift
import ZKProgressHUD
```

### 显示加载

```swift
ZKProgressHUD.show()
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.dismiss()
    }
})
```

### 显示加载和文字

```swift
ZKProgressHUD.show("正在拼命的加载中🏃🏃🏃")
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.dismiss()
        ZKProgressHUD.showInfo("加载完成😁😁😁")
    }
})
```

### 🆕显示 Gif 加载

```swift
ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: "loding", withExtension: "gif"), gifSize: 80)
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.dismiss()
    }
})
```

### 🆕显示 Gif 和文字加载

```swift
ZKProgressHUD.showGif(status: "正在拼命的加载中🏃🏃🏃", gifUrl: Bundle.main.url(forResource: "loding", withExtension: "gif"), gifSize: 80)
DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
    DispatchQueue.main.async {
        ZKProgressHUD.dismiss()
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
ZKProgressHUD.showImage(image: UIImage(named: "image"), status: "图片会自动消失😏😏😏")
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

### 显示 Tost 样式信息

```swift
ZKProgressHUD.showMessage("开始使用 ZKProgressHUD 吧")
```

### 隐藏

```swift
ZKProgressHUD.dismiss()
```

### 延迟隐藏⏰

```swift
ZKProgressHUD.dismiss(delay: 3)
```

## 自定义显示样式😏

![style1](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style1.PNG)
![style2](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style2.PNG)
![style3](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style3.PNG)
![style4](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style4.PNG)
![style5](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style5.PNG)
![style6](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style6.PNG)
![style7](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style7.PNG)
![style8](https://raw.githubusercontent.com/WangWenzhuang/ZKProgressHUD/master/image/style8.PNG)

### 设置是否显示遮罩

```swift
setMaskStyle (_ maskStyle : ZKProgressHUDMaskStyle )
```

### 设置遮罩背景色

```swift
setMaskBackgroundColor(_ color: UIColor)
```

### 设置前景色

```swift
setForegroundColor(_ color: UIColor)
```

### 设置背景色

```swift
setBackgroundColor(_ color: UIColor)
```

### 设置字体

```swift
setFont(_ font: UIFont)
```

设置圆角

```swift
setCornerRadius(_ cornerRadius: CGFloat)
```

### 设置加载动画类型

```swift
setAnimationStyle(_ animationStyle : ZKProgressHUDAnimationStyle )
```

### 设置自动隐藏时间（适用于非加载和进度类型显示）

```swift
setAutoDismissDelay(_ delay: Int)
```