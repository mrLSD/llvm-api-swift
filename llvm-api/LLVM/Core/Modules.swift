import CLLVM

/// Modules represent the top-level structure in an LLVM program. An LLVM
/// module is effectively a translation unit or a collection of
/// translation units merged together.
public final class Module: ModuleRef {
    private let llvm: LLVMModuleRef

    /// Retrieves the underlying LLVM value object.
    public var moduleRef: LLVMModuleRef { llvm }

    /// Init function by LLVM Value
    public init(llvm: LLVMModuleRef) {
        self.llvm = llvm
    }

    /// Create a new, empty module in the global context.
    ///
    ///  This is equivalent to calling LLVMModuleCreateWithNameInContext with
    ///  LLVMGetGlobalContext() as the context parameter.
    ///
    ///  Every invocation should be paired with LLVMDisposeModule() or memory  will be leaked.
    public init(name: String) {
        llvm = name.withCString { cString in
            LLVMModuleCreateWithName(cString)
        }
    }

    ///  Create a new, empty module in a specific context.
    ///
    ///  Every invocation should be paired with LLVMDisposeModule() or memory will be leaked.
    public init(name: String, context: ContextRef) {
        llvm = name.withCString { cString in
            LLVMModuleCreateWithNameInContext(cString, context.contextRef)
        }
    }

    /// Return an exact copy of the specified module.
    public func clone_nodule() -> ModuleRef {
        let new_module = LLVMCloneModule(llvm)!
        return Self(llvm: new_module)
    }

    /// Obtain the identifier of a module.
    public var getLLVMModuleIdentifier: String {
        var length: UInt = 0
        guard let cString = LLVMGetModuleIdentifier(llvm, &length) else { return "" }
        return String(cString: cString)
    }

    public func setLLVMModuleIdentifier(module: LLVMModuleRef, identifier: String) {
        identifier.withCString { cString in
            LLVMSetModuleIdentifier(module, cString, identifier.count)
        }
    }

    public var getModuleIdentifier: String? {
        var length: UInt = 0
        guard let cString = LLVMGetModuleIdentifier(llvm, &length) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Set the identifier of a module to a string Ident with length Len.
    public func setSourceFileName(fileName: String) {
        fileName.withCString { cString in
            LLVMSetSourceFileName(llvm, cString, fileName.utf8.count)
        }
    }

    /// Obtain the module's original source file name.
    public var getSourceFileName: String? {
        var length: size_t = 0
        guard let cString = LLVMGetSourceFileName(llvm, &length) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Set the data layout for a module.
    public func setDataLayout(module: LLVMModuleRef, dataLayout: String) {
        dataLayout.withCString { cString in
            LLVMSetDataLayout(module, cString)
        }
    }

    /// Obtain the data layout for a module.
    public var getDataLayout: String? {
        guard let cString = LLVMGetDataLayoutStr(llvm) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Set the target triple for a module.
    public func setTarget(triple: String) {
        triple.withCString { cString in
            LLVMSetTarget(llvm, cString)
        }
    }

    /// Destroy a module instance.
    ///
    /// This must be called for every created module or memory will be leaked.
    deinit {
        LLVMDisposeModule(llvm)
    }
}
