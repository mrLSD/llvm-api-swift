import CLLVM

/// Functions in this group model ValueRef instances that correspond to constants referring to scalar types.
public enum ScalarConstants {
    /// Obtain a constant value for an integer type.
    public static func constInt(intTy: TypeRef, n: UInt64, signExtend: Bool) -> Value? {
        guard let valueRef = LLVMConstInt(intTy.typeRef, n, signExtend.llvm) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant value for an integer of arbitrary precision.
    public static func constIntOfArbitraryPrecision(intType: TypeRef, words: [UInt64]) -> Value? {
        let numWords = UInt32(words.count)
        let val = words.withUnsafeBufferPointer { bufferPointer in
            LLVMConstIntOfArbitraryPrecision(intType.typeRef, numWords, bufferPointer.baseAddress)
        }
        guard let valueRef = val else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant value for an integer parsed from a string.
    /// A similar API, `constIntOfStringAndSize` is also available. If the
    /// string's length is available, it is preferred to call that function instead.
    public static func constIntOfString(intType: TypeRef, text: String, radix: UInt8) -> Value? {
        let val = text.withCString { cString in
            LLVMConstIntOfString(intType.typeRef, cString, radix)
        }
        guard let valueRef = val else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant value for an integer parsed from a string with specified length.
    public static func constIntOfStringAndSize(intType: TypeRef, text: String, radix: UInt8) -> Value? {
        let val = text.withCString { cString in
            let length = UInt32(text.utf8.count)
            return LLVMConstIntOfStringAndSize(intType.typeRef, cString, length, radix)
        }
        guard let valueRef = val else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant value referring to a double floating point value.
    public static func constReal(realType: TypeRef, n: Double) -> Value? {
        guard let valueRef = LLVMConstReal(realType.typeRef, n) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant for a floating point value parsed from a string.
    /// A similar API, LLVMConstRealOfStringAndSize is also available. It
    /// should be used if the input string's length is known.
    public static func constRealOfString(realType: TypeRef, text: String) -> Value? {
        let val = text.withCString { cString in
            LLVMConstRealOfString(realType.typeRef, cString)
        }
        guard let valueRef = val else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain a constant for a floating point value parsed from a string.
    public static func constRealOfStringAndSize(realType: TypeRef, text: String) -> Value? {
        let val = text.withCString { cString in
            let length = UInt32(text.utf8.count)
            return LLVMConstRealOfStringAndSize(realType.typeRef, cString, length)
        }
        guard let valueRef = val else { return nil }
        return Value(llvm: valueRef)
    }

    /// Obtain the zero extended value for an integer constant value.
    // unsigned long long LLVMConstIntGetZExtValue(LLVMValueRef ConstantVal);
//    public static func  getLLVMConstIntZExtValue(constantVal: LLVMValueRef) -> UInt64 {
//        return LLVMConstIntGetZExtValue(constantVal)
//    }


    /// Obtain the sign extended value for an integer constant value.
    // long long LLVMConstIntGetSExtValue(LLVMValueRef ConstantVal);
//    public static func  constIntSExtValue(constantVal: LLVMValueRef) -> Int64 {
//        return LLVMConstIntGetSExtValue(constantVal)
//    }

    /// Obtain the double value for an floating point constant value.
    /// losesInfo indicates if some precision was lost in the conversion.
    // double LLVMConstRealGetDouble(LLVMValueRef ConstantVal, LLVMBool *losesInfo);
    // public static func  constRealGetDouble(constantVal: LLVMValueRef) -> (Double, Bool) {
//    var losesInfo: LLVMBool = 0
//    let result = LLVMConstRealGetDouble(constantVal, &losesInfo)
//    return (result, losesInfo != 0)
// }
}
