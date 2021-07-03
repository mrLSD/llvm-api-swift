// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "llvm-codegen",
    products: [
        .executable(name: "llvm-codegen", targets: ["llvm-codegen"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0")
    ],
    targets: [
        .executableTarget(
            name: "llvm-codegen",
            dependencies: [
                "LLVM",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ],
            path: "llvm-codegen/cli"
        ),
        .systemLibrary(
            name: "CLLVM",
            path: "llvm-codegen/CLLVM",
            pkgConfig: "CLLVM",
            providers: [
                .brew(["llvm"])
            ]
        ),
        .target(
            name: "LLVM",
            dependencies: ["CLLVM"],
            path: "llvm-codegen/LLVM"
        )
    ],
    cxxLanguageStandard: .cxx17
)
