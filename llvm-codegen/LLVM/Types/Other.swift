
import CLLVM

public struct OtherType {
    let llvm: LLVMTypeRef

    /// Retrieves the underlying LLVM value object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates a `OtherType` from an `LLVMTypeRef` object.
    public init(llvm: LLVMTypeRef) {
        self.llvm = llvm
    }

    public func labelType() -> OtherType {
        OtherType(llvm: LLVMLabelType())
    }

    /// Create a label type in a context.
    public func labelTypeInContext(context: ContextRef) -> OtherType {
        OtherType(llvm: LLVMLabelTypeInContext(context.contextRef))
    }

    /// Create a metadata type in a context.
    public func metadataTypeInContext(context: ContextRef) -> OtherType {
        OtherType(llvm: LLVMMetadataTypeInContext(context.contextRef))
    }

    /// Create a token type in a context.
    public func tokenTypeInContext(context: ContextRef) -> OtherType {
        OtherType(llvm: LLVMTokenTypeInContext(context.contextRef))
    }

    /// These are similar to the above functions except they operate on the global context.
    public func voidType() -> OtherType {
        OtherType(llvm: LLVMVoidType())
    }

    /// Create a void type in a context.
    public func voidTypeInContext(context: ContextRef) -> OtherType {
        OtherType(llvm: LLVMVoidTypeInContext(context.contextRef))
    }

    public func x86AMXType()
        -> OtherType
    {
        OtherType(llvm: LLVMX86AMXType())
    }

    /// Create a X86 AMX type in a context.
    public func x86AMXTypeInContext(context: ContextRef)
        -> OtherType
    {
        OtherType(llvm: LLVMX86AMXTypeInContext(context.contextRef))
    }

    public func x86MMXType()
        -> OtherType
    {
        OtherType(llvm: LLVMX86MMXType())
    }

    /// Create a X86 MMX type in a context.
    public func x86MMXTypeInContext(context: ContextRef) -> OtherType {
        OtherType(llvm: LLVMX86MMXTypeInContext(context.contextRef))
    }

    //    /// Create a target extension type in LLVM context.
    //    public func targetExtTypeInContext(context: ContextRef, name: String, typeParams:  TypeRef,  typeParamCount: UInt32, intParams:  [UInt32]?,  intParamCount: UInt32) -> OtherType
    //    {
    //        OtherType(llvm: LLVMTargetExtTypeInContext(context.contextRef, name, typeParams, typeParamCount, intParams, intParamCount))
    //    }
}
