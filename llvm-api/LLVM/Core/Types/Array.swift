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
    /// The created type will exist in the context that its element type exists in.
    /// - note: Deprecated  by `llvm-c`
    @available(*, deprecated, message: "Use 64-Int size instead")
    public init(elementType: TypeRef, count: UInt32) {
        self.elementType = elementType
        self.count = .x32(count)
        llvm = LLVMArrayType(elementType.typeRef, count)
    }

    /// Creates an array type from an underlying element type and count.
    /// Maximum size of array limited by `UInt64`
    /// The created type will exist in the context that its element type exists in.
    public init(elementType: TypeRef, count: UInt64) {
        self.elementType = elementType
        self.count = .x64(count)
        llvm = LLVMArrayType2(elementType.typeRef, count)
    }

    /// Init with predefined `TypeRef`
    public init(typeRef: TypeRef) {
        elementType = ArrayType.getElementType(typeRef: typeRef)!
        count = .x64(ArrayType.getArrayLength2(typeRef: typeRef))
        llvm = typeRef.typeRef
    }

    /// Get the length of an array type for 32 bits array size.
    /// This only works on types that represent arrays.
    /// - note: Deprecated by `llvm-c`
    @available(*, deprecated, message: "Use getArrayLength2 instead, do not use 32-bit size arrays")
    public static func getArrayLength(arrayType: TypeRef) -> UInt32 {
        LLVMGetArrayLength(arrayType.typeRef)
    }

    /// Get the length of an array type for 64 bits array size - for current array
    /// This only works on types that represent arrays.
    public var getArrayLength2: UInt64 {
        Self.getArrayLength2(typeRef: self)
    }

    /// Get the length of an array type for 64 bits array size.
    /// This only works on types that represent arrays.
    public static func getArrayLength2(typeRef: TypeRef) -> UInt64 {
        LLVMGetArrayLength2(typeRef.typeRef)
    }

    /// Get the element type of the current array  type.
    public var getElementType: TypeRef? {
        Self.getElementType(typeRef: self)
    }

    /// Get the element type of an array  type.
    public static func getElementType(typeRef: TypeRef) -> TypeRef? {
        guard let newTypeRef = LLVMGetElementType(typeRef.typeRef) else { return nil }
        return Types(llvm: newTypeRef)
    }

    /// Return the number of types in the derived type for the current array.
    public var getNumContainedTypes: UInt32 {
        Self.getNumContainedTypes(typeRef: self)
    }

    /// Return the number of types in the derived type.
    public static func getNumContainedTypes(typeRef: TypeRef) -> UInt32 {
        LLVMGetNumContainedTypes(typeRef.typeRef)
    }

    /// Returns type's subtypes for the current array
    public var getSubtypes: [TypeRef] {
        Self.getSubtypes(typeRef: self)
    }

    /// Returns type's subtypes
    public static func getSubtypes(typeRef: TypeRef) -> [TypeRef] {
        let subtypeCount = ArrayType.getNumContainedTypes(typeRef: typeRef)
        var subtypes = [LLVMTypeRef?](repeating: nil, count: Int(subtypeCount))
        subtypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMGetSubtypes(typeRef.typeRef, bufferPointer.baseAddress)
        }
        return subtypes.map { Types(llvm: $0!) }
    }
}

extension ArrayType: Equatable {
    public static func == (lhs: ArrayType, rhs: ArrayType) -> Bool {
        lhs.typeRef == rhs.typeRef
    }
}
