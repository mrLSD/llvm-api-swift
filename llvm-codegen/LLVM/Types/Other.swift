
import CLLVM

public struct OtherType: TypeRef {
    let llvm: LLVMTypeRef

    /// Retrieves the underlying LLVM value object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates a `OtherType` from an `LLVMTypeRef` object.
    public init(llvm: LLVMTypeRef) {
        self.llvm = llvm
    }

    /// Create a metadata type in a context.
    public func metadataTypeInContext(context: ContextRef) -> OtherType {
        OtherType(llvm: LLVMMetadataTypeInContext(context.contextRef))
    }

    /// Create a token type in a context.
    public func tokenTypeInContext(context: ContextRef) -> OtherType {
        OtherType(llvm: LLVMTokenTypeInContext(context.contextRef))
    }

    //    /// Create a target extension type in LLVM context.
    //    public func targetExtTypeInContext(context: ContextRef, name: String, typeParams:  TypeRef,  typeParamCount: UInt32, intParams:  [UInt32]?,  intParamCount: UInt32) -> OtherType
    //    {
    //        OtherType(llvm: LLVMTargetExtTypeInContext(context.contextRef, name, typeParams, typeParamCount, intParams, intParamCount))
    //    }
}
