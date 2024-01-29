#!/bin/bash
# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

# TODO(scotttodd): docs

set -euo pipefail

ROOT_DIR=$(git rev-parse --show-toplevel)

OUTPUT_DIR="${IREE_MATMUL_BUILD_DIR:-build-matmul}"
GENERATOR="${ROOT_DIR}/tests/matmul/generate_e2e_matmul_tests.py"
IREE_PYTHON3_EXECUTABLE="${IREE_PYTHON3_EXECUTABLE:-python3}"

IREE_INSTALL_BIN="D:/dev/projects/iree-build/install/bin"
IREE_COMPILE_EXE="${IREE_INSTALL_BIN}/iree-compile"
TEST_RUNNER="${IREE_INSTALL_BIN}/iree-e2e-matmul-test"

###############################################################################
# Setup and checking for dependencies                                         #
###############################################################################

echo "Python version: $("${IREE_PYTHON3_EXECUTABLE}" --version)"
echo "iree-compile version: $("${IREE_COMPILE_EXE}" --version)"
mkdir -p ${OUTPUT_DIR}

###############################################################################
# Generate .mlir files                                                        #
###############################################################################

echo "**** Generating .mlir files ****"
${IREE_PYTHON3_EXECUTABLE} ${GENERATOR} \
    --output_matmuls_mlir="${OUTPUT_DIR}/small_matmuls.mlir" \
    --output_calls_mlir="${OUTPUT_DIR}/small_calls.mlir" \
    --lhs_rhs_type=f32 \
    --acc_type=f32 \
    --shapes=small

###############################################################################
# Generate .vmfb files                                                        #
###############################################################################

echo "**** Generating .vmfb files ****"

# matmuls_module
${IREE_COMPILE_EXE} \
    "${OUTPUT_DIR}/small_matmuls.mlir" \
    --iree-hal-target-backends=llvm-cpu \
    -o "${OUTPUT_DIR}/small_matmuls_llvm-cpu.vmfb"

# calls_module
${IREE_COMPILE_EXE} \
    "${OUTPUT_DIR}/small_calls.mlir" \
    --iree-hal-target-backends=llvm-cpu \
    -o "${OUTPUT_DIR}/small_calls_llvm-cpu.vmfb"

###############################################################################
# Launch test runner with .vmfb files                                         #
###############################################################################

echo "**** Running matmul tests ****"
echo ""

${TEST_RUNNER} \
    --module="${OUTPUT_DIR}/small_matmuls_llvm-cpu.vmfb" \
    --module="${OUTPUT_DIR}/small_calls_llvm-cpu.vmfb" \
    --device=local-task
