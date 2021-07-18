import CLLVM

/// The `IntType` represents an integral value of a specified bit width.
///
/// The `IntType` is a very simple type that simply specifies an arbitrary bit
/// width for the integer type desired. Any bit width from 1 bit to (2^23)-1
/// (about 8 million) can be specified.
public struct IntType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Get `IntType` width for current type instance
    public var getIntTypeWidth: UInt32 { LLVMGetIntTypeWidth(llvm) }

    /// Get `IntType` width for  type instance from parameter
    public static func getIntTypeWidth(ty: TypeRef) -> UInt32 {
        LLVMGetIntTypeWidth(ty.typeRef)
    }

    /// Creates an instance of the `IntType` type  on the global context.
    public init(bits: UInt32) {
        llvm = LLVMIntType(bits)
        context = nil
    }

    /// Creates an instance of the `IntType` type  in the  context.
    public init(bits: UInt32, in context: Context) {
        llvm = LLVMIntTypeInContext(context.contextRef, bits)
        self.context = context
    }
}
