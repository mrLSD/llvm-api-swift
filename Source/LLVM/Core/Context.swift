import CLLVM

/// A `Context` is an LLVM compilation session environment.
/// - SeeAlso: https://llvm.org/docs/ProgrammersManual.html#achieving-isolation-with-llvmcontext
///
/// A `Context` is a container for the global state of an execution of the
/// LLVM environment and tooling.  It contains independent copies of global and
/// module-level entities like types, metadata attachments, and constants.
///
/// An LLVM context is needed for interacting with LLVM in a concurrent
/// environment. Because a context maintains state independent of any other
/// context, it is recommended that each thread of execution be assigned a unique
/// context.  LLVM's core infrastructure and API provides no locking guarantees
/// and no atomicity guarantees.
public final class Context: ContextRef {
    private let llvm: LLVMContextRef

    /// Retrieves the underlying LLVM type object.
    public var contextRef: LLVMContextRef { llvm }

    /// Diagnostic handler type
    public typealias DiagnosticHandler = @convention(c) (LLVMDiagnosticInfoRef?, UnsafeMutableRawPointer?) -> Void

    public typealias YieldCallback = @convention(c) (LLVMContextRef?, UnsafeMutableRawPointer?) -> Void

    /// Retrieves the global context instance.
    ///
    /// The global context is an particularly convenient instance managed by LLVM
    /// itself.  It is the default context provided for any operations that
    /// require it.
    ///
    /// - WARNING: Failure to specify the correct context in concurrent
    ///   environments can lead to data corruption.  In general, it is always
    ///   recommended that each thread of execution attempting to access the LLVM
    ///   API have its own `Context` instance, rather than rely on this global
    ///   context.
    @MainActor
    public static let global = Context(llvm: LLVMGetGlobalContext()!)

    /// Creates a new `Context` object.
    public init() {
        llvm = LLVMContextCreate()
    }

    /// Creates a `Context` object from an `LLVMContextRef` object.
    public init(llvm: LLVMContextRef) {
        self.llvm = llvm
    }

    /// Get the diagnostic handler of current context.
    public var getDiagnosticHandler: DiagnosticHandler? {
        LLVMContextGetDiagnosticHandler(llvm)
    }

    /// Set the diagnostic handler for current context.
    public func setDiagnosticHandler(handler: DiagnosticHandler?, diagnosticContext: UnsafeMutableRawPointer?) {
        LLVMContextSetDiagnosticHandler(llvm, handler.self, diagnosticContext)
    }

    /// Retrieve whether the given context is set to discard all value names.
    public func shouldDiscardValueNames() -> Bool {
        LLVMContextShouldDiscardValueNames(llvm) != 0
    }

    /// Set whether the given context discards all value names.
    /// If true, only the names of GlobalValue objects will be available in the IR.
    /// This can be used to save memory and runtime, especially in release mode.
    public func setDiscardValueNames(discard: Bool) {
        LLVMContextSetDiscardValueNames(llvm, discard.llvm)
    }

    /// Returns whether the given context is set to discard all value names.
    ///
    /// If true, only the names of GlobalValue objects will be available in
    /// the IR.  This can be used to save memory and processing time, especially
    /// in release environments.
    public var discardValueNames: Bool {
        get {
            // Retrieve whether the given context is set to discard all value names.
            shouldDiscardValueNames()
        }
        set {
            // Set whether the given context discards all value names.
            setDiscardValueNames(discard: newValue)
        }
    }

    /// Get the diagnostic context of this context.
    public func getDiagnosticContext() -> UnsafeMutableRawPointer {
        LLVMContextGetDiagnosticContext(llvm)
    }

    /// Set the yield callback function for this context.
    public func setYieldCallback(callback: YieldCallback?, opaqueHandle: UnsafeMutableRawPointer?) {
        LLVMContextSetYieldCallback(llvm, callback, opaqueHandle)
    }

    /// Return a string representation of the DiagnosticInfo. Use
    /// `Core.disposeMessage` (`LLVMDisposeMessage`) to free the string.
    public static func getDiagInfoDescription(diagnosticInfo: DiagnosticInfoRef) -> String? {
        guard let cString = LLVMGetDiagInfoDescription(diagnosticInfo.diagnosticInfoRef) else { return nil }
        defer { Core.disposeMessage(cString) }
        return String(cString: cString)
    }

    /// Return an enum LLVMDiagnosticSeverity.
    public static func getDiagInfoSeverity(diagnosticInfo: DiagnosticInfoRef) -> DiagnosticSeverity? {
        DiagnosticSeverity(from: LLVMGetDiagInfoSeverity(diagnosticInfo.diagnosticInfoRef))
    }

    /// Get  Metadata KindId by name in current Context.
    /// Useful for working with Metadata
    public func getMDKindIDInContext(name: String) -> UInt32 {
        name.withCString { cString in
            LLVMGetMDKindIDInContext(llvm, cString, UInt32(name.utf8.count))
        }
    }

