import CLLVM

/// A `VectorType` is a simple derived type that represents a vector of
/// elements. `VectorType`s are used when multiple primitive data are operated
/// in parallel using a single instruction (SIMD). A vector type requires a size
/// (number of elements) and an underlying primitive data type.
public struct VectorType: TypeRef {
    private var llvm: LLVMTypeRef

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// The type of elements in this array.
    public let elementType: TypeRef

    /// The number of elements in this vector.
    public let count: UInt32

    /// Create a vector type that contains a defined type and has a specific number of elements.
    /// The created type will exist in the context thats its element type exists in.
    public init(elementType: TypeRef, count: UInt32) {
        self.elementType = elementType
        self.count = count
        self.llvm = LLVMVectorType(elementType.typeRef, count)
    }

    /// Init with predefined `TypeRef`
    public init(typeRef: TypeRef) {
        self.elementType = VectorType.getElementType(vecType: typeRef)
        self.count = VectorType.getVectorSize(vecType: typeRef)
        self.llvm = typeRef.typeRef
    }

    /// Get the (possibly scalable) number of elements in a vector type.
    /// This only works on types that represent vectors (fixed or scalable).
    public static func getVectorSize(vecType: TypeRef) -> UInt32 {
        LLVMGetVectorSize(vecType.typeRef)
    }

    /// Get the element type of an vector  type.
    public static func getElementType(vecType: TypeRef) -> TypeRef {
        Types(typeRef: LLVMGetElementType(vecType.typeRef)!)
    }

    /// Returns type's subtypes
    public static func getSubtypes(vecType: TypeRef) -> [TypeRef] {
        let subtypeCount = LLVMGetNumContainedTypes(vecType.typeRef)
        var subtypes = [LLVMTypeRef?](repeating: nil, count: Int(subtypeCount))
        subtypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMGetSubtypes(vecType.typeRef, bufferPointer.baseAddress)
        }
        return subtypes.map { Types(typeRef: $0!) }
    }
}

extension VectorType: Equatable {
    public static func == (lhs: VectorType, rhs: VectorType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
