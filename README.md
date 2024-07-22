[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Swift CI](https://github.com/mrLSD/llvm-api-swift/actions/workflows/swift.yaml/badge.svg)](https://github.com/mrLSD/llvm-api-swift/actions/workflows/swift.yaml)

<center>
    <h1>mrLSD<code>/llvm-api-swift</code></h1>
</center>

`llvm-api-swift` is a library representing Swift LLVM API, a pure Swift interface to the [LLVM API](https://llvm.org/docs/) and its associated libraries. 
It provides native, easy-to-use components to create compilers codegen backend. It contains LLVM bindings,
components and toolset for efficiently use LLVM as compilers backend implementation on Swift.

## Overview

The `llvm-api-swift` provides a robust and comprehensive interface to the LLVM Compiler Infrastructure,
leveraging the `LLVM-C API` to offer a blend of safety, flexibility, and extendability. This library
is designed to serve as a powerful tool for developers looking to create backends for compilers, enabling
them to harness the full potential of **LLVM** in a secure and user-friendly manner.

## Safety

Safety is a paramount concern in the design of this library. By building on the `LLVM-C API`, we ensure that
interactions
with the **LLVM** infrastructure are conducted in a type-safe and memory-safe manner. The library employs Swift’s
stringent
safety guarantees to prevent common issues such as null pointer dereferencing, buffer overflows, and memory leaks. This
commitment to safety allows developers to focus on the functionality of their compiler backends without worrying about
underlying security vulnerabilities.

## Flexibility

Flexibility is another core attribute of the `llvm-api-swift`. The library provides a rich set of APIs that cover a wide
range of LLVM’s capabilities, from module management and inline assembly to debugging metadata and function iteration.
Developers can easily access and manipulate **LLVM** constructs, enabling the creation of highly customized and
optimized
compiler backends. The library’s design ensures that it can adapt to various use cases and requirements, making it an
ideal choice for a diverse set of compiler development projects based on Swift.

## Extendability

The 'llvm-api-swift' is built with extendability in mind. It is designed to be easily extendable, allowing developers to
add
new functionalities and support for additional **LLVM** features as needed. The modular structure of the library
facilitates
the incorporation of new components, ensuring that it can grow and evolve alongside the **LLVM** ecosystem. This
extendability ensures that the library remains relevant and useful as **LLVM** continues to advance and expand its
capabilities.

## Why LLVM?

**LLVM** (Low-Level Virtual Machine) is a powerful and versatile compiler infrastructure that provides a collection of
modular and reusable compiler and toolchain technologies. It is widely used in the development of modern compilers,
providing a framework for optimizing intermediate representations and generating machine code for various target
architectures. LLVM’s ability to support multiple languages and platforms, coupled with its extensive optimization
capabilities, makes it an essential tool for compiler developers. By leveraging **LLVM**, developers can create highly
efficient and portable compilers that meet the demands of today’s diverse computing environments.

## Design

The `llvm-api-awift` library adheres to the structure of the `LLVM C API`, ensuring easy navigation through the extensive LLVM
functions. Logical elements are grouped into modules, providing a clear organizational structure. Within these modules,
Rust structures are introduced to wrap LLVM types, implementing corresponding functions for the wrapped LLVM types. This
approach enhances flexibility and usability while maintaining the original LLVM code structure. The design avoids
unnecessary complexity in the code and documentation, remaining fully aligned with the `LLVM API`. This alignment allows
developers to easily navigate the `llvm-api-swift` library using existing LLVM-C documentation.

### Compatibility with LLVM-C API

When creating the library, we were guided by **full compatibility** with [LLVM-C API](https://llvm.org/doxygen/group__LLVMC.html).
For this reason, structurally the library tries to inherit the `LLVM-C API` tree, thereby dividing the library structure into subdirectories. 
And filling the components also with the appropriate `LLVM-C API`.
When implementing Swift types, we were guided by the approach of abstracting away from C types, completely transforming them into Swift types. 
At the same time adhering to the principles of a safety and reliability implementation - without explicit memory management, means of safe techniques, functions provided by Swift.

## Requirements

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
