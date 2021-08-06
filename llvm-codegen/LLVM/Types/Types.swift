import CLLVM

/// Used to represent an attributes.
public protocol AttributeRef {
    var attributeRef: LLVMAttributeRef { get }
}

/// Represents a basic block of instructions in LLVM IR.
public protocol BasicBlockRef {
    var basicBlockRef: LLVMBasicBlockRef { get }
}

public protocol BinaryRef {
    var binaryRef: LLVMBinaryRef { get }
}

/// Represents an LLVM basic block builder.
public protocol BuilderRef {
    var BuilderRef: LLVMBuilderRef { get }
}

public protocol ComdatRef {
    var comdatRef: LLVMComdatRef { get }
}

/// The top-level container for all LLVM global data.
public protocol ContextRef {
    var contextRef: LLVMContextRef { get }
}

public protocol DiagnosticInfoRef {
    var diagnosticInfoRef: LLVMDiagnosticInfoRef { get }
}

/// Represents an LLVM debug info builder.
public protocol DIBuilderRef {
    var dIBuilderRef: LLVMDIBuilderRef { get }
}

public protocol JITEventListenerRef {
    var jitEventListenerRef: LLVMJITEventListenerRef { get }
}

/// LLVM uses a polymorphic type hierarchy which C cannot represent, therefore parameters must be passed as base types.
/// Despite the declared types, most of the functions provided operate only on branches of the type hierarchy. The declared parameter
/// names are descriptive and specify which type is required. Additionally, each type hierarchy is documented along with the functions
/// that operate upon it. For more detail, refer to LLVM's C++ code. If in doubt, refer to Core.cpp, which performs parameter downcasts
/// in the form unwrap<RequiredType>(Param). Used to pass regions of memory through LLVM interfaces.
public protocol MemoryBufferRef {
    var memoryBufferRef: LLVMMemoryBufferRef { get }
}

/// Represents an LLVM Metadata.
public protocol MetadataRef {
    var metadataRef: LLVMMetadataRef { get }
}

/// Interface used to provide a module to JIT or interpreter.
public protocol ModuleFlagEntry {
    // `LLVMModuleFlagEntry` not found
    // var moduleFlagEntry: LLVMModuleFlagEntry { get }
}

/// Interface used to provide a module to JIT or interpreter.
public protocol ModuleProviderRef {
    var moduleProviderRef: LLVMModuleProviderRef { get }
}

/// The top-level container for all other LLVM Intermediate Representation (IR) objects.
public protocol ModuleRef {
    var moduleRef: LLVMModuleRef { get }
}

/// Represents an LLVM Named Metadata Node.
public protocol NamedMDNodeRef {
    var namedMDNodeRef: LLVMNamedMDNodeRef { get }
}

public protocol OperandBundleRef {
    // `LLVMOperandBundleRef` not found
    // var operandBundleRef: LLVMOperandBundleRef { get }
}

public protocol PassManagerRef {
    var passManagerRef: LLVMPassManagerRef { get }
}

/// Each value in the LLVM IR has a type, an LLVMTypeRef.
public protocol TypeRef {
    var typeRef: LLVMTypeRef { get }
}

public extension TypeRef {
    /// Get concrete type in their Context.
    /// For the result can be applied operations: `is`, `as?`, `as!`
    var getConcreteTypeInContext: TypeRef {
        let ty = Types(llvm: self)
        switch ty.getTypeKind {
        case .integerTypeKind:
            let intWidth = IntType.getIntTypeWidth(ty: self)
            return switch intWidth {
            case 1: Int1Type(typeRef: self, context: ty.getTypeContext)
            case 8: Int8Type(typeRef: self, context: ty.getTypeContext)
            case 16: Int16Type(typeRef: self, context: ty.getTypeContext)
            case 32: Int32Type(typeRef: self, context: ty.getTypeContext)
            case 64: Int64Type(typeRef: self, context: ty.getTypeContext)
            case 128: Int128Type(typeRef: self, context: ty.getTypeContext)
            default: IntType(bits: intWidth, in: ty.getTypeContext)
            }
        case .voidTypeKind: return VoidType(typeRef: self, context: ty.getTypeContext)
        case .halfTypeKind: return HalfType(typeRef: self, context: ty.getTypeContext)
        case .floatTypeKind: return FloatType(typeRef: self, context: ty.getTypeContext)
        case .doubleTypeKind: return DoubleType(typeRef: self, context: ty.getTypeContext)
        case .x86_FP80TypeKind: return X86FP80Type(typeRef: self, context: ty.getTypeContext)
        case .fp128TypeKind: return FP128Type(typeRef: self, context: ty.getTypeContext)
        case .ppc_FP128TypeKind: return PPCFP128Type(typeRef: self, context: ty.getTypeContext)
        case .labelTypeKind: return LabelType(typeRef: self, context: ty.getTypeContext)
        case .functionTypeKind: fatalError("unknown type kind \(ty.getTypeKind)")
        case .structTypeKind: return StructType(typeRef: self)
        case .arrayTypeKind: return ArrayType(typeRef: self)
        case .pointerTypeKind:
            let pointee = PointerType.getElementType(typeRef: self)
            let addressSpace = PointerType.getPointerAddressSpace(typeRef: self)
            return PointerType(pointee: pointee, addressSpace: addressSpace)
        case .vectorTypeKind: return VectorType(typeRef: self)
        case .metadataTypeKind: return MetadataType(typeRef: self, context: ty.getTypeContext)
        case .x86_MMXTypeKind: return X86MMXType(typeRef: self, context: ty.getTypeContext)
        case .tokenTypeKind: return TokenType(typeRef: self, context: ty.getTypeContext)
        case .scalableVectorTypeKind: return ScalableVectorType(typeRef: self)
        case .bFloatTypeKind: return BFloatType(typeRef: self, context: ty.getTypeContext)
        case .x86_AMXTypeKind: return X86AMXType(typeRef: self, context: ty.getTypeContext)
        case .targetExtTypeKind: return TargetExtType(typeRef: self, context: ty.getTypeContext)
        }
    }
}

