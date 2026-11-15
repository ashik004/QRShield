// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "QRShield",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "QRShield",
            targets: ["QRShield"]
        )
    ],
    targets: [
        .executableTarget(
            name: "QRShield",
            path: "Sources/QRShield"
        )
    ]
)
