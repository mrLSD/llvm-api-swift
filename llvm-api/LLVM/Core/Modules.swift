import CLLVM

/// Modules represent the top-level structure in an LLVM program. An LLVM
/// module is effectively a translation unit or a collection of
/// translation units merged together.
public final class Module: ModuleRef {
    private let llvm: LLVMModuleRef

    /// Retrieves the underlying LLVM value object.
    public var moduleRef: LLVMModuleRef { llvm }

    /// Inline Asm Dialect
    public enum InlineAsmDialect {
        case att
        case intel

        /// Init inline asm dialect from LLVM
        public init(llvm: LLVMInlineAsmDialect) {
            switch llvm {
            case LLVMInlineAsmDialectATT: self = .att
            case LLVMInlineAsmDialectIntel: self = .intel
            default:
                fatalError("Unknown behavior kind")
            }
        }

        /// Get LLVM representation
        public var llvm: LLVMInlineAsmDialect {
            switch self {
            case .att: LLVMInlineAsmDialectATT
            case .intel: LLVMInlineAsmDialectIntel
            }
        }
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

        /// Converts ModuleFlagBehavior to LLVMModuleFlagBehavior
        public var moduleFlagBehavior: LLVMModuleFlagBehavior {
            switch self {
            case .error:
                LLVMModuleFlagBehaviorError
            case .warning:
                LLVMModuleFlagBehaviorWarning
            case .require:
                LLVMModuleFlagBehaviorRequire
            case .override:
                LLVMModuleFlagBehaviorOverride
            case .append:
                LLVMModuleFlagBehaviorAppend
            case .appendUnique:
                LLVMModuleFlagBehaviorAppendUnique
            }
        }
    }

    class Metadata: MetadataRef {
        private let llvm: LLVMMetadataRef
        public var metadataRef: LLVMMetadataRef {
            llvm
        }

        public init(llvm: LLVMMetadataRef) {
            self.llvm = llvm
        }
    }

    /// Represents the possible errors that can be thrown while interacting with a
    /// `Module` object.
    public enum ModuleError: Error, CustomStringConvertible {
        /// Thrown when a module does not pass the module verification process.
        /// Includes the reason the module did not pass verification.
        case didNotPassVerification(String)
        /// Thrown when a module cannot be printed at a given path.  Provides the
        /// erroneous path and a deeper reason why printing to that path failed.
        case couldNotPrint(path: String, error: String)
        /// Thrown when a module cannot emit bitcode because it contains erroneous
        /// declarations.
        case couldNotEmitBitCode(path: String)

        public var description: String {
            switch self {
            case let .didNotPassVerification(message):
                "module did not pass verification: \(message)"
            case let .couldNotPrint(path, error):
                "could not print to file \(path): \(error)"
            case let .couldNotEmitBitCode(path):
                "could not emit bitcode to file \(path) for an unknown reason"
            }
        }
    }

    public class ModuleFlagEntry {
        private let llvm: OpaquePointer?
        private let bounds: Int

        public init(llvm: OpaquePointer?, bounds: Int) {
            self.llvm = llvm
            self.bounds = bounds
        }

        /// Get Metadata flags etries count
        public var count: Int { bounds }

        /// Returns the flag behavior for a module flag entry at a specific index.
        public func getFlagBehavior(at index: UInt32) -> ModuleFlagBehavior {
            let bh = LLVMModuleFlagEntriesGetFlagBehavior(llvm, index)
            return ModuleFlagBehavior(raw: bh)
        }

        /// Returns the key for a module flag entry at a specific index.
        public func getKey(at index: UInt32) -> String {
            var length = 0
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
            getModuleIdentifier
        }
        set {
            setModuleIdentifier(identifier: newValue)
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
            getSourceFileName!
        }
        set {
            setSourceFileName(fileName: newValue)
        }
    }

    /// Set the original source file name of a module to a string Name
    public func setSourceFileName(fileName: String) {
        fileName.withCString { cString in
            LLVMSetSourceFileName(llvm, cString, fileName.utf8.count)
        }
    }

