import CLLVM

/// A `BasicBlock` represents a basic block in an LLVM IR program.  A basic
/// block contains a sequence of instructions, a pointer to its parent block and
/// its follower block, and an optional label that gives the basic block an
/// entry in the symbol table.  Because of this label, the type of every basic
/// block is `LabelType`.
///
/// A basic block can be thought of as a sequence of instructions, and indeed
/// its member instructions may be iterated over with a `for-in` loop.  A well-
/// formed basic block has as its last instruction a "terminator" that produces
/// a transfer of control flow and possibly yields a value.  All other
/// instructions in the middle of the basic block may not be "terminator"
/// instructions.  Basic blocks are not required to be well-formed until
/// code generation is complete.
///
/// Creating a Basic Block
/// ======================
///
/// By default, the initializer for a basic block merely creates the block but
/// does not associate it with a function.
///
///     let module = Module(name: "Example")
///     let func = builder.addFunction("example",
///                                   type: FunctionType([], VoidType()))
///
///     // This basic block is "floating" outside of a function.
///     let floatingBB = BasicBlock(name: "floating")
///     // Until we associate it with a function by calling `Function.append(_:)`.
///     func.append(floatingBB)
///
/// A basic block may be created and automatically inserted at the end of a
/// function by calling `Function.appendBasicBlock()`.
///
///     let module = Module(name: "Example")
///     let func = builder.addFunction("example",
///                                   type: FunctionType([], VoidType()))
///
///     // This basic block is "attached" to the example function.
///     let attachedBB = func.appendBasicBlock(named: "attached")
///
/// The Address of a Basic Block
/// ============================
///
/// Basic blocks (except the entry block) may have their labels appear in the
/// symbol table.  Naturally, these labels are associated with address values
/// in the final object file.  The value of that address may be accessed for the
/// purpose of an indirect call or a direct comparisson by calling
/// `Function.address(of:)` and providing one of the function's child blocks as
/// an argument.  Providing any other basic block outside of the function as an
/// argument value is undefined.
///
/// The Entry Block
/// ===============
///
/// The first basic block (the entry block) in a `Function` is special:
///
/// - The entry block is immediately executed when the flow of control enters
///   its parent function.
/// - The entry block is not allowed to have predecessor basic blocks
///   (i.e. there cannot be any branches to the entry block of a function).
/// - The address of the entry block is not a well-defined value.
/// - The entry block cannot have PHI nodes.  This is enforced structurally,
///   as the entry block can have no predecessor blocks to serve as operands
///   to the PHI node.
/// - Static `alloca` instructions situated in the entry block are treated
///   specially by most LLVM backends.  For example, FastISel keeps track of
///   static `alloca` values in the entry block to more efficiently reference
///   them from the base pointer of the stack frame.
public struct BasicBlock: BasicBlockRef {
    private let llvm: LLVMBasicBlockRef

    /// `BasicBlock` context
    public let context: Context?

    /// Retrieves the underlying LLVM value object.
    public var basicBlockRef: LLVMBasicBlockRef { llvm }

    /// Creates a `BasicBlock` from an `BasicBlockRef` object.
    public init(basicBlockRef: BasicBlockRef) {
        llvm = basicBlockRef.basicBlockRef
        context = nil
    }

    /// Init by LLVM ref
    private init(llvm: LLVMBasicBlockRef) {
        self.llvm = llvm
        context = nil
    }

    /// Create a new basic block in Context without inserting it into a function.
    ///
    /// The basic block should be inserted into a function or destroyed before
    /// the builder is finalized.
    public init(context: Context, name: String) {
        llvm = LLVMCreateBasicBlockInContext(context.contextRef, name)
        self.context = context
    }

    /// Given that this block and a given block share a parent function, move this
    /// block before the given block in that function's basic block list.
    ///
    /// - Parameter position: The basic block that acts as a position before
    ///   which this block will be moved.
    public func moveBasicBlockBefore(position: BasicBlockRef) {
        Self.moveBasicBlockBefore(basicBlock: self, position: position)
    }

    /// Given that this block and a given block share a parent function, move this
    /// block before the given block in that function's basic block list.
    public static func moveBasicBlockBefore(basicBlock: BasicBlockRef, position: BasicBlockRef) {
        LLVMMoveBasicBlockBefore(basicBlock.basicBlockRef, position.basicBlockRef)
    }

    /// Given that this block and a given block share a parent function, move this
    /// block after the given block in that function's basic block list.
    ///
    /// - Parameter position: The basic block that acts as a position after
    ///   which this block will be moved.
    public func moveBasicBlockAfter(position: BasicBlockRef) {
        Self.moveBasicBlockAfter(basicBlock: self, position: position)
    }

    /// Given that this block and a given block share a parent function, move this
    /// block after the given block in that function's basic block list.
    public static func moveBasicBlockAfter(basicBlock: BasicBlockRef, position: BasicBlockRef) {
        LLVMMoveBasicBlockAfter(basicBlock.basicBlockRef, position.basicBlockRef)
    }

