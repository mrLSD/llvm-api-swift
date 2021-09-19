import CLLVM

/// `FloatingType`  representations of a floating value of a particular
/// bit width and semantics.
public class FloatingType: TypeRef {
    var llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// For parent classes init with predefined `FloatType` in global context
    init(typeRef: LLVMTypeRef) {
        llvm = typeRef
        context = nil
    }

    /// For parent classes init with predefined `FloatType` in Context
    init(typeRef: LLVMTypeRef, context: Context) {
        llvm = typeRef
        self.context = context
    }
}

/// 16-bit floating point type
public class HalfType: FloatingType {
    /// Creates an instance of the `HalfType` type  in the global context.
    public init() {
        super.init(typeRef: LLVMHalfType())
    }

    /// Creates an instance of the `HalfType` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMHalfTypeInContext(context.contextRef))
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// 16-bit brain floating point type
public class BFloatType: FloatingType {
    /// Creates an instance of the `BFloatType` type  in the global context.
    public init() {
        super.init(typeRef: LLVMBFloatType())
    }

    /// Creates an instance of the `BFloatType` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMBFloatTypeInContext(context.contextRef))
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// 32-bit floating point type
public class FloatType: FloatingType {
    /// Creates an instance of the `FloatType` type  in the global context.
    public init() {
        super.init(typeRef: LLVMFloatType())
    }

    /// Creates an instance of the `FloatType` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMFloatTypeInContext(context.contextRef))
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// 64-bit floating point type
public class DoubleType: FloatingType {
    /// Creates an instance of the `DoubleType` type  in the global context.
    public init() {
        super.init(typeRef: LLVMDoubleType())
    }

    /// Creates an instance of the `DoubleType` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMDoubleTypeInContext(context.contextRef))
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// 80-bit floating point (X87) type
public class X86FP80Type: FloatingType {
    /// Creates an instance of the `x86FP80Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMX86FP80Type())
    }

    /// Creates an instance of the `x86FP80Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMX86FP80TypeInContext(context.contextRef))
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// 128-bit floating point (112-bit mantissa) type
public class FP128Type: FloatingType {
    /// Creates an instance of the `FP128Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMFP128Type())
    }

    /// Creates an instance of the `FP128Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMFP128TypeInContext(context.contextRef))
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

/// 128-bit floating point (two 64-bits)  type
public class PPCFP128Type: FloatingType {
    /// Creates an instance of the `PPCFP128Type` type  in the global context.
    public init() {
        super.init(typeRef: LLVMPPCFP128Type())
    }

    /// Creates an instance of the `PPCFP128Type` type  in the Context.
    public init(in context: Context) {
        super.init(typeRef: LLVMPPCFP128TypeInContext(context.contextRef))
    }

    /// Init with predefined `TypeRef` and `Context`
    public init(typeRef: TypeRef, context: Context) {
        super.init(typeRef: typeRef.typeRef, context: context)
    }
}

extension FloatingType: Equatable {
    public static func == (lhs: FloatingType, rhs: FloatingType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
