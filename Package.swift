// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "llvm-api",
    products: [
        .library(name: "llvm-api", targets: ["LLVM"]),
    ],
    targets: getTargets()
)

struct GetConfigError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

/// Get LLVM config flags
func getLLVMConfig() throws -> ([String], [String], [Int]) {
    let brewPrefix = {
        guard let brew = which("brew") else { return nil }
        return run(brew, args: ["--prefix"])
    }() ?? "/usr/local"
    /// Ensure we have llvm-config in the PATH
    guard let llvmConfig = which("llvm-config") ?? which("\(brewPrefix)/opt/llvm/bin/llvm-config") else {
        throw GetConfigError("Failed to find llvm-config. Ensure llvm-config is installed and in your PATH")
    }
    // Fetch LLVM version
    let versionStr = run(llvmConfig, args: ["--version"])!
        .replacing(charactersIn: .newlines, with: "")
        .replacingOccurrences(of: "svn", with: "")
    let versionComponents = versionStr.components(separatedBy: ".")
        .compactMap { Int($0) }
    // Get linkage (LD) flags
    let ldFlags = run(llvmConfig, args: ["--ldflags", "--libs", "all", "--system-libs"])!
        .replacing(charactersIn: .newlines, with: " ")
        .components(separatedBy: " ")
        .filter { !$0.hasPrefix("-W") }
    // Get C flags
    let cFlags = run(llvmConfig, args: ["--cflags"])!
        .replacing(charactersIn: .newlines, with: "")
        .components(separatedBy: " ")
        .filter { $0.hasPrefix("-I") }
    return (cFlags, ldFlags, versionComponents)
}

/// Runs the specified program at the provided path.
/// - parameter path: The full path of the executable you wish to run.
/// - parameter args: The arguments you wish to pass to the process.
/// - returns: The standard output of the process, or nil if it was empty.
func run(_ path: String, args: [String] = []) -> String? {
    let pipe = Pipe()
    let process = Process()
    process.executableURL = URL(fileURLWithPath: path)
    process.arguments = args
    process.standardOutput = pipe
    try? process.run()
    process.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let result = String(data: data, encoding: .utf8)?
        .trimmingCharacters(in: .whitespacesAndNewlines),
        !result.isEmpty else { return nil }
    return result
}

/// Finds the location of the provided binary on your system.
func which(_ name: String) -> String? {
    run("/usr/bin/which", args: [name])
}

extension String {
    /// Replaces all occurrences of characters in the provided set with the provided string.
    func replacing(charactersIn characterSet: CharacterSet,
                   with separator: String) -> String
    {
        let components = components(separatedBy: characterSet)
        return components.joined(separator: separator)
    }
}

/// Check Environment variable
func hasEnvironmentVariable(_ name: String) -> Bool {
    ProcessInfo.processInfo.environment[name] != nil
}

func getTargets() -> [Target] {
    if hasEnvironmentVariable("CLI_BUILD") {
        let (cFlags, linkFlags, _) = try! getLLVMConfig()
        let customSystemLibrary = Target.systemLibrary(
            name: "CLLVM"
        )
        let llvmTarget = Target.target(
            name: "LLVM",
            dependencies: ["CLLVM"],
            cSettings: [
                .unsafeFlags(cFlags),
            ],
            linkerSettings: [
                .unsafeFlags(linkFlags),
            ]
        )
        return [customSystemLibrary, llvmTarget]
    } else {
        let customSystemLibrary: Target = .systemLibrary(
            name: "CLLVM",
            pkgConfig: "llvm"
        )
        let llvmTarget: Target = .target(
            name: "LLVM",
            dependencies: ["CLLVM"]
        )
        return [customSystemLibrary, llvmTarget]
    }
}