/// Used to get the users and usees of a Value.
public protocol UseRef {
    var useRef: LLVMUseRef { get }
}

/// Represents an entry in a Global Object's metadata attachments.
public protocol ValueMetadataEntry {
    // `LLVMValueMetadataEntry` not found
    // var valueMetadataEntry: LLVMValueMetadataEntry { get }
}

/// Represents an individual value in LLVM IR.
public protocol ValueRef {
    var valueRef: LLVMValueRef { get }
}

public enum TypeKind {
    case voidTypeKind /** < type with no size */
    case halfTypeKind /** < 16 bit floating point type */
    case floatTypeKind /** < 32 bit floating point type */
    case doubleTypeKind /** < 64 bit floating point type */
    case x86_FP80TypeKind /** < 80 bit floating point type (X87) */
    case fp128TypeKind /** < 128 bit floating point type (112-bit mantissa) */
    case ppc_FP128TypeKind /** < 128 bit floating point type (two 64-bits) */
    case labelTypeKind /** < Labels */
    case integerTypeKind /** < Arbitrary bit width integers */
    case functionTypeKind /** < Functions */
    case structTypeKind /** < Structures */
    case arrayTypeKind /** < Arrays */
    case pointerTypeKind /** < Pointers */
    case vectorTypeKind /** < Fixed width SIMD vector type */
    case metadataTypeKind /** < Metadata */
    case x86_MMXTypeKind /** < X86 MMX */
    case tokenTypeKind /** < Tokens */
    case scalableVectorTypeKind /** < Scalable SIMD vector type */
    case bFloatTypeKind /** < 16 bit brain floating point type */
    case x86_AMXTypeKind /** < X86 AMX */
    case targetExtTypeKind /** < Target extension type */

    public init?(ty: LLVMTypeKind) {
        switch ty {
        case LLVMVoidTypeKind: self = .voidTypeKind
        case LLVMHalfTypeKind: self = .halfTypeKind
        case LLVMFloatTypeKind: self = .floatTypeKind
        case LLVMDoubleTypeKind: self = .doubleTypeKind
        case LLVMX86_FP80TypeKind: self = .x86_FP80TypeKind
        case LLVMFP128TypeKind: self = .fp128TypeKind
        case LLVMPPC_FP128TypeKind: self = .ppc_FP128TypeKind
        case LLVMLabelTypeKind: self = .labelTypeKind
        case LLVMIntegerTypeKind: self = .integerTypeKind
        case LLVMFunctionTypeKind: self = .functionTypeKind
        case LLVMStructTypeKind: self = .structTypeKind
        case LLVMArrayTypeKind: self = .arrayTypeKind
        case LLVMPointerTypeKind: self = .pointerTypeKind
        case LLVMVectorTypeKind: self = .vectorTypeKind
        case LLVMMetadataTypeKind: self = .metadataTypeKind
        case LLVMX86_MMXTypeKind: self = .x86_MMXTypeKind
        case LLVMTokenTypeKind: self = .tokenTypeKind
        case LLVMScalableVectorTypeKind: self = .scalableVectorTypeKind
        case LLVMBFloatTypeKind: self = .bFloatTypeKind
        case LLVMX86_AMXTypeKind: self = .x86_AMXTypeKind
        case LLVMTargetExtTypeKind: self = .targetExtTypeKind
        default: return nil
        }
    }
}

public struct Types: TypeRef {
    let llvm: LLVMTypeRef

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Init `Types` by `TypeRef`
    public init(llvm: TypeRef) {
        self.llvm = llvm.typeRef
    }

    /// Init `Types` by `LLVMTypeRef`
    public init(typeRef: LLVMTypeRef) {
        self.llvm = typeRef
    }

    /// Obtain the enumerated type of a Type instance.
    public var getTypeKind: TypeKind {
        TypeKind(ty: LLVMGetTypeKind(typeRef))!
    }

    /// Whether the type has a known size.
    public var typeIsSized: Bool {
        LLVMTypeIsSized(typeRef) != 0
    }

    /// Obtain the context to which this type instance is associated.
    public var getTypeContext: Context {
        Context(llvm: LLVMGetTypeContext(typeRef))
    }

    /// Dump a representation of a type to stderr.
    public func dumpType() {
        LLVMDumpType(typeRef)
    }

    /// Return a string representation of the type.
    public func printTypeToString() -> String {
        let cstring = LLVMPrintTypeToString(typeRef)
        return String(cString: cstring!)
    }
}