    /// Retrieves the name of this basic block.
    public var getBasicBlockName: String {
        Self.getBasicBlockName(basicBlock: self)
    }

    /// Retrieves the name of this basic block.
    public static func getBasicBlockName(basicBlock: BasicBlockRef) -> String {
        guard let cString = LLVMGetBasicBlockName(basicBlock.basicBlockRef) else { return "" }
        return String(cString: cString)
    }

    /// Returns the first instruction in the basic block, if it exists.
    public var getFirstInstruction: ValueRef? {
        Self.getFirstInstruction(basicBlock: self)
    }

    /// Returns the first instruction in the basic block, if it exists.
    public static func getFirstInstruction(basicBlock: BasicBlockRef) -> ValueRef? {
        guard let val = LLVMGetFirstInstruction(basicBlock.basicBlockRef) else { return nil }
        return Values(llvm: val)
    }

    /// Returns the first instruction in the basic block, if it exists.
    public var getLastInstruction: ValueRef? {
        Self.getLastInstruction(basicBlock: self)
    }

    /// Returns the first instruction in the basic block, if it exists.
    public static func getLastInstruction(basicBlock: BasicBlockRef) -> ValueRef? {
        guard let val = LLVMGetLastInstruction(basicBlock.basicBlockRef) else { return nil }
        return Values(llvm: val)
    }

    /// Returns the parent function of this basic block, if it exists.
    public var getBasicBlockParent: Function? {
        Self.getBasicBlockParent(basicBlock: self)
    }

    /// Returns the parent function of this basic block, if it exists.
    public static func getBasicBlockParent(basicBlock: BasicBlockRef) -> Function? {
        guard let functionRef = LLVMGetBasicBlockParent(basicBlock.basicBlockRef) else { return nil }
        return Function(llvm: functionRef)
    }

    /// Returns the basic block following this basic block, if it exists.
    public var getNextBasicBlock: BasicBlockRef? {
        Self.getNextBasicBlock(basicBlock: self)
    }

    /// Returns the basic block following this basic block, if it exists.
    public static func getNextBasicBlock(basicBlock: BasicBlockRef) -> BasicBlockRef? {
        guard let blockRef = LLVMGetNextBasicBlock(basicBlock.basicBlockRef) else { return nil }
        return BasicBlock(llvm: blockRef)
    }

    /// Returns the basic block before this basic block, if it exists.
    public var getPreviousBasicBlock: BasicBlock? {
        Self.getPreviousBasicBlock(basicBlock: self)
    }

    /// Returns the basic block before this basic block, if it exists.
    public static func getPreviousBasicBlock(basicBlock: BasicBlockRef) -> BasicBlock? {
        guard let blockRef = LLVMGetPreviousBasicBlock(basicBlock.basicBlockRef) else { return nil }
        return BasicBlock(llvm: blockRef)
    }

    /// Removes this basic block from a function but keeps it alive.
    public func removeBasicBlockFromParent() {
        Self.removeBasicBlockFromParent(basicBlock: self)
    }

    /// Removes this basic block from a function but keeps it alive.
    ///
    /// - note: To ensure correct removal of the block, you must invalidate any
    ///         references to it and its child instructions.  The block must also
    ///         have no successor blocks that make reference to it.
    public static func removeBasicBlockFromParent(basicBlock: BasicBlockRef) {
        LLVMRemoveBasicBlockFromParent(basicBlock.basicBlockRef)
    }

    /// Moves this basic block before the given basic block.
    public func moveBasicBlockBefore(block: BasicBlockRef) {
        Self.moveBasicBlockBefore(basicBlock: self, block: block)
    }

    /// Moves this basic block before the given basic block.
    public static func moveBasicBlockBefore(basicBlock: BasicBlockRef, block: BasicBlockRef) {
        LLVMMoveBasicBlockBefore(basicBlock.basicBlockRef, block.basicBlockRef)
    }

    /// Moves this basic block after the given basic block.
    public func moveBasicBlockAfter(block: BasicBlockRef) {
        Self.moveBasicBlockAfter(basicBlock: self, block: block)
    }

    /// Moves this basic block after the given basic block.
    public static func moveBasicBlockAfter(basicBlock: BasicBlockRef, block: BasicBlockRef) {
        LLVMMoveBasicBlockAfter(basicBlock.basicBlockRef, block.basicBlockRef)
    }

    /// Remove a basic block from a function and delete it.
    /// This deletes the basic block from its containing function and deletes
    /// the basic block itself.
    public func deleteBasicBlock() {
        Self.deleteBasicBlock(basicBlockRef: self)
    }

    /// Remove a basic block from a function and delete it.
    /// This deletes the basic block from its containing function and deletes
    /// the basic block itself.
    public static func deleteBasicBlock(basicBlockRef: BasicBlockRef) {
        LLVMDeleteBasicBlock(basicBlockRef.basicBlockRef)
    }

    /// Convert a basic block instance to a value type.
    public var basicBlockAsValue: ValueRef? {
        Self.basicBlockAsValue(basicBlockRef: self)
    }

