# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

message(STATUS "IREE_EXTERNAL_TESTS::tests/e2e/CMakeLists.txt")

iree_check_single_backend_test_suite(
  NAME
    check_external_llvm-cpu_local-task
  SRCS
    "abs.mlir"
    "add.mlir"
  TARGET_BACKEND
    "llvm-cpu"
  DRIVER
    "local-task"
  INPUT_TYPE
    "tosa"
)

# This needs updates in https://github.com/openxla/iree/blob/1c83020136b9d3d56da692036e5bbcb2b4586ebf/build_tools/cmake/iree_check_test.cmake#L97-L103

# iree_check_single_backend_test_suite(
#   NAME
#     check_external_vmvx-external_local-task
#   SRCS
#     "abs.mlir"
#     "add.mlir"
#   TARGET_BACKEND
#     "vmvx-external"
#   DRIVER
#     "local-task"
#   INPUT_TYPE
#     "tosa"
# )

# TODO(scotttodd): try with plugin-provided DRIVER
