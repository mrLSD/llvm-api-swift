import CLLVM

/*
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

    public func constGEP2(_ type: TypeRef, _ constantVal: ValueRef, _ constantIndices: [ValueRef], _ numIndices: UInt32) -> Value {
        let indices = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(numIndices))
        defer {
            indices.deallocate()
        }

        for (index, value) in constantIndices.enumerated() {
            guard index < numIndices else { break }
            indices[index] = value.valueRef
        }

        let valueRef = LLVMConstGEP2(type.typeRef, constantVal.valueRef, indices, numIndices)!
        return Value(llvm: valueRef)
    }

    public func constInBoundsGEP2(_ type: TypeRef, _ constantVal: ValueRef, _ constantIndices: [ValueRef], _ numIndices: UInt32) -> Value {
        let indices = UnsafeMutablePointer<LLVMValueRef?>.allocate(capacity: Int(numIndices))
        defer {
            indices.deallocate()
        }

        for (index, value) in constantIndices.enumerated() {
            guard index < numIndices else { break }
            indices[index] = value.valueRef
        }

        let valueRef = LLVMConstInBoundsGEP2(type.typeRef, constantVal.valueRef, indices, numIndices)!
        return Value(llvm: valueRef)
    }

    public func constTrunc(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstTrunc(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constSExt(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstSExt(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constZExt(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstZExt(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constFPTrunc(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstFPTrunc(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constFPExt(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstFPExt(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constUIToFP(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstUIToFP(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constSIToFP(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstSIToFP(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constFPToUI(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstFPToUI(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

//    public func constFPToSI(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
//        let valueRef = LLVMConstFPToSI(constantVal.valueRef, toType.typeRef)!
//        return Value(llvm: valueRef)
//    }

    public func constPtrToInt(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstPtrToInt(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constIntToPtr(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstIntToPtr(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constBitCast(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstBitCast(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constAddrSpaceCast(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstAddrSpaceCast(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

//    public func constZExtOrBitCast(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
//        let valueRef = LLVMConstZExtOrBitCast(constantVal.valueRef, toType.typeRef)!
//        return Value(llvm: valueRef)
//    }

    public func constSExtOrBitCast(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstSExtOrBitCast(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constTruncOrBitCast(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstTruncOrBitCast(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

    public func constPointerCast(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
        let valueRef = LLVMConstPointerCast(constantVal.valueRef, toType.typeRef)!
        return Value(llvm: valueRef)
    }

//    public func constIntCast(_ constantVal: ValueRef, _ toType: TypeRef, _ isSigned: Bool) -> Value {
//        let valueRef = LLVMConstIntCast(constantVal.valueRef, toType.typeRef, isSigned.llvm)!
//        return Value(llvm: valueRef)
//    }

//    public func constFPCast(_ constantVal: ValueRef, _ toType: TypeRef) -> Value {
//        let valueRef = LLVMConstFPCast(constantVal.valueRef, toType.typeRef)!
//        return Value(llvm: valueRef)
//    }

    public func constExtractElement(_ vectorConstant: ValueRef, _ indexConstant: ValueRef) -> Value {
        let valueRef = LLVMConstExtractElement(vectorConstant.valueRef, indexConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constInsertElement(_ vectorConstant: ValueRef, _ elementValueConstant: ValueRef, _ indexConstant: ValueRef) -> Value {
        let valueRef = LLVMConstInsertElement(vectorConstant.valueRef, elementValueConstant.valueRef, indexConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func constShuffleVector(_ vectorAConstant: ValueRef, _ vectorBConstant: ValueRef, _ maskConstant: ValueRef) -> Value {
        let valueRef = LLVMConstShuffleVector(vectorAConstant.valueRef, vectorBConstant.valueRef, maskConstant.valueRef)!
        return Value(llvm: valueRef)
    }

    public func blockAddress(_ function: ValueRef, _ basicBlock: BasicBlockRef) -> Value {
        let valueRef = LLVMBlockAddress(function.valueRef, basicBlock.basicBlockRef)!
        return Value(llvm: valueRef)
    }

    @available(*, deprecated, message: "Use LLVMGetInlineAsm instead")
    public func constInlineAsm(type: TypeRef, asmString: String, constraints: String, hasSideEffects: Bool, isAlignStack: Bool) -> Value {
        let valueRef = asmString.withCString { asmStr in
            constraints.withCString { consStr in
                LLVMConstInlineAsm(type.typeRef, asmStr, consStr, hasSideEffects.llvm, isAlignStack.llvm)!
            }
        }
        return Value(llvm: valueRef)
    }
}
 */

