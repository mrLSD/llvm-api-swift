import CLLVM

/// Functions in this group operate on composite constants.
public enum CompositeConstant {
    /// Create a ConstantDataSequential and initialize it with a string.
    public static func constStringInContext(context: ContextRef, str: String, dontNullTerminate: Bool) -> Value {
        let valueRef = str.withCString { cStr in
            let length = UInt32(str.utf8.count)
            return LLVMConstStringInContext(context.contextRef, cStr, length, dontNullTerminate.llvm)!
        }
        return Value(llvm: valueRef)
    }

    /// Create a ConstantDataSequential with string content in the global context.
    /// This is the same as `constStringInContext` except it operates on the global context.
    public static func constString(str: String, dontNullTerminate: Bool) -> Value {
        let valueRef = str.withCString { cStr in
            let length = UInt32(str.utf8.count)
            return LLVMConstString(cStr, length, dontNullTerminate.llvm)!
        }
        return Value(llvm: valueRef)
    }

    /// Returns true if the specified constant is an array of i8.
    public static func isConstantString(value: ValueRef) -> Bool {
        LLVMIsConstantString(value.valueRef) != 0
    }

    /// Get the given constant data sequential as a string.
    public static func getString(value: ValueRef) -> String? {
        var length: size_t = 0
        guard let cString = LLVMGetAsString(value.valueRef, &length) else {
            return nil
        }
        return String(cString: cString)
    }

    /// Create an anonymous `ConstantStruct` with the specified values.
    public static func constStructInContext(context: ContextRef, constantVals: [ValueRef], packed: Bool) -> Value? {
        let count = UInt32(constantVals.count)
        let vals = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(count))
        defer {
            vals.deallocate()
        }

        for (index, val) in constantVals.enumerated() {
            vals[index] = val.valueRef
        }
        guard let valueRef = LLVMConstStructInContext(context.contextRef, vals, count, packed.llvm) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Create a `ConstantStruct` in the global Context.
    /// This is the same as `constStructInContext` except it operates on the global `Context`.
    public static func createLLVMConstStruct(constantVals: [ValueRef], packed: Bool) -> Value? {
        let count = UInt32(constantVals.count)
        let vals = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(count))
        defer {
            vals.deallocate()
        }

        for (index, val) in constantVals.enumerated() {
            vals[index] = val.valueRef
        }
        guard let valueRef = LLVMConstStruct(vals, count, packed.llvm) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Create a `ConstantArray` from values.
    @available(*, deprecated, message: "ConstArray is deprecated in favor of the API accurate constArray2")
    public static func createLLVMConstArray(elementType: TypeRef, constantValues: [ValueRef]) -> Value? {
        let length = UInt32(constantValues.count)
        let values = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(length))
        defer {
            values.deallocate()
        }

        for (index, value) in constantValues.enumerated() {
            values[index] = value.valueRef
        }
        guard let valueRef = LLVMConstArray(elementType.typeRef, values, length) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Create a ConstantArray from values.
    public static func constArray2(elementType: TypeRef, constantValues: [ValueRef]) -> Value? {
        let length = UInt64(constantValues.count)
        let values = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(length))
        defer {
            values.deallocate()
        }

        for (index, value) in constantValues.enumerated() {
            values[index] = value.valueRef
        }
        guard let valueRef = LLVMConstArray2(elementType.typeRef, values, length) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Create a non-anonymous `ConstantStruct` from values.
    public static func constNamedStruct(structType: TypeRef, constantValues: [ValueRef]) -> Value? {
        let count = UInt32(constantValues.count)
        let values = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(count))
        defer {
            values.deallocate()
        }

        for (index, value) in constantValues.enumerated() {
            values[index] = value.valueRef
        }
        guard let valueRef = LLVMConstNamedStruct(structType.typeRef, values, count) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Get element of a constant aggregate (struct, array or vector) at the
    /// specified index. Returns null if the index is out of range, or it's not
    /// possible to determine the element (e.g., because the constant is a
    /// constant expression.)
    public static func getAggregateElement(aggregate: ValueRef, index: UInt32) -> Value? {
        guard let valueRef = LLVMGetAggregateElement(aggregate.valueRef, index) else { return nil }
        return Value(llvm: valueRef)
    }

    /// Create a ConstantVector from values.
    public static func constVector(scalarConstantValues: [ValueRef]) -> Value? {
        let size = UInt32(scalarConstantValues.count)
        let values = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(size))
        defer {
            values.deallocate()
        }

        for (index, value) in scalarConstantValues.enumerated() {
            values[index] = value.valueRef
        }
        guard let valueRef = LLVMConstVector(values, size) else { return nil }
        return Value(llvm: valueRef)
    }
}
