import CLLVM

/// `X86AMXType` represents a value held in an AMX on an x86 machine.
public struct X86AMXType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates an instance of the `X86AMX` type  on the global context.
    public init() {
        llvm = LLVMX86AMXType()
        context = nil
    }

    /// Creates an instance of the `X86AMX` type  in the  context.
    public init(in context: Context) {
        llvm = LLVMX86AMXTypeInContext(context.contextRef)
        self.context = context
    }
}

extension X86AMXType: Equatable {
    public static func == (lhs: X86AMXType, rhs: X86AMXType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}

