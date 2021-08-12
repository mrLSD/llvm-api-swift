import CLLVM

/// `StructType` is used to represent a collection of data members together in
/// memory. The elements of a structure may be any type that has a size.
///
/// Structures in memory are accessed using `load` and `store` by getting a
/// pointer to a field with the ‘getelementptr‘ instruction. Structures in
/// registers are accessed using the `extractvalue` and `insertvalue`
/// instructions.
///
/// Structures may optionally be "packed" structures, which indicate that the
/// alignment of the struct is one byte, and that there is no padding between
/// the elements. In non-packed structs, padding between field types is inserted
/// as defined by the `DataLayout` of the module, which is required to match
/// what the underlying code generator expects.
///
/// Structures can either be "literal" or "identified". A literal structure is
/// defined inline with other types (e.g. {i32, i32}*) whereas identified types
/// are always defined at the top level with a name. Literal types are uniqued
/// by their contents and can never be recursive or opaque since there is no way
/// to write one. Identified types can be recursive, can be opaqued, and are
/// never uniqued.
public struct StructType: TypeRef {
    var llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Create a new structure type in a context.
    /// A structure is specified by a list of inner elements/types and
    /// whether these can be packed together.
    public init(in context: Context, elementTypes: [TypeRef], isPacked: Bool = false) {
        var mutElementTypes = elementTypes.map { $0.typeRef as Optional }
        llvm = mutElementTypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMStructTypeInContext(context.contextRef, bufferPointer.baseAddress, UInt32(elementTypes.count), isPacked.llvm)!
        }
        self.context = context
    }

    /// Create a new structure type in the global context.
    /// A structure is specified by a list of inner elements/types and
    /// whether these can be packed together.
    public init(elementTypes: [TypeRef], isPacked: Bool = false) {
        var mutElementTypes = elementTypes.map { $0.typeRef as Optional }
        llvm = mutElementTypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMStructType(bufferPointer.baseAddress, UInt32(elementTypes.count), isPacked.llvm)!
        }
        context = nil
    }

    /// Init with predefined `TypeRef` in global context
    init(typeRef: TypeRef) {
        llvm = typeRef.typeRef
        context = nil
    }

    /// Determine whether a structure is opaque.
    /// Return true if this is a struct type with an identity that has an
    /// unspecified body.
    public var isOpaqueStruct: Bool {
        Self.isOpaqueStruct(typeRef: self)
    }

    /// Determine whether a structure is opaque.
    public static func isOpaqueStruct(typeRef: TypeRef) -> Bool {
        return LLVMIsOpaqueStruct(typeRef.typeRef) != 0
    }

    /// Determine whether a structure is packed.
    /// Returns true if this is a packed struct type.
    ///
    /// A packed struct type includes no padding between fields and is thus
    /// laid out in one contiguous region of memory with its elements laid out
    /// one after the other.  A non-packed struct type includes padding according
    /// to the data layout of the target.
    public var isPackedStruct: Bool {
        Self.isPackedStruct(typeRef: self)
    }

    /// Determine whether a structure is packed.
    public static func isPackedStruct(typeRef: TypeRef) -> Bool {
        LLVMIsPackedStruct(typeRef.typeRef) != 0
    }

    /// Returns true if this is a literal struct type.
    ///
    /// A literal struct type is uniqued by structural equivalence - that is,
    /// regardless of how it is named, two literal structures are equal if
    /// their fields are equal.
    public var isLiteralStruct: Bool {
        Self.isLiteralStruct(typeRef: self)
    }

    /// Determine whether a structure is literal.
    public static func isLiteralStruct(typeRef: TypeRef) -> Bool {
        LLVMIsLiteralStruct(typeRef.typeRef) != 0
    }

    /// Get the type of the element at a given index in the current structure.
    public func getTypeAtIndex(index: UInt32) -> TypeRef {
        Self.structGetTypeAtIndex(typeRef: self, index: index)
    }

    /// Get the type of the element at a given index in the structure.
    public static func structGetTypeAtIndex(typeRef: TypeRef, index: UInt32) -> TypeRef {
        Types(llvm: LLVMStructGetTypeAtIndex(typeRef.typeRef, index)!)
    }

    /// Obtain the name of the current structure.
    public var getStructName: String {
        Self.getStructName(typeRef: self)
    }

    /// Obtain the name of a structure.
    public static func getStructName(typeRef: TypeRef) -> String {
        guard let cString = LLVMGetStructName(typeRef.typeRef) else { return "" }
        return String(cString: cString)
    }

    /// Set the contents of the current structure.
    public func setBody(elementTypes: [TypeRef], isPacked: Bool = false) {
        StructType.structSetBody(typeRef: self, elementTypes: elementTypes, isPacked: isPacked)
    }

    /// Set the contents of the structure.
    public static func structSetBody(typeRef: TypeRef, elementTypes: [TypeRef], isPacked: Bool = false) {
        var mutElementTypes = elementTypes.map { $0.typeRef as Optional }
        mutElementTypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMStructSetBody(typeRef.typeRef, bufferPointer.baseAddress, UInt32(elementTypes.count), isPacked.llvm)
        }
    }

    // Get the number of elements defined inside the current structure.
    public var countStructElementTypes: UInt32 {
        Self.countStructElementTypes(typeRef: self)
    }

    /// Get the number of elements defined inside the structure.
    public static func countStructElementTypes(typeRef: TypeRef) -> UInt32 {
        LLVMCountStructElementTypes(typeRef.typeRef)
    }

    ///  Get the elements within current structure.
    public var structElementTypes: [TypeRef] {
        Self.structElementTypes(typeRef: self)
    }

    ///  Get the elements within a structure.
    ///
    /// The function is passed the address of a pre-allocated array of
    /// LLVMTypeRef at least LLVMCountStructElementTypes() long. After
    /// invocation, this array will be populated with the structure's
    /// elements. The objects in the destination array will have a lifetime
    /// of the structure type itself, which is the lifetime of the context it
    /// is contained in.
    public static func structElementTypes(typeRef: TypeRef) -> [TypeRef] {
        let elementCount = Self.countStructElementTypes(typeRef: typeRef)
        var elementTypes = [LLVMTypeRef?](repeating: nil, count: Int(elementCount))
        elementTypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMGetStructElementTypes(typeRef.typeRef, bufferPointer.baseAddress)
        }
        return elementTypes.map { Types(llvm: $0!) }
    }
}

extension StructType: Equatable {
    public static func == (lhs: StructType, rhs: StructType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