    /// Obtain the module's original source file name.
    public var getSourceFileName: String? {
        var length = 0
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
        var length = 0
        guard let flagsPointer = LLVMCopyModuleFlagsMetadata(llvm, &length) else { return nil }

        return ModuleFlagEntry(llvm: flagsPointer, bounds: length)
    }

    /// Add a module-level flag to the module-level flags metadata if it doesn't
    /// already exist.
    func getModuleFlag(key: String) -> MetadataRef {
        let keyLen = key.utf8.count
        let metadata = key.withCString { keyPtr in
            LLVMGetModuleFlag(llvm, keyPtr, keyLen)!
        }
        return Metadata(llvm: metadata)
    }

    /// Add a module-level flag to the module-level flags metadata if it doesn't
    /// already exist.
    func addModuleFlag(behavior: ModuleFlagBehavior, key: String, value: MetadataRef) {
        let keyLen = key.utf8.count
        key.withCString { keyPtr in
            LLVMAddModuleFlag(llvm, behavior.moduleFlagBehavior, keyPtr, keyLen, value.metadataRef)
        }
    }

    /// Dump a representation of a module to stderr.
    func dump_module() {
        LLVMDumpModule(llvm)
    }

    /// Print a representation of a module to a file. The ErrorMessage needs to be
    /// disposed with `LLVMDisposeMessage`. Returns 0 on success, 1 otherwise.
    func printToFile(filename: String) throws {
        var errorMessage: UnsafeMutablePointer<CChar>?

        let result = filename.withCString { filenamePtr in
            LLVMPrintModuleToFile(llvm, filenamePtr, &errorMessage)
        }

        if result != 0, let errorMessage {
            defer { LLVMDisposeMessage(errorMessage) }
            let errorString = String(cString: errorMessage)
            throw ModuleError.couldNotPrint(path: filename, error: errorString)
        }
    }

    /// Return a string representation of the module. Use
    /// `LLVMDisposeMessage` to free the string.
    func printToString() -> String {
        guard let moduleString = LLVMPrintModuleToString(llvm) else {
            return ""
        }
        defer { LLVMDisposeMessage(moduleString) }
        return String(cString: moduleString)
    }

    /// ==========================
    /// Get inline assembly for a module.
    public func getModuleInlineAsm(module _: LLVMModuleRef) -> String {
        var length = 0
        let cString = LLVMGetModuleInlineAsm(llvm, &length)
        return String(cString: cString!)
    }

    /// Set inline assembly for a module.
    public func setModuleInlineAsm(asm: String) {
        asm.withCString { cString in
            LLVMSetModuleInlineAsm2(llvm, cString, asm.utf8.count)
        }
    }

    /// Append inline assembly to a module.
    public func appendModuleInlineAsm(asm: String) {
        asm.withCString { cString in
            LLVMAppendModuleInlineAsm(llvm, cString, asm.utf8.count)
        }
    }

    /// Create the specified uniqued inline asm string.
    public func getInlineAsm(type: TypeRef, asmString: String, constraints: String,
                             hasSideEffects: Bool, isAlignStack: Bool,
                             dialect: InlineAsmDialect, canThrow: Bool) -> ValueRef
    {
        let inlineAsm = asmString.withCString { asmCString in
            constraints.withCString { constraintsCString in
                LLVMGetInlineAsm(type.typeRef, asmCString, asmString.utf8.count, constraintsCString, constraints.utf8.count, hasSideEffects.llvm, isAlignStack.llvm, dialect.llvm, canThrow.llvm)
            }
        }
        return Value(llvm: inlineAsm!)
    }

    /// Get the template string used for an inline assembly snippet
    public func getInlineAsmAsmString(inlineAsmVal: ValueRef) -> String {
        var length = 0
        let cString = LLVMGetInlineAsmAsmString(inlineAsmVal.valueRef, &length)
        return String(cString: cString!)
    }

    /// Get the raw constraint string for an inline assembly snippet
    public func getInlineAsmConstraintString(inlineAsmVal: ValueRef) -> String {
        var length = 0
        let cString = LLVMGetInlineAsmConstraintString(inlineAsmVal.valueRef, &length)
        return String(cString: cString!)
    }

    /// Get the dialect used by the inline asm snippet
    public func getInlineAsmDialect(inlineAsmVal: ValueRef) -> InlineAsmDialect {
        let dialect = LLVMGetInlineAsmDialect(inlineAsmVal.valueRef)
        return InlineAsmDialect(llvm: dialect)
    }

