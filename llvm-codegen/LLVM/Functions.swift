import CLLVM

/// A `Function` represents a named function body in LLVM IR source.  Functions
/// in LLVM IR encapsulate a list of parameters and a sequence of basic blocks
/// and provide a way to append to that sequence to build out its body.
///
/// A LLVM function definition contains a list of basic blocks, starting with
/// a privileged first block called the "entry block". After the entry blocks'
/// terminating instruction come zero or more other basic blocks.  The path the
/// flow of control can potentially take, from each block to its terminator
/// and on to other blocks, forms the "Control Flow Graph" (CFG) for the
/// function.  The nodes of the CFG are the basic blocks, and the edges are
/// directed from the terminator instruction of one block to any number of
/// potential target blocks.
///
/// Additional basic blocks may be created and appended to the function at
/// any time.
///
///     let module = Module(name: "Example")
///     let builder = Builder(module: module)
///     let fun = builder.addFunction("example",
///                                   type: FunctionType([], VoidType()))
///     // Create and append the entry block
///     let entryBB = fun.appendBasicBlock(named: "entry")
///     // Create and append a standalone basic block
///     let freestanding = BasicBlock(name: "freestanding")
///     fun.append(freestanding)
///
/// An LLVM function always has the type `FunctionType`.  This type is used to
/// determine the number and kind of parameters to the function as well as its
/// return value, if any.  The parameter values, which would normally enter
/// the entry block, are instead attached to the function and are accessible
/// via the `parameters` property.
///
/// Calling Convention
/// ==================
///
/// By default, all functions in LLVM are invoked with the C calling convention
/// but the exact calling convention of both a function declaration and a
/// `call` instruction are fully configurable.
///
///     let module = Module(name: "Example")
///     let builder = Builder(module: module)
///     let fun = builder.addFunction("example",
///                                   type: FunctionType([], VoidType()))
///     // Switch to swiftcc
///     fun.callingConvention = .swift
///
/// The calling convention of a function and a corresponding call instruction
/// must match or the result is undefined.
///
/// Sections
/// ========
///
/// A function may optionally state the section in the object file it
/// should reside in through the use of a metadata attachment.  This can be
/// useful to satisfy target-specific data layout constraints, or to provide
/// some hints to optimizers and linkers.
///
///     let mdBuilder = MDBuilder()
///     // __attribute__((hot))
///     let hotAttr = mdBuilder.buildFunctionSectionPrefix(".hot")
///
///     let module = Module(name: "Example")
///     let builder = Builder(module: module)
///     let fun = builder.addFunction("example",
///                                   type: FunctionType([], VoidType()))
///     // Attach the metadata
///     fun.addMetadata(hotAttr, kind: .sectionPrefix)
///
/// For targets that support it, a function may also specify a COMDAT section.
///
///     fun.comdat = module.comdat(named: "example")
///
/// Debug Information
/// =================
///
/// A function may also carry debug information through special subprogram
/// nodes.  These nodes are intended to capture the structure of the function
/// as it appears in the source so that it is available for inspection by a
/// debugger.
public struct Function: ValueRef {
    private let llvm: LLVMValueRef

    /// Retrieves the underlying LLVM value object.
    public var valueRef: LLVMValueRef { llvm }

    /// Init function by LLVM Value
    public init(llvm: LLVMValueRef) {
        self.llvm = llvm
    }
}