    /// Convert a basic block instance to a value type.
    public static func basicBlockAsValue(basicBlockRef: BasicBlockRef) -> ValueRef? {
        guard let valueRef = LLVMBasicBlockAsValue(basicBlockRef.basicBlockRef) else { return nil }
        return Values(llvm: valueRef)
    }

    /// Determine whether an LLVMValueRef is itself a basic block.
    public static func valueIsBasicBlock(valueRef: ValueRef) -> Bool {
        LLVMValueIsBasicBlock(valueRef.valueRef) != 0
    }

    /// Convert an `LLVMValueRef` to an `LLVMBasicBlockRef` instance.
    public static func valueAsBasicBlock(valueRef: ValueRef) -> BasicBlockRef {
        Self(llvm: LLVMValueAsBasicBlock(valueRef.valueRef))
    }

    /// Obtain the number of basic blocks in a function.
    /// For specified `functionValueRef`
    public static func countBasicBlocks(funcValueRef: ValueRef) -> UInt32 {
        LLVMCountBasicBlocks(funcValueRef.valueRef)
    }

    /// Obtain all of the basic blocks in a function.
    /// Return array  of BasicBlockRef instances.
    public static func getBasicBlocks(funcValueRef: ValueRef) -> [BasicBlockRef] {
        let blockCount = Self.countBasicBlocks(funcValueRef: funcValueRef)
        var basicBlocks = [LLVMBasicBlockRef?](repeating: nil, count: Int(blockCount))
        basicBlocks.withUnsafeMutableBufferPointer { bufferPointer in
            LLVMGetBasicBlocks(funcValueRef.valueRef, bufferPointer.baseAddress)
        }
        return basicBlocks.map { Self(llvm: $0!) }
    }

    /// Obtain the first basic block in a function.
    public func getFirstBasicBlock(funcValueRef: ValueRef) -> BasicBlockRef? {
        guard let blockRef = LLVMGetFirstBasicBlock(funcValueRef.valueRef) else { return nil }
        return Self(llvm: blockRef)
    }

    ///  Obtain the last basic block in a function.
    public func getLastBasicBlock(funcValueRef: ValueRef) -> BasicBlockRef? {
        guard let blockRef = LLVMGetLastBasicBlock(funcValueRef.valueRef) else { return nil }
        return Self(llvm: blockRef)
    }

    /// Obtain the basic block that corresponds to the entry point of a function.
    public func getEntryBasicBlock(funcValueRef: ValueRef) -> BasicBlockRef? {
        guard let blockRef = LLVMGetEntryBasicBlock(funcValueRef.valueRef) else { return nil }
        return Self(llvm: blockRef)
    }

    // void     LLVMInsertExistingBasicBlockAfterInsertBlock (LLVMBuilderRef Builder, LLVMBasicBlockRef BB)
//    Insert the given basic block after the insertion point of the given builder.
//
    // void     LLVMAppendExistingBasicBlock (LLVMValueRef Fn, LLVMBasicBlockRef BB)
//    Append the given basic block to the basic block list of the given function.
//
    // LLVMBasicBlockRef     LLVMAppendBasicBlockInContext (LLVMContextRef C, LLVMValueRef Fn, const char *Name)
//    Append a basic block to the end of a function.
//
    // LLVMBasicBlockRef     LLVMAppendBasicBlock (LLVMValueRef Fn, const char *Name)
//    Append a basic block to the end of a function using the global context.
//
    // LLVMBasicBlockRef     LLVMInsertBasicBlockInContext (LLVMContextRef C, LLVMBasicBlockRef BB, const char *Name)
//    Insert a basic block in a function before another basic block.
//
    // LLVMBasicBlockRef     LLVMInsertBasicBlock (LLVMBasicBlockRef InsertBeforeBB, const char *Name)
//    Insert a basic block in a function using the global context.
//

    //    /// Returns the terminator instruction if this basic block is well formed or
    //    /// `nil` if it is not well formed.
    //    public var terminator: TerminatorInstruction? {
    //        guard let term = LLVMGetBasicBlockTerminator(llvm) else { return nil }
    //        return TerminatorInstruction(llvm: term)
    //    }
//    /// Returns a sequence of the Instructions that make up this basic block.
//    public var instructions: AnySequence<IRInstruction> {
//        var current = firstInstruction
//        return AnySequence<IRInstruction> {
//            return AnyIterator<IRInstruction> {
//                defer { current = current?.next() }
//                return current
//            }
//        }
//    }
}

// public extension BasicBlock {
//    /// An `Address` represents a function-relative address of a basic block for
//    /// use with the `indirectbr` instruction.
//    struct Address: IRValue {
//        let llvm: LLVMValueRef
//
//        init(llvm: LLVMValueRef) {
//            self.llvm = llvm
//        }
//
//        /// Retrieves the underlying LLVM value object.
//        public func asLLVM() -> LLVMValueRef {
//            return llvm
//        }
//    }
// }

extension BasicBlock: Equatable {
    public static func == (lhs: BasicBlock, rhs: BasicBlock) -> Bool {
        return lhs.basicBlockRef == rhs.basicBlockRef
    }
}
