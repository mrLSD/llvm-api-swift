import CLLVM

/// This section contains APIs for interacting with LLVMValueRef that correspond to llvm::Constant instances. More...
public enum Constants {
    /// Obtain a constant value referring to the null instance of a type.
    public static func constNull(typeRef: TypeRef) -> Value? {
        guard let valueRef = LLVMConstNull(typeRef.typeRef) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant value referring to the instance of a type consisting of all ones.
    /// This is only valid for integer types.
    public static func constAllOnes(typeRef: TypeRef) -> Value? {
        guard let valueRef = LLVMConstAllOnes(typeRef.typeRef) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant value referring to an undefined value of a type.
    public static func getUndef(typeRef: TypeRef) -> Value? {
        guard let valueRef = LLVMGetUndef(typeRef.typeRef) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant value referring to a poison value of a type.
    public static func getPoison(typeRef: TypeRef) -> Value? {
        guard let valueRef = LLVMGetPoison(typeRef.typeRef) else { return nil }
        return Value(llvm: valueRef)
    }

    // Determine whether a value instance is null.
    public static func constPointerNull(valueRef: ValueRef) -> Bool {
        LLVMIsNull(valueRef.valueRef) != 0
    }

    /// Obtain a constant that is a constant pointer pointing to NULL for a specified type.
    public static func constPointerNull(typeRef: TypeRef) -> Value? {
        guard let valueRef = LLVMConstPointerNull(typeRef.typeRef) else { return nil }
        return Value(llvm: valueRef)
    }
}
