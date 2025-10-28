// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "UserDefaultsKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        // 사용자가 import하는 라이브러리
        .library(
            name: "UserDefaultsKit",
            targets: ["UserDefaultsKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        // 매크로 구현
        .macro(
            name: "UserDefaultsKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        
        // 공개 API
        .target(
            name: "UserDefaultsKit",
            dependencies: ["UserDefaultsKitMacros"]
        ),
        
        // 예제 실행 파일 (선택사항)
        .executableTarget(
            name: "UserDefaultsKitClient",
            dependencies: ["UserDefaultsKit"]
        ),
        
        // 테스트
        .testTarget(
            name: "UserDefaultsKitTests",
            dependencies: [
                "UserDefaultsKit",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