    /// Get the function type of the inline assembly snippet. The same type that
    /// was passed into LLVMGetInlineAsm originally
    public func getInlineAsmFunctionType(inlineAsmVal: ValueRef) -> TypeRef {
        let typeRef = LLVMGetInlineAsmFunctionType(inlineAsmVal.valueRef)
        return Types(llvm: typeRef!)
    }

    /// Get if the inline asm snippet has side effects
    public func inlineAsmHasSideEffects(inlineAsmVal: ValueRef) -> Bool {
        LLVMGetInlineAsmHasSideEffects(inlineAsmVal.valueRef) != 0
    }

    /// Get if the inline asm snippet needs an aligned stack
    public func inlineAsmNeedsAlignedStack(inlineAsmVal: ValueRef) -> Bool {
        LLVMGetInlineAsmNeedsAlignedStack(inlineAsmVal.valueRef) != 0
    }

    /// Get if the inline asm snippet may unwind the stack
    public func inlineAsmCanUnwind(inlineAsmVal: ValueRef) -> Bool {
        LLVMGetInlineAsmCanUnwind(inlineAsmVal.valueRef) != 0
    }

    /// Obtain the context to which this module is associated.
    public func getModuleContext() -> ContextRef {
        let context = LLVMGetModuleContext(llvm)
        return Context(llvm: context!)
    }

    /// Obtain an iterator to the first NamedMDNode in a Module.
    public func getFirstNamedMetadata() -> NamedMetadataNodeRef {
        let namedMD = LLVMGetFirstNamedMetadata(llvm)
        return NamedMetadataNode(llvm: namedMD!)
    }

    /// Obtain an iterator to the last NamedMDNode in a Module.
    public func getLastNamedMetadata() -> NamedMetadataNodeRef {
        let namedMD = LLVMGetLastNamedMetadata(llvm)
        return NamedMetadataNode(llvm: namedMD!)
    }

    /// Advance a NamedMDNode iterator to the next NamedMDNode.
    ///
    /// Returns NULL if the iterator was already at the end and there are no more
    /// named metadata nodes.
    public func getNextNamedMetadata(namedMDNode: NamedMetadataNodeRef) -> NamedMetadataNodeRef {
        let namedMD = LLVMGetNextNamedMetadata(namedMDNode.namedMetadataNodeRef)
        return NamedMetadataNode(llvm: namedMD!)
    }

    /// Decrement a NamedMDNode iterator to the previous NamedMDNode.
    ///
    /// Returns NULL if the iterator was already at the beginning and there are
    /// no previous named metadata nodes.
    public func getPreviousNamedMetadata(namedMDNode: NamedMetadataNodeRef) -> NamedMetadataNodeRef {
        let namedMD = LLVMGetPreviousNamedMetadata(namedMDNode.namedMetadataNodeRef)
        return NamedMetadataNode(llvm: namedMD!)
    }

    /// Retrieve a NamedMDNode with the given name, returning NULL if no such
    /// node exists.
    public func getNamedMetadata(name: String) -> NamedMetadataNodeRef {
        let namedMD = name.withCString { cString in
            LLVMGetNamedMetadata(llvm, cString, name.utf8.count)
        }
        return NamedMetadataNode(llvm: namedMD!)
    }

    /// Retrieve a NamedMDNode with the given name, creating a new node if no such
    /// node exists.
    public func getOrInsertNamedMetadata(name: String) -> NamedMetadataNodeRef {
        let namedMD = name.withCString { cString in
            LLVMGetOrInsertNamedMetadata(llvm, cString, name.utf8.count)
        }
        return NamedMetadataNode(llvm: namedMD!)
    }

