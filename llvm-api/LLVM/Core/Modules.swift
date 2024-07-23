import CLLVM

/// Modules represent the top-level structure in an LLVM program. An LLVM
/// module is effectively a translation unit or a collection of
/// translation units merged together.
public final class Module: ModuleRef {
    private let llvm: LLVMModuleRef

    /// Retrieves the underlying LLVM value object.
    public var moduleRef: LLVMModuleRef { llvm }

    public enum InlineAsmDialect {
        case att
        case intel
    }

    /// Named Metadata Node
    public class NamedMetadataNode: NamedMetadataNodeRef {
        private var llvm: LLVMNamedMDNodeRef

        /// Retrieves the underlying LLVM value object.
        public var namedMetadataNodeRef: LLVMNamedMDNodeRef { llvm }

        init(llvm: LLVMNamedMDNodeRef) {
            self.llvm = llvm
        }

        /// Advance a `NamedMetaDataNode` iterator to the next `NamedMetaDataNode`.
        ///
        /// Returns NULL if the iterator was already at the end and there are no more
        /// named metadata nodes.
        public func getNext() -> NamedMetadataNode? {
            guard let nextRef = LLVMGetNextNamedMetadata(llvm) else {
                return nil
            }
            return NamedMetadataNode(llvm: nextRef)
        }

        /// Decrement a `NamedMetaDataNode` iterator to the previous `NamedMetaDataNode`.
        ///
        /// Returns NULL if the iterator was already at the beginning and there are
        /// no previously named metadata nodes.
        public func getPrevious() -> NamedMetadataNode? {
            guard let prevRef = LLVMGetPreviousNamedMetadata(llvm) else {
                return nil
            }
            return NamedMetadataNode(llvm: prevRef)
        }

        /// Retrieve the name of a `NamedMetadataNode`.
        public func getName() -> String? {
            var length: size_t = 0
            guard let cStr = LLVMGetNamedMetadataName(llvm, &length) else {
                return nil
            }
            return String(cString: cStr)
        }
    }

    /// Enumerates the supported behaviors for resolving collisions when two
    /// module flags share the same key.  These collisions can occur when the
    /// different flags are inserted under the same key, or when modules
    /// containing flags under the same key are merged.
    public enum ModuleFlagBehavior {
        /// Emits an error if two values disagree, otherwise the resulting value
        /// is that of the operands.
        case error
        /// Emits a warning if two values disagree. The result value will be the
        /// operand for the flag from the first module being linked.
        case warning
        /// Adds a requirement that another module flag be present and have a
        /// specified value after linking is performed. The value must be a
        /// metadata pair, where the first element of the pair is the ID of the
        /// module flag to be restricted, and the second element of the pair is
        /// the value the module flag should be restricted to. This behavior can
        /// be used to restrict the allowable results (via triggering of an error)
        /// of linking IDs with the **Override** behavior.
        case require
        /// Uses the specified value, regardless of the behavior or value of the
        /// other module. If both modules specify **Override**, but the values
        /// differ, an error will be emitted.
        case override
        /// Appends the two values, which are required to be metadata nodes.
        case append
        /// Appends the two values, which are required to be metadata
        /// nodes. However, duplicate entries in the second list are dropped
        /// during the append operation.
        case appendUnique

        init(raw: LLVMModuleFlagBehavior) {
            switch raw {
            case LLVMModuleFlagBehaviorError:
                self = .error
            case LLVMModuleFlagBehaviorWarning:
                self = .warning
            case LLVMModuleFlagBehaviorRequire:
                self = .require
            case LLVMModuleFlagBehaviorOverride:
                self = .override
            case LLVMModuleFlagBehaviorAppend:
                self = .append
            case LLVMModuleFlagBehaviorAppendUnique:
                self = .appendUnique
            default:
                fatalError("Unknown behavior kind")
            }
        }
    }

    class Metadata: MetadataRef {
       private let llvm:LLVMMetadataRef
       public var metadataRef: LLVMMetadataRef {
           llvm }
        public init(llvm: LLVMMetadataRef ) {
            self.llvm = llvm
        }
    }

