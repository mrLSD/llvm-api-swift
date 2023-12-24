//
//  bridge.h
//  llvm-codegen
//
//  Created by Evgeny Ukhanov on 22/12/2023.
//

#ifndef bridge_h
#define bridge_h

#include <llvm-c/Transforms/PassBuilder.h>
#include <llvm-c/Analysis.h>
#include <llvm-c/BitReader.h>
#include <llvm-c/BitWriter.h>
#include <llvm-c/Comdat.h>
#include <llvm-c/Core.h>
#include <llvm-c/DataTypes.h>
#include <llvm-c/DebugInfo.h>
#include <llvm-c/Deprecated.h>
#include <llvm-c/Disassembler.h>
#include <llvm-c/DisassemblerTypes.h>
#include <llvm-c/Error.h>
#include <llvm-c/ErrorHandling.h>
#include <llvm-c/ExecutionEngine.h>
#include <llvm-c/ExternC.h>
#include <llvm-c/IRReader.h>
#include <llvm-c/LLJIT.h>
#include <llvm-c/Linker.h>
#include <llvm-c/Object.h>
#include <llvm-c/Orc.h>
#include <llvm-c/OrcEE.h>
#include <llvm-c/Remarks.h>
#include <llvm-c/Support.h>
#include <llvm-c/Target.h>
#include <llvm-c/TargetMachine.h>
#include <llvm-c/Types.h>
#include <llvm-c/blake3.h>
#include <llvm-c/lto.h>

#endif /* bridge_h */
