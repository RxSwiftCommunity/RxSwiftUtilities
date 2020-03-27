// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "RxSwiftUtilities",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(name: "RxSwiftUtilities", targets: ["RxSwiftUtilities"])
    ],
    dependencies:[
        .package(url:"https://github.com/ReactiveX/RxSwift", from: "5.1.0")
    ],
    targets: [
        .target(name: "RxSwiftUtilities",
                dependencies:["RxSwift","RxCocoa"],
                path:"Source",
                sources:["Common",
                "iOS"])
    ]
)
