import CLLVM

/// `X86MMXType` represents a value held in an MMX register on an x86 machine.
///
/// The operations allowed on it are quite limited: parameters and return
/// values, load and store, and bitcast. User-specified MMX instructions are
/// represented as intrinsic or asm calls with arguments and/or results of this
/// type. There are no arrays, vectors or constants of this type.
public struct X86MMXType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates an instance of the `LLVMX86MMX` type  on the global context.
    public init() {
        llvm = LLVMX86MMXType()
        context = nil
    }

    /// Creates an instance of the `LLVMX86MMX` type  in the  context.
    public init(in context: Context) {
        llvm = LLVMX86MMXTypeInContext(context.contextRef)
        self.context = context
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        llvm = typeRef.typeRef
        self.context = context
    }
}

extension X86MMXType: Equatable {
    public static func == (lhs: X86MMXType, rhs: X86MMXType) -> Bool {
        lhs.typeRef == rhs.typeRef
    }
}
