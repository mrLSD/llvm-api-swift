import CLLVM

/// The `Void` type represents empty value and has no size.
public struct VoidType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates an instance of the `Void` type  on the global context.
    public init() {
        llvm = LLVMVoidType()
        context = nil
    }

    /// Creates an instance of the `Void` type  in the  context.
    public init(in context: Context) {
        llvm = LLVMVoidTypeInContext(context.contextRef)
        self.context = context
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        llvm = typeRef.typeRef
        self.context = context
    }
}

extension VoidType: Equatable {
    public static func == (lhs: VoidType, rhs: VoidType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
