import CLLVM

/// `ArrayType` is a very simple derived type that arranges elements
/// sequentially in memory. `ArrayType` requires a size (number of elements) and
/// an underlying data type.
public struct ArrayType: TypeRef {
    private var llvm: LLVMTypeRef

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// The type of elements in this array.
    public let elementType: TypeRef

    /// Array counter kind
    public enum ArrayCountKind {
        case x32(UInt32)
        case x64(UInt64)
    }

    /// The number of elements in this array.
    public let count: ArrayCountKind

    /// Creates an array type from an underlying element type and count.
    /// Maximum size of array limited by `UInt32`
    public init(elementType: TypeRef, count: UInt32) {
        self.elementType = elementType
        self.count = .x32(count)
        self.llvm = LLVMArrayType(elementType.typeRef, count)
    }

    /// Creates an array type from an underlying element type and count.
    /// Maximum size of array limited by `UInt64`
    public init(elementType: TypeRef, count: UInt64) {
        self.elementType = elementType
        self.count = .x64(count)
        self.llvm = LLVMArrayType2(elementType.typeRef, count)
    }
}

extension ArrayType: Equatable {
    public static func == (lhs: ArrayType, rhs: ArrayType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