    /// Retrieve the name of a NamedMDNode.
    public func getNamedMetadataName(namedMD: NamedMetadataNodeRef) -> String? {
        var nameLen = 0
        guard let cString = LLVMGetNamedMetadataName(namedMD.namedMetadataNodeRef, &nameLen) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Obtain the number of operands for named metadata in a module.
    public func getNamedMetadataNumOperands(name: String) -> UInt32 {
        name.withCString { cString in
            LLVMGetNamedMetadataNumOperands(llvm, cString)
        }
    }

    /// Obtain the named metadata operands for a module.
    ///
    /// The passed LLVMValueRef pointer should refer to an array of
    /// LLVMValueRef at least LLVMGetNamedMetadataNumOperands long. This
    /// array will be populated with the LLVMValueRef instances. Each
    /// instance corresponds to a llvm::MDNode.
    public func getNamedMetadataOperands(name: String) -> [ValueRef] {
        let numOperands = getNamedMetadataNumOperands(name: name)
        var operands = [LLVMValueRef?](repeating: nil, count: Int(numOperands))

        operands.withUnsafeMutableBufferPointer { buffer in
            name.withCString { cString in
                LLVMGetNamedMetadataOperands(llvm, cString, buffer.baseAddress)
            }
        }

        return operands.compactMap { Value(llvm: $0!) }
    }

    /// Add an operand to named metadata.
    public func addNamedMetadataOperand(name: String, value: ValueRef) {
        name.withCString { cString in
            LLVMAddNamedMetadataOperand(llvm, cString, value.valueRef)
        }
    }

    /// Return the directory of the debug location for this value, which must be
    /// an llvm Instruction, llvm GlobalVariable, or llvm Function.
    public func getDebugLocDirectory(value: ValueRef) -> String? {
        var length: UInt32 = 0
        guard let cString = LLVMGetDebugLocDirectory(value.valueRef, &length) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Return the filename of the debug location for this value, which must be
    /// an llvm Instruction, llvm GlobalVariable, or llvm Function.
    public func getDebugLocFilename(value: ValueRef) -> String? {
        var length: UInt32 = 0
        guard let cString = LLVMGetDebugLocFilename(value.valueRef, &length) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Return the line number of the debug location for this value, which must be
    /// an llvm Instruction, llvm GlobalVariable, or llvm Function.
    public func getDebugLocLine(value: ValueRef) -> UInt32 {
        LLVMGetDebugLocLine(value.valueRef)
    }

    /// Return the column number of the debug location for this value, which must be
    /// an llvm Instruction.
    public func getDebugLocColumn(value: ValueRef) -> UInt32 {
        LLVMGetDebugLocColumn(value.valueRef)
    }

    /// Add a function to a module under a specified name.
    public func addFunction(name: String, functionType: TypeRef) -> ValueRef? {
        guard let value = name.withCString({ cString in
            LLVMAddFunction(llvm, cString, functionType.typeRef)
        }) else { return nil }
        return Value(llvm: value)
    }

    /// Obtain a Function value from a Module by its name.
    ///
    /// The returned value corresponds to a llvm::Function value.
    public func getNamedFunction(name: String) -> ValueRef? {
        guard let value = name.withCString({ cString in
            LLVMGetNamedFunction(llvm, cString)
        }) else { return nil }
        return Value(llvm: value)
    }

    /// Obtain an iterator to the first Function in a Module.
    public func getFirstFunction() -> ValueRef? {
        guard let value = LLVMGetFirstFunction(llvm) else { return nil }
        return Value(llvm: value)
    }

    /// Obtain an iterator to the last Function in a Module.
    public func getLastFunction() -> ValueRef? {
        guard let value = LLVMGetLastFunction(llvm) else { return nil }
        return Value(llvm: value)
    }

    /// Advance a Function iterator to the next Function.
    ///
    /// Returns NULL if the iterator was already at the end and there are no more
    /// functions.
    public func getNextFunction(function: ValueRef) -> ValueRef? {
        guard let value = LLVMGetNextFunction(function.valueRef) else { return nil }
        return Value(llvm: value)
    }

    /// Decrement a Function iterator to the previous Function.
    ///
    /// Returns NULL if the iterator was already at the beginning and there are
    /// no previous functions.
    public func getPreviousFunction(function: ValueRef) -> ValueRef? {
        guard let value = LLVMGetPreviousFunction(function.valueRef) else { return nil }
        return Value(llvm: value)
    }

    /// Destroy a module instance.
    ///
    /// This must be called for every created module or memory will be leaked.
    deinit {
        LLVMDisposeModule(llvm)
    }
}
