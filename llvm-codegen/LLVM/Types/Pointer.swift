import CLLVM

/// `PointerType` is used to specify memory locations. Pointers are commonly
/// used to reference objects in memory.
///
/// `PointerType` may have an optional address space attribute defining the
/// numbered address space where the pointed-to object resides. The default
/// address space is number zero. The semantics of non-zero address spaces are
/// target-specific.
///
/// Note that LLVM does not permit pointers to void `(void*)` nor does it permit
/// pointers to labels `(label*)`.  Use `ptr` instead.
public struct PointerType: TypeRef {
    var llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Retrieves the type of the value being pointed to.
    public let pointee: TypeRef?

    /// Retrieves the address space where the pointed-to object resides.
    public let addressSpace: AddressSpace

    /// Create a  `PointerType` pointer type that points to a defined type and an optional address space.
    /// The created type will exist in the context that its pointee type exists in .
    ///
    /// - parameter pointee: The type of the pointed-to object.
    /// - parameter addressSpace: The optional address space where the pointed-to object resides.
    /// - note: The context of this type is taken from it's pointee
    public init(pointee: TypeRef, addressSpace: AddressSpace = .zero) {
        if pointee is VoidType || pointee is LabelType {
            fatalError("Attempted to form pointer to unexpected Void or Label type - use pointer to IntType.int8 instead")
        }
        self.pointee = pointee
        self.addressSpace = addressSpace
        llvm = LLVMPointerType(pointee.typeRef, UInt32(addressSpace.rawValue))
        context = nil
    }

    /// Create an opaque pointer type in a context.
    public init(in context: Context, addressSpace: AddressSpace = .zero) {
        pointee = nil
        self.addressSpace = addressSpace
        llvm = LLVMPointerTypeInContext(context.contextRef, UInt32(addressSpace.rawValue))
        self.context = context
    }

    /// Determine whether a pointer is opaque.
    /// True if this is an instance of an opaque PointerType.
    public var pointerTypeIsOpaque: Bool {
        Self.pointerTypeIsOpaque(typeRef: Types(llvm: llvm))
    }

    /// Determine whether a pointer is opaque.
    /// True if this is an instance of an opaque PointerType.
    public static func pointerTypeIsOpaque(typeRef: TypeRef) -> Bool {
        LLVMPointerTypeIsOpaque(typeRef.typeRef) != 0
    }

    /// Get the address space of a pointer type.
    /// This only works on types that represent pointers.
    public var getPointerAddressSpace: AddressSpace {
        Self.getPointerAddressSpace(typeRef: Types(llvm: llvm))
    }

    /// Get the address space of a pointer type.
    /// This only works on types that represent pointers.
    public static func getPointerAddressSpace(typeRef: TypeRef) -> AddressSpace {
        AddressSpace(LLVMGetPointerAddressSpace(typeRef.typeRef))
    }

    // Get the element type of an Pointer  type.
    public var getElementType: TypeRef {
        Self.getElementType(typeRef: Types(llvm: llvm))
    }

    /// Get the element type of an Pointer  type.
    public static func getElementType(typeRef: TypeRef) -> TypeRef {
        Types(llvm: LLVMGetElementType(typeRef.typeRef)!)
    }
}

extension PointerType: Equatable {
    public static func == (lhs: PointerType, rhs: PointerType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
