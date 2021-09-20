import CLLVM

/// This modules provide an interface to libLLVMCore, which implements the LLVM intermediate representation as well
/// as other related types and utilities.
///
/// Many exotic languages can interoperate with C code but have a harder time with C++ due to name mangling. So in addition to C,
/// this interface enables tools written in such languages.
/// - SeeAlso: https://llvm.org/doxygen/group__LLVMCCore.html
enum Core {
    /// Return the major, minor, and patch version of LLVM
    /// The version components are returned via the function's three output
    /// parameters or skipped if a NULL pointer was supplied - return 0.
    public static func getVersion() -> (major: UInt32, minor: UInt32, patch: UInt32) {
        var major: UInt32 = 0
        var minor: UInt32 = 0
        var patch: UInt32 = 0

        withUnsafeMutablePointer(to: &major) { majorPtr in
            withUnsafeMutablePointer(to: &minor) { minorPtr in
                withUnsafeMutablePointer(to: &patch) { patchPtr in
                    LLVMGetVersion(majorPtr, minorPtr, patchPtr)
                }
            }
        }
        return (major, minor, patch)
    }

    /// Create message string reference. Run [disposeMessage] to free message.
    /// It useful when LLVM wait as parameter LLVM-string
    ///
    /// - SeeAlso: `disposeLLVMMessage`
    public static func createMessage(with message: String) -> UnsafeMutablePointer<CChar>? {
        return message.withCString { cString in
            LLVMCreateMessage(cString)
        }
    }

    /// Dispose LLVM message
    public static func disposeMessage(_ message: UnsafeMutablePointer<CChar>?) {
        LLVMDisposeMessage(message)
    }

    /// This function permanently loads the dynamic library at the given path.
    /// It is safe to call this function multiple times for the same library.
    public static func loadLibraryPermanently(filename: String) -> Bool {
        return filename.withCString { cString in
            LLVMLoadLibraryPermanently(cString) != 0
        }
    }

    /// This function parses the given arguments using the LLVM command line parser.
    /// Note that the only stable thing about this function is its signature; you
    /// cannot rely on any particular set of command line arguments being interpreted
    /// the same way across LLVM versions.
    public static func parseCommandLineOptions(arguments: [String], overview: String) {
        let cArgs = arguments.map { $0.withCString(strdup) }
        defer { cArgs.forEach { free($0) } }
        overview.withCString { cOverview in
            let cArgsPointers = cArgs.map { UnsafePointer($0) }
            cArgsPointers.withUnsafeBufferPointer { cArgsPointersBuffer in
                LLVMParseCommandLineOptions(Int32(arguments.count), cArgsPointersBuffer.baseAddress, cOverview)
            }
        }
    }

    /// This function will search through all previously loaded dynamic
    /// libraries for the symbol `symbolName`. If it is found, the address of
    /// that symbol is returned. If not, null is returned.
    public static func searchForAddressOfSymbol(symbolName: String) -> UnsafeMutableRawPointer? {
        return symbolName.withCString { cString in
            LLVMSearchForAddressOfSymbol(cString)
        }
    }

    /// This functions permanently adds the symbol \p symbolName with the
    /// value  `symbolValue`.  These symbols are searched before any libraries.
    public static func addSymbol(symbolName: String, symbolValue: UnsafeMutableRawPointer) {
        symbolName.withCString { cString in
            LLVMAddSymbol(cString, symbolValue)
        }
    }
}
