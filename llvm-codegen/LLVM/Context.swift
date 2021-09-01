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
public class Context: ContextRef {
    private let llvm: LLVMContextRef

    /// Retrieves the underlying LLVM type object.
    public var contextRef: LLVMContextRef { llvm }

    /// Diagnostic handler type
    public typealias DiagnosticHandler = @convention(c) (LLVMDiagnosticInfoRef, UnsafeMutableRawPointer?) -> Void

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
        if let handler = LLVMContextGetDiagnosticHandler(contextRef) {
            return unsafeBitCast(handler, to: DiagnosticHandler.self)
        } else {
            return nil
        }
    }

    /// Set the diagnostic handler for current context.
    public func setDiagnosticHandler(handler: LLVMDiagnosticHandler?, diagnosticContext: UnsafeMutableRawPointer?) {
        LLVMContextSetDiagnosticHandler(contextRef, handler, diagnosticContext)
    }

    /// Retrieve whether the given context is set to discard all value names.
    public func shouldDiscardValueNames() -> Bool {
        return LLVMContextShouldDiscardValueNames(llvm) != 0
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
            return shouldDiscardValueNames()
        }
        set {
            // Set whether the given context discards all value names.
            setDiscardValueNames(discard: newValue)
        }
    }

//=========
    /// Get the diagnostic context of this context.
    public func getDiagnosticContext(){
// void *LLVMContextGetDiagnosticContext(LLVMContextRef C);
    }

    /// Set the yield callback function for this context.
    public func setYieldCallback() {
      //  void LLVMContextSetYieldCallback(LLVMContextRef C, LLVMYieldCallback Callback,
    }

    /// Return a string representation of the DiagnosticInfo. Use
    /// LLVMDisposeMessage to free the string.
    public func getDiagInfoDescription(){
        // char *LLVMGetDiagInfoDescription(LLVMDiagnosticInfoRef DI);
    }

    ///  Return an enum LLVMDiagnosticSeverity.
    public func getDiagInfoSeverity() {
// LLVMDiagnosticSeverity LLVMGetDiagInfoSeverity(LLVMDiagnosticInfoRef DI);
    }

    public func getMDKindIDInContext(){
       // unsigned LLVMGetMDKindIDInContext(LLVMContextRef C, const char *Name,
    }

    public func getMDKindID(){
    // unsigned LLVMGetMDKindID(const char *Name, unsigned SLen);
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
    public func getEnumAttributeKindForName(){
        // unsigned LLVMGetEnumAttributeKindForName(const char *Name, size_t SLen);

    }

    public func getLastEnumAttributeKind (){
        // unsigned LLVMGetLastEnumAttributeKind(void);
    }

    public func
    public func
    public func
    public func
    public func
    public func
    public func
    public func
    public func
    public func
    public func

//========================================
    /**
     * Create an enum attribute.
     */
    LLVMAttributeRef LLVMCreateEnumAttribute(LLVMContextRef C, unsigned KindID,
                                             uint64_t Val);

    /**
     * Get the unique id corresponding to the enum attribute
     * passed as argument.
     */
    unsigned LLVMGetEnumAttributeKind(LLVMAttributeRef A);

    /**
     * Get the enum attribute's value. 0 is returned if none exists.
     */
    uint64_t LLVMGetEnumAttributeValue(LLVMAttributeRef A);

    /**
     * Create a type attribute
     */
    LLVMAttributeRef LLVMCreateTypeAttribute(LLVMContextRef C, unsigned KindID,
                                             LLVMTypeRef type_ref);

    /**
     * Get the type attribute's value.
     */
    LLVMTypeRef LLVMGetTypeAttributeValue(LLVMAttributeRef A);

    /**
     * Create a string attribute.
     */
    LLVMAttributeRef LLVMCreateStringAttribute(LLVMContextRef C,
                                               const char *K, unsigned KLength,
                                               const char *V, unsigned VLength);

    /**
     * Get the string attribute's kind.
     */
    const char *LLVMGetStringAttributeKind(LLVMAttributeRef A, unsigned *Length);

    /**
     * Get the string attribute's value.
     */
    const char *LLVMGetStringAttributeValue(LLVMAttributeRef A, unsigned *Length);

    /**
     * Check for the different types of attributes.
     */
    LLVMBool LLVMIsEnumAttribute(LLVMAttributeRef A);
    LLVMBool LLVMIsStringAttribute(LLVMAttributeRef A);
    LLVMBool LLVMIsTypeAttribute(LLVMAttributeRef A);

    /**
     * Obtain a Type from a context by its registered name.
     */
    LLVMTypeRef LLVMGetTypeByName2(LLVMContextRef C, const char *Name);


    /// Deinitialize this value and dispose of its resources.
    ///
    /// Destroy a context instance.
    /// This should be called for every call to LLVMContextCreate() or memory
    /// will be leaked.
    deinit {
        LLVMContextDispose(llvm)
    }
}
