
import CLLVM

public struct OtherType {
    let llvm: LLVMTypeRef

    /// Retrieves the underlying LLVM value object.
    public var typeRef: LLVMTypeRef { llvm }
}