    public class ModuleFlagEntry {
        private let llvm: OpaquePointer?
        private let bounds: Int

        public init(llvm:OpaquePointer?, bounds: Int) {
            self.llvm = llvm
            self.bounds = bounds
        }

        /// Get Metadata flags etries count
        public var count: Int { self.bounds }

         /// Returns the flag behavior for a module flag entry at a specific index.
        public func getFlagBehavior(at index: UInt32) -> ModuleFlagBehavior {
            let bh = LLVMModuleFlagEntriesGetFlagBehavior(llvm, index)
            return ModuleFlagBehavior(raw: bh)
        }

         /// Returns the key for a module flag entry at a specific index.
        public func getKey(at index: UInt32) -> String {
            var length: Int = 0
            let keyPointer = LLVMModuleFlagEntriesGetKey(llvm, index, &length)
            return String(cString: keyPointer!)

        }

         /// Returns the metadata for a module flag entry at a specific index.
        public func getMetadata(at index: UInt32) -> MetadataRef {
            let metadata = LLVMModuleFlagEntriesGetMetadata(llvm, index)!
            return Metadata(llvm: metadata)
        }

        /// Deinitialize this value and dispose of its resources.
        deinit {
          guard let ptr = llvm else { return }
          LLVMDisposeModuleFlagsMetadata(ptr)
        }
    }

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
    public func cloneModule() -> Self {
        let new_module = LLVMCloneModule(llvm)!
        return Self(llvm: new_module)
    }

    /// Get and Set the identifier of a module.
    public var moduleIdentifier: String {
        get {
            self.getModuleIdentifier
        }
        set {
            self.setModuleIdentifier(identifier: newValue)
        }
    }

    /// Obtain the identifier of a module.
    public var getModuleIdentifier: String {
        var length: UInt = 0
        guard let cString = LLVMGetModuleIdentifier(llvm, &length) else { return "" }
        return String(cString: cString)
    }

    /// Set the identifier of a module to a string Ident with length Len.
    public func setModuleIdentifier(identifier: String) {
        identifier.withCString { cString in
            LLVMSetModuleIdentifier(llvm, cString, identifier.count)
        }
    }

    /// Get and Set the original source file name of a module to a string Name
    public var sourceFileName: String {
        get {
            self.getSourceFileName!
        }
        set {
            self.setSourceFileName(fileName: newValue)
        }
    }

    ///Set the original source file name of a module to a string Name
    public func setSourceFileName(fileName: String) {
        fileName.withCString { cString in
            LLVMSetSourceFileName(llvm, cString, fileName.utf8.count)
        }
    }

    /// Obtain the module's original source file name.
    public var getSourceFileName: String? {
        var length: Int = 0
        guard let cString = LLVMGetSourceFileName(llvm, &length) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Set the data layout for a module.
    public func setDataLayout(dataLayout: String) {
        dataLayout.withCString { cString in
            LLVMSetDataLayout(llvm, cString)
        }
    }

    /// Obtain the data layout for a module.
    public var getDataLayout: String? {
        guard let cString = LLVMGetDataLayoutStr(llvm) else {
            return nil
        }
        return String(cString: cString)
    }


     /// Obtain the target triple for a module.
    func getTargetTriple() -> String {
        guard let targetTriplePointer = LLVMGetTarget(llvm) else {
            return ""
        }
        return String(cString: targetTriplePointer)
    }

    /// Set the target triple for a module.
    public func setTarget(triple: String) {
        triple.withCString { cString in
            LLVMSetTarget(llvm, cString)
        }
    }

     /// Returns the module flags as an array of flag-key-value triples. The caller
     /// is responsible for freeing this array by calling
     /// `LLVMDisposeModuleFlagsMetadata`.
    public func copyModuleFlagsMetadata() -> ModuleFlagEntry? {
        var length: Int = 0
        guard let flagsPointer = LLVMCopyModuleFlagsMetadata(llvm, &length) else {  return nil }

        return   ModuleFlagEntry(llvm: flagsPointer, bounds: length)
    }

    /// Destroy a module instance.
    ///
    /// This must be called for every created module or memory will be leaked.
    deinit {
        LLVMDisposeModule(llvm)
    }
}
