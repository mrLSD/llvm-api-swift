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

public enum DiagnosticSeverity: Int {
    case error = 0
    case warning = 1
    case remark = 2
    case note = 3

    public init?(from cSeverity: LLVMDiagnosticSeverity) {
        self.init(rawValue: Int(cSeverity.rawValue))
    }
}
