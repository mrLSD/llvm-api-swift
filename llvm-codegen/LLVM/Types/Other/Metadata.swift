import CLLVM

/// The `MetadataType` type represents embedded metadata. No derived types may
/// be created from metadata except for function arguments.
public struct MetadataType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }



    /// Creates an instance of the `MetadataType` type  in the  context.
    public init(in context: Context) {
        llvm = LLVMMetadataTypeInContext(context.contextRef)
        self.context = context
    }
}

extension MetadataType: Equatable {
    public static func == (lhs: MetadataType, rhs: MetadataType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}

