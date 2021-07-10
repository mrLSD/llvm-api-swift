import CLLVM

/// `LabelType` represents code labels.
public struct LabelType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates an instance of the `Label` type  on the global context.
    public init() {
        llvm = LLVMLabelType()
        context = nil
    }

    /// Creates an instance of the `Label` type  in the  context.
    public init(in context: Context) {
        llvm = LLVMLabelTypeInContext(context.contextRef)
        self.context = context
    }
}

extension LabelType: Equatable {
    public static func == (lhs: LabelType, rhs: LabelType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
