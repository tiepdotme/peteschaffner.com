// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebpageTitle",
    products: [
		.executable(name: "title", targets: ["WebpageTitle"]),
    ],
    dependencies: [
		.package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
    ],
    targets: [
        .executableTarget(
            name: "WebpageTitle",
            dependencies: ["SwiftSoup"]),
    ]
)
