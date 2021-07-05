import CLLVM

public struct VoidType: TypeRef {
    let llvm: LLVMTypeRef
    public var typeRef: LLVMTypeRef { llvm }

    /// Operate on the global context.
    public init() {
        self.llvm = LLVMVoidType()
    }

    /// Create a void type in a context.
    public init(context: ContextRef) {
        self.llvm = LLVMVoidTypeInContext(context.contextRef)
    }
}
