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
