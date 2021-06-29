import CLLVM

public protocol ValueRef {
    var valueRef: LLVMValueRef { get }
}

public protocol BasicBlockRef {
    var basicBlockRef: LLVMBasicBlockRef { get }
}
