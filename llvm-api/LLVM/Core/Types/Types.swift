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
    var builderRef: LLVMBuilderRef { get }
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
        let ty = Types(typeRef: self)
        switch ty.getTypeKind {
        case .IntegerTypeKind:
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
        case .VoidTypeKind: return VoidType(typeRef: self, context: ty.getTypeContext)
        case .HalfTypeKind: return HalfType(typeRef: self, context: ty.getTypeContext)
        case .FloatTypeKind: return FloatType(typeRef: self, context: ty.getTypeContext)
        case .DoubleTypeKind: return DoubleType(typeRef: self, context: ty.getTypeContext)
        case .X86_FP80TypeKind: return X86FP80Type(typeRef: self, context: ty.getTypeContext)
        case .FP128TypeKind: return FP128Type(typeRef: self, context: ty.getTypeContext)
        case .PPC_FP128TypeKind: return PPCFP128Type(typeRef: self, context: ty.getTypeContext)
        case .LabelTypeKind: return LabelType(typeRef: self, context: ty.getTypeContext)
        case .FunctionTypeKind:
            let paramTypes = FunctionType.getParamTypes(funcType: self)
            let returnTy = FunctionType.getReturnType(funcType: self)
            let isVarArg = FunctionType.isFunctionVarArg(funcType: self)
            return FunctionType(returnType: returnTy, parameterTypes: paramTypes, isVariadic: isVarArg)
        case .StructTypeKind: return StructType(typeRef: self)
        case .ArrayTypeKind: return ArrayType(typeRef: self)
        case .PointerTypeKind:
            let pointee = PointerType.getElementType(typeRef: self)!
            let addressSpace = PointerType.getPointerAddressSpace(typeRef: self)
            return PointerType(pointee: pointee, addressSpace: addressSpace)
        case .VectorTypeKind: return VectorType(typeRef: self)
        case .MetadataTypeKind: return MetadataType(typeRef: self, context: ty.getTypeContext)
        case .X86_MMXTypeKind: return X86MMXType(typeRef: self, context: ty.getTypeContext)
        case .TokenTypeKind: return TokenType(typeRef: self, context: ty.getTypeContext)
        case .ScalableVectorTypeKind: return ScalableVectorType(typeRef: self)
        case .BFloatTypeKind: return BFloatType(typeRef: self, context: ty.getTypeContext)
        case .X86_AMXTypeKind: return X86AMXType(typeRef: self, context: ty.getTypeContext)
        case .TargetExtTypeKind: return TargetExtType(typeRef: self, context: ty.getTypeContext)
        }
    }
}

/// Used to get the users and uses of a Value.
public protocol UseRef {
    var useRef: LLVMUseRef { get }
}

/// Represents an entry in a Global Object's metadata attachments.
@available(*, unavailable, message: "Unavailable for current LLVM-C API")
public protocol ValueMetadataEntry {
    // `LLVMValueMetadataEntry` not found
    // var valueMetadataEntry: LLVMValueMetadataEntry { get }
}

/// Represents an individual value in LLVM IR.
public protocol ValueRef {
    var valueRef: LLVMValueRef { get }
}

public struct Types: TypeRef {
    let llvm: LLVMTypeRef

    /// Retrieves the underlying LLVM type object.
    public var typeRef: LLVMTypeRef { llvm }

    /// Init `Types` by `TypeRef`
    public init(typeRef: TypeRef) {
        llvm = typeRef.typeRef
    }

    /// Init `Types` by `LLVMTypeRef`
    public init(llvm: LLVMTypeRef) {
        self.llvm = llvm
    }

    /// Obtain the enumerated type of a Type instance.
    public var getTypeKind: TypeKind {
        TypeKind(from: LLVMGetTypeKind(typeRef))!
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
        guard let cString = LLVMPrintTypeToString(typeRef) else { return "" }
        return String(cString: cString)
    }
}

public extension Bool {
    /// Get  `LLVM` representation for Boolean type
    var llvm: Int32 { self ? 1 : 0 }
}

/// Declarations for `LLVMOpcode`
public enum Opcode: UInt32 {
    /* Terminator Instructions */
    case Ret = 1
    case Br = 2
    case Switch = 3
    case IndirectBr = 4
    case Invoke = 5
    /* removed 6 due to API changes */
    case Unreachable = 7
    case CallBr = 67

    /* Standard Unary Operators */
    case FNeg = 66

