[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Swift CI](https://github.com/mrLSD/llvm-api-swift/actions/workflows/swift.yaml/badge.svg)](https://github.com/mrLSD/llvm-api-swift/actions/workflows/swift.yaml)

# `llvm-api-swift`

`llvm-api-swift` is a library representing Swift LLVM API, a pure Swift interface to the [LLVM API](https://llvm.org/docs/) and its associated libraries. 
It provides native, easy-to-use components to create compilers codegen backend. It contains LLVM bindings,
components and toolset for efficiently use LLVM as compilers backend implementation on Swift.

### Compatibility with LLVM-C API

When creating the library, we were guided by **full compatibility** with [LLVM-C API](https://llvm.org/doxygen/group__LLVMC.html).
For this reason, structurally the library tries to inherit the `LLVM-C API` tree, thereby dividing the library structure into subdirectories. 
And filling the components also with the appropriate `LLVM-C API`.
When implementing Swift types, we were guided by the approach of abstracting away from C types, completely transforming them into Swift types. 
At the same time adhering to the principles of a safety and reliability implementation - without explicit memory management, means of safe techniques, functions provided by Swift.


### Requirements

- Supported OS: MacOS 12.0 or above

- Swift lang: 5.9 or above

- Install latest LLVM:
```
brew install llvm
```

- Set Environment variables, that provided during `brew` llvm install

- You don't need additional configurations like `pkg-config` files, if your LLVM installation is correct and you successfully set environment variables. `Package.swift` **automatically configure** all needed things to build correctly and you don't need care more.

:arrow_right: If you have problems, just check [Troubleshooting](#troubleshooting).

### Supported LLVM versions

- [x] v17.0
- [x] v18.0


### Troubleshooting

If `LLVM-C` head files during compilation doesn't found, make sure that you are:

- installed LLVM correctly
```
llc --version
```

- Set environment variables for your terminal (for example in `.zshrc`). To get instruction about variables run:
```
brew info llvm
```

- To get more insights take a look current project [Github CI config](.github/workflows/swift.yaml).

### LICENS: [MIT](LICENSE)
