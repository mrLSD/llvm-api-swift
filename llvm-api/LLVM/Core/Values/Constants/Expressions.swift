import CLLVM

/// Functions in this group correspond to APIs on `ConstantExpressions` .
public enum ConstantExpressions {
    public static func getConstOpcode(constantVal: ValueRef) -> Opcode {
        let opcode = LLVMGetConstOpcode(constantVal.valueRef)
        return Opcode(from: opcode)!
    }

    public static func alignOf(typeRef: TypeRef) -> Value {
        let valueRef = LLVMAlignOf(typeRef.typeRef)!
        return Value(llvm: valueRef)
    }

    public static func sizeOf(typeRef: TypeRef) -> Value {
        let valueRef = LLVMSizeOf(typeRef.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constNSWNeg(_ constantVal: ValueRef) -> Value {
        let valueRef = LLVMConstNSWNeg(constantVal.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNUWNeg(_ constantVal: ValueRef) -> Value {
        let valueRef = LLVMConstNUWNeg(constantVal.valueRef)!
        return Value(llvm: valueRef)
    }

    public static func constNeg(constantVal: ValueRef) -> Value {
        let valueRef = LLVMConstNeg(constantVal.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNot(_ constantVal: LLVMValueRef) -> LLVMValueRef {
        LLVMConstNot(constantVal)
    }

    public func constAdd(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstAdd(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNSWAdd(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstNSWAdd(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNUWAdd(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstNUWAdd(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constSub(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstSub(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNSWSub(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstNSWSub(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNUWSub(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstNUWSub(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constMul(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstMul(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNSWMul(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstNSWMul(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constNUWMul(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstNUWMul(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constAnd(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstAnd(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constOr(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstOr(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constXor(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstXor(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constICmp(_ predicate: IntPredicate, _ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstICmp(predicate.llvm, lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constFCmp(_ predicate: RealPredicate, _ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstFCmp(predicate.llvm, lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constShl(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstShl(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constLShr(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstLShr(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constAShr(_ lhsConstant: ValueRef, _ rhsConstant: ValueRef) -> Value {
        let valueRef = LLVMConstAShr(lhsConstant.valueRef, rhsConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    func constGEP2(_ type: LLVMTypeRef, _ constantVal: LLVMValueRef, _ constantIndices: [LLVMValueRef], _ numIndices: UInt32) -> LLVMValueRef {
        let indices = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(numIndices))
        defer {
            indices.deallocate()
        }

        for (index, value) in constantIndices.enumerated() {
            guard index < numIndices else { break }
            indices[index] = value
        }

        return LLVMConstGEP2(type, constantVal, indices, numIndices)
    }

    func constInBoundsGEP2(_ type: LLVMTypeRef, _ constantVal: LLVMValueRef, _ constantIndices: [LLVMValueRef], _ numIndices: UInt32) -> LLVMValueRef {
        let indices = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(numIndices))
        defer {
            indices.deallocate()
        }

        for (index, value) in constantIndices.enumerated() {
            guard index < numIndices else { break }
            indices[index] = value
        }

        return LLVMConstInBoundsGEP2(type, constantVal, indices, numIndices)
    }

    func constTrunc(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstTrunc(constantVal, toType)
    }

    func constSExt(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstSExt(constantVal, toType)
    }

    func constZExt(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstZExt(constantVal, toType)
    }

    func constFPTrunc(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstFPTrunc(constantVal, toType)
    }

    func constFPExt(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstFPExt(constantVal, toType)
    }

    func constUIToFP(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstUIToFP(constantVal, toType)
    }

    func constSIToFP(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstSIToFP(constantVal, toType)
    }

    func constFPToUI(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstFPToUI(constantVal, toType)
    }

    func constFPToSI(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstFPToSI(constantVal, toType)
    }

    func constPtrToInt(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstPtrToInt(constantVal, toType)
    }

    func constIntToPtr(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstIntToPtr(constantVal, toType)
    }

    func constBitCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstBitCast(constantVal, toType)
    }

    func constAddrSpaceCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstAddrSpaceCast(constantVal, toType)
    }

    func constZExtOrBitCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstZExtOrBitCast(constantVal, toType)
    }

    func constSExtOrBitCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstSExtOrBitCast(constantVal, toType)
    }

    func constTruncOrBitCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstTruncOrBitCast(constantVal, toType)
    }

    func constPointerCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstPointerCast(constantVal, toType)
    }

    func constIntCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef, _ isSigned: Bool) -> LLVMValueRef {
        LLVMConstIntCast(constantVal, toType, LLVMBool(isSigned ? 1 : 0))
    }

    func constFPCast(_ constantVal: LLVMValueRef, _ toType: LLVMTypeRef) -> LLVMValueRef {
        LLVMConstFPCast(constantVal, toType)
    }

    func constExtractElement(_ vectorConstant: LLVMValueRef, _ indexConstant: LLVMValueRef) -> LLVMValueRef {
        LLVMConstExtractElement(vectorConstant, indexConstant)
    }

    func constInsertElement(_ vectorConstant: LLVMValueRef, _ elementValueConstant: LLVMValueRef, _ indexConstant: LLVMValueRef) -> LLVMValueRef {
        LLVMConstInsertElement(vectorConstant, elementValueConstant, indexConstant)
    }

    func constShuffleVector(_ vectorAConstant: LLVMValueRef, _ vectorBConstant: LLVMValueRef, _ maskConstant: LLVMValueRef) -> LLVMValueRef {
        LLVMConstShuffleVector(vectorAConstant, vectorBConstant, maskConstant)
    }

    func blockAddress(_ function: LLVMValueRef, _ basicBlock: LLVMBasicBlockRef) -> LLVMValueRef {
        LLVMBlockAddress(function, basicBlock)
    }

    @available(*, deprecated, message: "Use LLVMGetInlineAsm instead")
    func constInlineAsm(type: LLVMTypeRef, asmString: String, constraints: String, hasSideEffects: Bool, isAlignStack: Bool) -> LLVMValueRef {
        asmString.withCString { asmStr in
            constraints.withCString { consStr in
                LLVMConstInlineAsm(type, asmStr, consStr, LLVMBool(hasSideEffects ? 1 : 0), LLVMBool(isAlignStack ? 1 : 0))
            }
        }
    }
}