    public static func getMDKindID(name: String) -> UInt32 {
        name.withCString { cString in
            LLVMGetMDKindID(cString, UInt32(name.utf8.count))
        }
    }

    /// Return an unique id given the name of a enum attribute,
    /// or 0 if no attribute by that name exists.
    ///
    /// See http://llvm.org/docs/LangRef.html#parameter-attributes
    /// and http://llvm.org/docs/LangRef.html#function-attributes
    /// for the list of available attributes.
    ///
    /// NB: Attribute names and/or id are subject to change without
    /// going through the C API deprecation cycle.
    public static func getEnumAttributeKindForName(name: String) -> UInt32 {
        name.withCString { cString in
            LLVMGetEnumAttributeKindForName(cString, name.utf8.count)
        }
    }

    /// Get last enum attribute
    public static func getLastEnumAttributeKind() -> UInt32 {
        LLVMGetLastEnumAttributeKind()
    }

    struct Attribute: AttributeRef {
        var attributeRef: LLVMAttributeRef
    }

    /// Create an enum attribute.
    public func createEnumAttribute(kindID: UInt32, value: UInt64) -> AttributeRef? {
        guard let attributeRef = LLVMCreateEnumAttribute(llvm, kindID, value) else { return nil }
        return Attribute(attributeRef: attributeRef)
    }

    /// Get the unique id corresponding to the enum attribute passed as argument.
    public static func getEnumAttributeKind(attributeRef: AttributeRef) -> UInt32 {
        LLVMGetEnumAttributeKind(attributeRef.attributeRef)
    }

    /// Get the enum attribute's value. 0 is returned if none exists.
    public static func getEnumAttributeValue(attributeRef: AttributeRef) -> UInt64 {
        LLVMGetEnumAttributeValue(attributeRef.attributeRef)
    }

    /// Create a type attribute
    public func createTypeAttribute(kindID: UInt32, typeRef: TypeRef) -> AttributeRef? {
        guard let attributeRef = LLVMCreateTypeAttribute(llvm, kindID, typeRef.typeRef) else { return nil }
        return Attribute(attributeRef: attributeRef)
    }

    /// Get the type attribute's value.
    public static func getTypeAttributeValue(attributeRef: AttributeRef) -> TypeRef? {
        guard let typeRef = LLVMGetTypeAttributeValue(attributeRef.attributeRef) else { return nil }
        return Types(llvm: typeRef)
    }

    /// Create a string attribute.
    public func createStringAttribute(key: String, value: String) -> AttributeRef? {
        let attribute = key.withCString { keyCString in
            value.withCString { valueCString in
                LLVMCreateStringAttribute(llvm, keyCString, UInt32(key.utf8.count), valueCString, UInt32(value.utf8.count))
            }
        }
        guard let attributeRef = attribute else { return nil }
        return Attribute(attributeRef: attributeRef)
    }

    /// Get the string attribute's kind.
    public static func getStringAttributeKind(attributeRef: AttributeRef) -> String? {
        var length: UInt32 = 0
        guard let cString = LLVMGetStringAttributeKind(attributeRef.attributeRef, &length) else { return nil }
        return String(cString: cString)
    }

    /// Get the string attribute's value.
    public static func getStringAttributeValue(attributeRef: AttributeRef) -> String? {
        var length: UInt32 = 0
        guard let cString =
            LLVMGetStringAttributeValue(attributeRef.attributeRef, &length) else { return nil }
        return String(cString: cString)
    }

    /// Check for the  types of attributes.
    public static func isEnumAttribute(attributeRef: AttributeRef) -> Bool {
        LLVMIsEnumAttribute(attributeRef.attributeRef) != 0
    }

    /// Check for the  types of attributes.
    public static func isStringAttribute(attributeRef: AttributeRef) -> Bool {
        LLVMIsStringAttribute(attributeRef.attributeRef) != 0
    }

    /// Check for the  types of attributes.
    public static func isTypeAttribute(attributeRef: AttributeRef) -> Bool {
        LLVMIsTypeAttribute(attributeRef.attributeRef) != 0
    }

    /// Obtain a Type from a context by its registered name.
    public func getTypeByName2(name: String) -> TypeRef? {
        name.withCString { cString in
            guard let typeRef = LLVMGetTypeByName2(llvm, cString) else { return nil }
            return Types(llvm: typeRef)
        }
    }

    /// Destroy a context instance.
    ///
    /// This should be called for every call to LLVMContextCreate() or memory will be leaked.
    public func dispose() {
        LLVMContextDispose(llvm)
    }

    /// Deinitialize this value and dispose of its resources.
    ///
    /// Destroy a context instance.
    /// This should be called for every call to LLVMContextCreate() or memory
    /// will be leaked.
    deinit {
        self.dispose()
    }
}
