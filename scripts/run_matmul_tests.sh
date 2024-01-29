#!/bin/bash
# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# Manual IREE matmul test script.
#
# This pulls code from
#   * https://github.com/openxla/iree/blob/main/build_tools/cmake/iree_e2e_matmul_test.cmake
#   * https://github.com/openxla/iree/blob/main/tests/e2e/matmul/CMakeLists.txt
#
# Usage:
#   1. Build IREE (or install packages). You'll need `iree-compile` to include
#      support for the compiler target backend you wish to test and
#      `iree-e2e-matmul-test` to include support for the runtime HAL
#      driver/device you wish to test.
#   2. Update the paths in this script or specify them via environment variables
#   3. Run: `./run_matmul_tests.sh`

set -euo pipefail

ROOT_DIR=$(git rev-parse --show-toplevel)

OUTPUT_DIR="${IREE_MATMUL_BUILD_DIR:-build-matmul}"
GENERATOR="${ROOT_DIR}/tests/matmul/generate_e2e_matmul_tests.py"
IREE_PYTHON3_EXECUTABLE="${IREE_PYTHON3_EXECUTABLE:-python3}"

IREE_INSTALL_BIN="${IREE_INSTALL_BIN:-D:/dev/projects/iree-build/install/bin}"
IREE_COMPILE_EXE="${IREE_INSTALL_BIN}/iree-compile"
TEST_RUNNER="${IREE_INSTALL_BIN}/iree-e2e-matmul-test"

###############################################################################
# Setup and checking for dependencies                                         #
###############################################################################

echo "Python version: $("${IREE_PYTHON3_EXECUTABLE}" --version)"
echo "iree-compile version: $("${IREE_COMPILE_EXE}" --version)"
mkdir -p ${OUTPUT_DIR}

###############################################################################
# Define helper function                                                      #
###############################################################################

# This should be Python, CMake, or ... just... not Bash.
# Reference for named args: https://tecadmin.net/create-bash-functions-with-arguments/

function run_matmul_test() {
  local name=""
  local lhs_rhs_type=""
  local acc_type=""
  local shapes=""
  local target_backend=""
  local device=""

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --name)
        name="$2"
        shift 2
        ;;
      --lhs_rhs_type)
        lhs_rhs_type="$2"
        shift 2
        ;;
      --acc_type)
        acc_type="$2"
        shift 2
        ;;
      --shapes)
        shapes="$2"
        shift 2
        ;;
      --target_backend)
        target_backend="$2"
        shift 2
        ;;
      --device)
        device="$2"
        shift 2
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
  done

  set -x

  echo "**** Generating .mlir files ****"
  ${IREE_PYTHON3_EXECUTABLE} ${GENERATOR} \
      --output_matmuls_mlir="${OUTPUT_DIR}/${name}_matmuls.mlir" \
      --output_calls_mlir="${OUTPUT_DIR}/${name}_calls.mlir" \
      --lhs_rhs_type=${lhs_rhs_type} \
      --acc_type=${acc_type} \
      --shapes=${shapes}

  echo "**** Generating .vmfb files ****"
  ${IREE_COMPILE_EXE} \
      "${OUTPUT_DIR}/${name}_matmuls.mlir" \
      --iree-hal-target-backends=${target_backend} \
      -o "${OUTPUT_DIR}/${name}_matmuls.vmfb"
  ${IREE_COMPILE_EXE} \
      "${OUTPUT_DIR}/${name}_calls.mlir" \
      --iree-hal-target-backends=${target_backend} \
      -o "${OUTPUT_DIR}/${name}_calls.vmfb"

  echo "**** Running '${name}' matmul tests ****"
  echo ""

  ${TEST_RUNNER} \
      --module="${OUTPUT_DIR}/${name}_matmuls.vmfb" \
      --module="${OUTPUT_DIR}/${name}_calls.vmfb" \
      --device=${device}

  set +x
}

###############################################################################
# Run a few tests                                                             #
###############################################################################

run_matmul_test \
    --name "matmul_f32_f32_small_llvm-cpu_local-task" \
    --lhs_rhs_type "f32" \
    --acc_type "f32" \
    --shapes "small" \
    --target_backend "llvm-cpu" \
    --device "local-task"

run_matmul_test \
    --name "matmul_f32_f32_large_llvm-cpu_local-task" \
    --lhs_rhs_type "f32" \
    --acc_type "f32" \
    --shapes "large" \
    --target_backend "llvm-cpu" \
    --device "local-task"

run_matmul_test \
    --name "matmul_i8_i32_small_llvm-cpu_local-task" \
    --lhs_rhs_type "i8" \
    --acc_type "i32" \
    --shapes "small" \
    --target_backend "llvm-cpu" \
    --device "local-task"

run_matmul_test \
    --name "matmul_i8_i32_large_llvm-cpu_local-task" \
    --lhs_rhs_type "i8" \
    --acc_type "i32" \
    --shapes "large" \
    --target_backend "llvm-cpu" \
    --device "local-task"
