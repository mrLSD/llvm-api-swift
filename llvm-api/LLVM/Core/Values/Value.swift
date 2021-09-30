import CLLVM

public struct Value: ValueRef {
    let llvm: LLVMValueRef

    /// Retrieves the underlying LLVM type object.
    public var valueRef: LLVMValueRef { llvm }

    /// Init `Values` by `ValueRef`
    public init(valueRef: ValueRef) {
        llvm = valueRef.valueRef
    }

    /// Init `Values` by `LLVMValueRef`
    public init(llvm: LLVMValueRef) {
        self.llvm = llvm
    }
}
