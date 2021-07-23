import CLLVM

///  Target extension type
public struct TargetExtType: TypeRef {
    private let llvm: LLVMTypeRef

    /// Returns the context associated with this type.
    public let context: Context?

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Creates an instance of the `TargetExt` type  in the  context.
    public init(in context: Context, name: String, typeParams: [TypeRef], intParams: [UInt32]) {
        var mutableTypeParams = typeParams.map { $0.typeRef as Optional }
        var mutableIntParams = intParams
        self.llvm = name.withCString { cName in
            mutableTypeParams.withUnsafeMutableBufferPointer { typeParamsBuffer in
                mutableIntParams.withUnsafeMutableBufferPointer { intParamsBuffer in
                    LLVMTargetExtTypeInContext(context.contextRef, cName,
                                               typeParamsBuffer.baseAddress,
                                               UInt32(typeParams.count),
                                               intParamsBuffer.baseAddress,
                                               UInt32(intParams.count))!
                }
            }
        }
        self.context = context
    }
}

extension TargetExtType: Equatable {
    public static func == (lhs: TargetExtType, rhs: TargetExtType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
