# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

message(STATUS "IREE_EXTERNAL_TESTS::tests/matmul/CMakeLists.txt")

message(STATUS "CMAKE_CURRENT_SOURCE_DIR: '${CMAKE_CURRENT_SOURCE_DIR}'")

iree_generated_e2e_matmul_test(
  NAME
    external_e2e_matmul_dt_f32_f32_small
  GENERATOR
    "generate_e2e_matmul_tests.py"
    # "${CMAKE_CURRENT_SOURCE_DIR}/generate_e2e_matmul_tests.py"
    # "${IREE_EXTERNAL_TESTS_SOURCE_DIR}/tests/matmul/generate_e2e_matmul_tests.py"
  GENERATOR_ARGS
    "--lhs_rhs_type=f32"
    "--acc_type=f32"
    "--shapes=small"
  TEST_RUNNER
    iree-e2e-matmul-test
  TARGET_BACKENDS
    "llvm-cpu"
  DRIVERS
    "local-task"
  COMPILER_FLAGS
  LABELS
)

iree_generated_e2e_matmul_test(
  NAME
    e2e_matmul_dt_f32_f32_large
  GENERATOR
    "generate_e2e_matmul_tests.py"
    # "${CMAKE_CURRENT_SOURCE_DIR}/generate_e2e_matmul_tests.py"
    # "${IREE_EXTERNAL_TESTS_SOURCE_DIR}/tests/matmul/generate_e2e_matmul_tests.py"
  GENERATOR_ARGS
    "--lhs_rhs_type=f32"
    "--acc_type=f32"
    "--shapes=large"
  TEST_RUNNER
    iree-e2e-matmul-test
  TARGET_BACKENDS
    "llvm-cpu"
  DRIVERS
    "local-task"
  COMPILER_FLAGS
  LABELS
)

iree_generated_e2e_matmul_test(
  NAME
    e2e_matmul_dt_f16_f16_small
  GENERATOR
    "generate_e2e_matmul_tests.py"
  GENERATOR_ARGS
    "--lhs_rhs_type=f16"
    "--acc_type=f16"
    "--shapes=small"
  TEST_RUNNER
    iree-e2e-matmul-test
  TARGET_BACKENDS
    "llvm-cpu"
  DRIVERS
    "local-task"
  COMPILER_FLAGS
  LABELS
)

iree_generated_e2e_matmul_test(
  NAME
    external_vmvx_e2e_matmul_dt_f32_f32_small
  GENERATOR
    "generate_e2e_matmul_tests.py"
  GENERATOR_ARGS
    "--lhs_rhs_type=f32"
    "--acc_type=f32"
    "--shapes=small"
  TEST_RUNNER
    iree-e2e-matmul-test
  TARGET_BACKENDS
    "vmvx-external"
  DRIVERS
    "local-task"
  COMPILER_FLAGS
  LABELS
)