    /* Standard Binary Operators */
    case Add = 8
    case FAdd = 9
    case Sub = 10
    case FSub = 11
    case Mul = 12
    case FMul = 13
    case UDiv = 14
    case SDiv = 15
    case FDiv = 16
    case URem = 17
    case SRem = 18
    case FRem = 19

    /* Logical Operators */
    case Shl = 20
    case LShr = 21
    case AShr = 22
    case And = 23
    case Or = 24
    case Xor = 25

    /* Memory Operators */
    case Alloca = 26
    case Load = 27
    case Store = 28
    case GetElementPtr = 29

    /* Cast Operators */
    case Trunc = 30
    case ZExt = 31
    case SExt = 32
    case FPToUI = 33
    case FPToSI = 34
    case UIToFP = 35
    case SIToFP = 36
    case FPTrunc = 37
    case FPExt = 38
    case PtrToInt = 39
    case IntToPtr = 40
    case BitCast = 41
    case AddrSpaceCast = 60

    /* Other Operators */
    case ICmp = 42
    case FCmp = 43
    case PHI = 44
    case Call = 45
    case Select = 46
    case UserOp1 = 47
    case UserOp2 = 48
    case AArg = 49
    case ExtractElement = 50
    case InsertElement = 51
    case ShuffleVector = 52
    case ExtractValue = 53
    case InsertValue = 54
    case Freeze = 68

    /* Atomic operators */
    case Fence = 55
    case AtomicCmpXchg = 56
    case AtomicRMW = 57

    /* Exception Handling Operators */
    case Resume = 58
    case LandingPad = 59
    case CleanupRet = 61
    case CatchRet = 62
    case CatchPad = 63
    case CleanupPad = 64
    case CatchSwitch = 65

    /// Init enum from `LLVMOpcode`
    public init?(from val: LLVMOpcode) {
        self.init(rawValue: val.rawValue)
    }

    /// Get `LLVMOpcode` from current type
    public var llvm: LLVMOpcode { LLVMOpcode(rawValue: rawValue) }
}

public enum TypeKind: UInt32 {
    case VoidTypeKind = 0 /** < type with no size */
    case HalfTypeKind /** < 16 bit floating point type */
    case FloatTypeKind /** < 32 bit floating point type */
    case DoubleTypeKind /** < 64 bit floating point type */
    case X86_FP80TypeKind /** < 80 bit floating point type (X87) */
    case FP128TypeKind /** < 128 bit floating point type (112-bit mantissa) */
    case PPC_FP128TypeKind /** < 128 bit floating point type (two 64-bits) */
    case LabelTypeKind /** < Labels */
    case IntegerTypeKind /** < Arbitrary bit width integers */
    case FunctionTypeKind /** < Functions */
    case StructTypeKind /** < Structures */
    case ArrayTypeKind /** < Arrays */
    case PointerTypeKind /** < Pointers */
    case VectorTypeKind /** < Fixed width SIMD vector type */
    case MetadataTypeKind /** < Metadata */
    case X86_MMXTypeKind /** < X86 MMX */
    case TokenTypeKind /** < Tokens */
    case ScalableVectorTypeKind /** < Scalable SIMD vector type */
    case BFloatTypeKind /** < 16 bit brain floating point type */
    case X86_AMXTypeKind /** < X86 AMX */
    case TargetExtTypeKind /** < Target extension type */

    /// Init enum from `LLVMTypeKind`
    public init?(from ty: LLVMTypeKind) {
        self.init(rawValue: ty.rawValue)
    }

    /// Get `LLVMTypeKind` from current type
    public var llvm: LLVMTypeKind { LLVMTypeKind(rawValue: rawValue) }
}

public enum Linkage: UInt32 {
    case ExternalLinkage = 0 /** < Externally visible function */
    case AvailableExternallyLinkage
    case LinkOnceAnyLinkage /** < Keep one copy of function when linking (inline) */
    case LinkOnceODRLinkage /** < Same, but only replaced by something  equivalent. */
    case LinkOnceODRAutoHideLinkage /** < Obsolete */
    case WeakAnyLinkage /** < Keep one copy of function when linking (weak) */
    case WeakODRLinkage /** < Same, but only replaced by  equivalent. */
    case AppendingLinkage /** < Special purpose, only applies to global arrays */
    case InternalLinkage /** < Rename collisions when linking   functions) */
    case PrivateLinkage /** < Like Internal, but omit from symbol table */
    case DLLImportLinkage /** < Obsolete */
    case DLLExportLinkage /** < Obsolete */
    case ExternalWeakLinkage /** < ExternalWeak linkage description */
    case GhostLinkage /** < Obsolete */
    case CommonLinkage /** < Tentative definitions */
    case LinkerPrivateLinkage /** < Like Private, but linker removes. */
    case LinkerPrivateWeakLinkage /** < Like LinkerPrivate, but is weak. */

