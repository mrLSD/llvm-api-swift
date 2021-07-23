import CLLVM

public class FunctionType: TypeRef {
    var llvm: LLVMTypeRef

    /// Function return type.
    public let returnType: TypeRef

    public let parameterTypes: [TypeRef]

    public let isVariadic: Bool

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// For parent classes init with predefined `FunctionType` in Context
    public init(returnType: TypeRef, parameterTypes: [TypeRef], isVariadic: Bool = false) {
        var mutableParamTypes = parameterTypes.map { $0.typeRef as Optional }
        self.llvm = mutableParamTypes.withUnsafeMutableBufferPointer { paramsBuffer in
            LLVMFunctionType(returnType.typeRef, paramsBuffer.baseAddress, UInt32(parameterTypes.count), Int32(isVariadic ? 1 : 0))!
        }
        self.returnType = returnType
        self.parameterTypes = parameterTypes
        self.isVariadic = isVariadic
    }

    /// Get the Type this function Type returns.
    /// Also useful with: Types(funcReturnTy).getTypeKind, Types(funcReturnTy).getContext
    public static func getReturnType(funcType: TypeRef) -> LLVMTypeRef {
        LLVMGetReturnType(funcType.typeRef)
    }

    /// Returns whether a function type is variadic.
    public static func isFunctionVarArg(funcType: TypeRef) -> Bool {
        LLVMIsFunctionVarArg(funcType.typeRef) != 0
    }

    /// Get the number of parameters this function accepts.
    public static func countParamTypes(funcType: TypeRef) -> UInt32 {
        LLVMCountParamTypes(funcType.typeRef)
    }

    /// Get the types of a function's parameters.
    public static func getParamTypes(funcType: TypeRef) -> [LLVMTypeRef?] {
        // The Dest parameter should point to a pre-allocated array of
        // LLVMTypeRef at least LLVMCountParamTypes() large. On return, the
        // first LLVMCountParamTypes() entries in the array will be populated
        // with LLVMTypeRef instances.
        let count = Int(LLVMCountParamTypes(funcType.typeRef))
        var paramTypes = [LLVMTypeRef?](repeating: nil, count: count)
        paramTypes.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMGetParamTypes(funcType.typeRef, bufferPointer.baseAddress)
        }
        return paramTypes
    }
}

extension FunctionType: Equatable {
    public static func == (lhs: FunctionType, rhs: FunctionType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
