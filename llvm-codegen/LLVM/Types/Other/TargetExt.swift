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
        let cName = name.withCString { cName in cName }
        let ptrTypeParams = mutableTypeParams.withUnsafeMutableBufferPointer { typeParamsBuffer in typeParamsBuffer.baseAddress }
        let ptrIntParams = mutableIntParams.withUnsafeMutableBufferPointer { intParamsBuffer in intParamsBuffer.baseAddress }
        self.llvm = LLVMTargetExtTypeInContext(context.contextRef, cName,
                                          ptrTypeParams,
                                          UInt32(typeParams.count),
                                          ptrIntParams,
                                          UInt32(intParams.count))!
        self.context = context
    }
}

extension TargetExtType: Equatable {
    public static func == (lhs: TargetExtType, rhs: TargetExtType) -> Bool {
        return lhs.typeRef == rhs.typeRef
    }
}
