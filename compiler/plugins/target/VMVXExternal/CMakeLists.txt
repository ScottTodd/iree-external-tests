# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

iree_compiler_register_plugin(
  PLUGIN_ID
    hal_target_vmvx_external
  TARGET
    ::VMVXExternal
)

iree_cc_library(
  NAME
  VMVXExternal
  SRCS
    "VMVXExternalTarget.cpp"
  DEPS
    IREELinalgExtDialect
    LLVMSupport
    MLIRIR
    MLIRPass
    MLIRSupport
    iree::compiler::Codegen::Dialect::Codegen::IR::IREECodegenDialect
    iree::compiler::Codegen::VMVX
    iree::compiler::Dialect::HAL::Target
    iree::compiler::Dialect::VM::Conversion
    iree::compiler::Dialect::VM::IR
    iree::compiler::Dialect::VM::Target::Bytecode
    iree::compiler::Dialect::VM::Transforms
    iree::compiler::Dialect::VMVX::IR::VMVXDialect
    iree::compiler::Dialect::VMVX::Transforms
    iree::compiler::PluginAPI
  PUBLIC
)
