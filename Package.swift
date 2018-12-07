// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AmazonOrderExtractor",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AmazonOrderExtractor",
            targets: ["AmazonOrderExtractor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AthanasiusOfAlex/MicrosoftOutlookScripting.git", .branch("master")),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", .branch("master")),
        .package(url: "https://github.com/sharplet/Regex.git", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AmazonOrderExtractor",
            dependencies: ["MicrosoftOutlookScripting", "SwiftSoup", "Regex"]),
        .testTarget(
            name: "AmazonOrderExtractorTests",
            dependencies: ["AmazonOrderExtractor"]),
    ]
)
