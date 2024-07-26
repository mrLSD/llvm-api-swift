import CLLVM

/// The `IntType` represents an integral value of a specified bit width.
///
/// The `IntType` is a very simple type that simply specifies an arbitrary bit
/// width for the integer type desired. Any bit width from 1 bit to (2^23)-1
/// (about 8 million) can be specified.
public class IntType: TypeRef {
    var llvm: LLVMTypeRef

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

    /// For parent classes init with predefined `IntType` in global context
    init(typeRef: LLVMTypeRef) {
        llvm = typeRef
        context = nil
    }

    /// For parent classes init with predefined `IntType` in Context
    init(typeRef: LLVMTypeRef, context: Context) {
        llvm = typeRef
        self.context = context
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

/// `Int1Type` int type with 1-bits (aka Bool type)
public class Int1Type: IntType {
    /// Creates an instance of the `Int1Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMInt1Type())
    }

    /// Creates an instance of the `Int1Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMInt1TypeInContext(context.contextRef), context: context)
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// `Int8Type` int type with 8-bits
public class Int8Type: IntType {
    /// Creates an instance of the `Int8Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMInt8Type())
    }

    /// Creates an instance of the `Int8Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMInt8TypeInContext(context.contextRef), context: context)
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// `Int16Type` int type with 16-bits
public class Int16Type: IntType {
    /// Creates an instance of the `Int16Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMInt16Type())
    }

    /// Creates an instance of the `Int16Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMInt16TypeInContext(context.contextRef), context: context)
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// `Int32Type` int type with 32-bits
public class Int32Type: IntType {
    /// Creates an instance of the `Int32Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMInt32Type())
    }

    /// Creates an instance of the `Int32Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMInt32TypeInContext(context.contextRef), context: context)
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// `Int64Type` int type with 64-bits
public class Int64Type: IntType {
    /// Creates an instance of the `Int64Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMInt64Type())
    }

    /// Creates an instance of the `Int64Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMInt64TypeInContext(context.contextRef), context: context)
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// `Int128Type` int type with 128-bits
public class Int128Type: IntType {
    /// Creates an instance of the `Int128Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMInt128Type())
    }

    /// Creates an instance of the `Int128Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMInt128TypeInContext(context.contextRef), context: context)
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

extension IntType: Equatable {
    public static func == (lhs: IntType, rhs: IntType) -> Bool {
        lhs.typeRef == rhs.typeRef
    }
}
