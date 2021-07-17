import CLLVM

public struct LLVMTargetExtType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates an instance of the `LLVMTargetExt` type  in the  context.
    public init(in context: Context, name: String, typeParams: [LLVMTypeRef?], intParams: [UInt32]) {
        var mutableTypeParams = typeParams
        var mutableIntParams = intParams
        llvm = name.withCString { cName in
            mutableTypeParams.withUnsafeMutableBufferPointer { typeParamsBuffer in
                mutableIntParams.withUnsafeMutableBufferPointer { intParamsBuffer in
                    LLVMTargetExtTypeInContext(context.contextRef, cName,
                                               typeParamsBuffer.baseAddress,
                                               UInt32(typeParams.count),
                                               intParamsBuffer.baseAddress,
                                               UInt32(intParams.count))
                }
            }
        }
        self.context = context
    }
}

extension LLVMTargetExtType: Equatable {
    public static func == (lhs: LLVMTargetExtType, rhs: LLVMTargetExtType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
