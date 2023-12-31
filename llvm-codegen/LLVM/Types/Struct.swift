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
            LLVMStructTypeInContext(context.contextRef, bufferPointer.baseAddress, UInt32(elementTypes.count), isPacked ? 1 : 0)!
        }
        self.context = context
    }

    /// Create a new structure type in the global context.
    /// A structure is specified by a list of inner elements/types and
    /// whether these can be packed together.
    public init(elementTypes: [TypeRef], isPacked: Bool = false) {
        var mutElementTypes = elementTypes.map { $0.typeRef as Optional }
        llvm = mutElementTypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMStructType(bufferPointer.baseAddress, UInt32(elementTypes.count), isPacked ? 1 : 0)!
        }
        context = nil
    }

    /// Init with predefined `TypeRef` in global context
    init(typeRef: LLVMTypeRef) {
        llvm = typeRef
        context = nil
    }

    /// Determine whether a structure is opaque.
    /// Return true if this is a struct type with an identity that has an
    /// unspecified body.
    public var isOpaqueStruct: Bool {
        return LLVMIsOpaqueStruct(llvm) != 0
    }

    /// Determine whether a structure is opaque.
    public func isOpaqueStruct(ty: TypeRef) -> Bool {
        return LLVMIsOpaqueStruct(ty.typeRef) != 0
    }

    /// Determine whether a structure is packed.
    /// Returns true if this is a packed struct type.
    ///
    /// A packed struct type includes no padding between fields and is thus
    /// laid out in one contiguous region of memory with its elements laid out
    /// one after the other.  A non-packed struct type includes padding according
    /// to the data layout of the target.
    public var isPackedStruct: Bool {
        return LLVMIsPackedStruct(llvm) != 0
    }

    /// Determine whether a structure is packed.
    public func isPackedStruct(ty: TypeRef)-> Bool {
        LLVMIsPackedStruct(ty.typeRef) != 0
    }

    /// Returns true if this is a literal struct type.
    ///
    /// A literal struct type is uniqued by structural equivalence - that is,
    /// regardless of how it is named, two literal structures are equal if
    /// their fields are equal.
    public var isLiteralStruct: Bool {
        LLVMIsLiteralStruct(llvm) != 0
    }

    /// Determine whether a structure is literal.
    public func isLiteralStruct(ty: TypeRef) -> Bool {
        LLVMIsLiteralStruct(ty.typeRef) != 0
    }
}

extension StructType: Equatable {
    public static func == (lhs: StructType, rhs: StructType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
