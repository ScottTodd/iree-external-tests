# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

message(STATUS "IREE_EXTERNAL_TESTS::tests/CMakeLists.txt")

add_subdirectory(hal-cts)
add_subdirectory(e2e)
add_subdirectory(matmul)
