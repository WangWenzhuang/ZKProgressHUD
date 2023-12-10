// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ZKProgressHUD",
    platforms: [.iOS(.v8)],
    products: [
        .library(
            name: "ZKProgressHUD", 
            targets: ["ZKProgressHUD"]
        )
    ],
    targets: [
        .target(
            name: "ZKProgressHUD", 
            path: "ZKProgressHUD"
        ),
        resources: [
            .copy("ZKProgressHUD.bundle")
        ],
    ],
    swiftLanguageVersions: [.v5]
)