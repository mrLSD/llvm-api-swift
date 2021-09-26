import CLLVM

/// Diagnostic functionality
public struct Diagnostic: DiagnosticInfoRef {
    private var llvm: LLVMDiagnosticInfoRef
    public var diagnosticInfoRef: LLVMDiagnosticInfoRef { llvm }

    /// Init DIagnosticInfo
    public init(llvm: LLVMDiagnosticInfoRef) {
        self.llvm = llvm
    }

    /// Return a string representation of the DiagnosticInfo.
    public var getDiagInfoDescription: String? {
        Context.getDiagInfoDescription(diagnosticInfo: self)
    }

    /// Return an enum LLVMDiagnosticSeverity.
    public var getDiagInfoSeverity: DiagnosticSeverity? {
        Context.getDiagInfoSeverity(diagnosticInfo: self)
    }
}

