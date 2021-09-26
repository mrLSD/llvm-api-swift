import CLLVM

/// `TokenType` is used when a value is associated with an instruction but all
/// uses of the value must not attempt to introspect or obscure it. As such, it
/// is not appropriate to have a `PHI` or `select` of type `TokenType`.
public struct TokenType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates an instance of the `Token` type  in the  context.
    public init(in context: Context) {
        llvm = LLVMTokenTypeInContext(context.contextRef)
        self.context = context
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        llvm = typeRef.typeRef
        self.context = context
    }
}

extension TokenType: Equatable {
    public static func == (lhs: TokenType, rhs: TokenType) -> Bool {
        lhs.typeRef == rhs.typeRef
    }
}
