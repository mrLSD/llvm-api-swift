// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "llvm-api",
    products: [
        .library(name: "llvm-api", targets: ["LLVM"]),
    ],
    targets: [
        .systemLibrary(
            name: "CLLVM",
            path: "llvm-api/CLLVM",
            pkgConfig: "CLLVM",
            providers: [
                .brew(["llvm"]),
            ]
        ),
        .target(
            name: "LLVM",
            dependencies: ["CLLVM"],
            path: "llvm-api/LLVM"
        ),
    ],
    cxxLanguageStandard: .cxx20
)