    /// Init enum from `LLVMLinkage`
    public init?(from ty: LLVMLinkage) {
        self.init(rawValue: ty.rawValue)
    }

    /// Get `LLVMLinkage` from current type
    public var llvm: LLVMLinkage { LLVMLinkage(rawValue: rawValue) }
}

public enum Visibility: UInt32 {
    case DefaultVisibility = 0 /** < The GV is visible */
    case HiddenVisibility /** < The GV is hidden */
    case ProtectedVisibility /** < The GV is protected */

    /// Init enum from `LLVMTVisibility`
    public init?(from ty: LLVMVisibility) {
        self.init(rawValue: ty.rawValue)
    }

    /// Get `LLVMTypeKind` from current type
    public var llvm: LLVMVisibility { LLVMVisibility(rawValue: rawValue) }
}

public enum UnnamedAddr: UInt32 {
    case NoUnnamedAddr = 0 /** < Address of the GV is significant. */
    case LocalUnnamedAddr /** < Address of the GV is locally insignificant. */
    case GlobalUnnamedAddr /** < Address of the GV is globally insignificant. */

    /// Init enum from `LLVMUnnamedAddr`
    public init?(from ty: LLVMUnnamedAddr) {
        self.init(rawValue: ty.rawValue)
    }

    /// Get `LLVMUnnamedAddr` from current type
    public var llvm: LLVMUnnamedAddr { LLVMUnnamedAddr(rawValue: rawValue) }
}

public enum DLLStorageClass: UInt32 {
    case DefaultStorageClass = 0
    case DLLImportStorageClass = 1 /** < Function to be imported from DLL. */
    case DLLExportStorageClass = 2 /** < Function to be accessible from DLL. */

    /// Init enum from `LLVMDLLStorageClass`
    public init?(from ty: LLVMDLLStorageClass) {
        self.init(rawValue: ty.rawValue)
    }

    /// Get `LLVMDLLStorageClass` from current type
    public var llvm: LLVMDLLStorageClass { LLVMDLLStorageClass(rawValue: rawValue) }
}

public enum CallConv: UInt32 {
    case CCallConv = 0
    case FastCallConv = 8
    case ColdCallConv = 9
    case GHCCallConv = 10
    case HiPECallConv = 11
    case WebKitJSCallConv = 12
    case AnyRegCallConv = 13
    case PreserveMostCallConv = 14
    case PreserveAllCallConv = 15
    case SwiftCallConv = 16
    case CXXFASTTLSCallConv = 17
    case X86StdcallCallConv = 64
    case X86FastcallCallConv = 65
    case ARMAPCSCallConv = 66
    case ARMAAPCSCallConv = 67
    case ARMAAPCSVFPCallConv = 68
    case MSP430INTRCallConv = 69
    case X86ThisCallCallConv = 70
    case PTXKernelCallConv = 71
    case PTXDeviceCallConv = 72
    case SPIRFUNCCallConv = 75
    case SPIRKERNELCallConv = 76
    case IntelOCLBICallConv = 77
    case X8664SysVCallConv = 78
    case Win64CallConv = 79
    case X86VectorCallCallConv = 80
    case HHVMCallConv = 81
    case HHVMCCallConv = 82
    case X86INTRCallConv = 83
    case AVRINTRCallConv = 84
    case AVRSIGNALCallConv = 85
    case AVRBUILTINCallConv = 86
    case AMDGPUVSCallConv = 87
    case AMDGPUGSCallConv = 88
    case AMDGPUPSCallConv = 89
    case AMDGPUCSCallConv = 90
    case AMDGPUKERNELCallConv = 91
    case X86RegCallCallConv = 92
    case AMDGPUHSCallConv = 93
    case MSP430BUILTINCallConv = 94
    case AMDGPULSCallConv = 95
    case AMDGPUESCallConv = 96

    /// Init enum from `LLVMCallConv`
    public init?(from ty: LLVMCallConv) {
        self.init(rawValue: ty.rawValue)
    }

    /// Get `LLVMCallConv` from current type
    public var llvm: LLVMCallConv { LLVMCallConv(rawValue: rawValue) }
}
