import CLLVM

/// A `VectorType` is a simple derived type that represents a vector of
/// elements. `VectorType`s are used when multiple primitive data are operated
/// in parallel using a single instruction (SIMD). A vector type requires a size
/// (number of elements) and an underlying primitive data type.
public class VectorType: TypeRef {
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
        self.elementType = VectorType.getElementType(typeRef: typeRef)!
        self.count = VectorType.getVectorSize(typeRef: typeRef)
        self.llvm = typeRef.typeRef
    }

    /// Init for pre-init vector for depended class
    init(for vecTy: LLVMTypeRef, elementType: TypeRef, count: UInt32) {
        self.elementType = elementType
        self.count = count
        self.llvm = vecTy
    }

    /// Get the (possibly scalable) number of elements in the current vector type.
    /// This only works on types that represent vectors (fixed or scalable).
    public var getVectorSize: UInt32 {
        Self.getVectorSize(typeRef: self)
    }

    /// Get the (possibly scalable) number of elements in a vector type.
    /// This only works on types that represent vectors (fixed or scalable).
    public static func getVectorSize(typeRef: TypeRef) -> UInt32 {
        LLVMGetVectorSize(typeRef.typeRef)
    }

    /// Get the element type of the currect vector  type.
    public var getElementType: TypeRef? {
        Self.getElementType(typeRef: self)
    }

    /// Get the element type of an vector  type.
    public static func getElementType(typeRef: TypeRef) -> TypeRef? {
        guard let newTypeRef = LLVMGetElementType(typeRef.typeRef) else { return nil }
        return Types(llvm: newTypeRef)
    }

    /// Returns type's subtypes for current vector
    public var getSubtypes: [TypeRef] {
        Self.getSubtypes(typeRef: self)
    }

    /// Returns type's subtypes
    public static func getSubtypes(typeRef: TypeRef) -> [TypeRef] {
        let subtypeCount = LLVMGetNumContainedTypes(typeRef.typeRef)
        var subtypes = [LLVMTypeRef?](repeating: nil, count: Int(subtypeCount))
        subtypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMGetSubtypes(typeRef.typeRef, bufferPointer.baseAddress)
        }
        return subtypes.map { Types(llvm: $0!) }
    }
}

extension VectorType: Equatable {
    public static func == (lhs: VectorType, rhs: VectorType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}

// LLVMScalableVectorType
public class ScalableVectorType: VectorType {
    /// Create a vector type that contains a defined type and has a scalable  number of elements.
    /// The created type will exist in the context thats its element type  exists in.
    override public init(elementType: TypeRef, count: UInt32) {
        let llvm = LLVMScalableVectorType(elementType.typeRef, count)!
        super.init(for: llvm, elementType: elementType, count: count)
    }

    /// Init with predefined `TypeRef`
    override public init(typeRef: TypeRef) {
        super.init(typeRef: typeRef)
    }
}
