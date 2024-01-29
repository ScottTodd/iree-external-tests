# Copyright 2024 The IREE Authors
#
# Licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

message(STATUS "IREE_EXTERNAL_TESTS::iree_compiler_plugin.cmake")

# find_package(Boost REQUIRED)
# include_directories(${Boost_INCLUDE_DIRS})

set(IREE_EXTERNAL_TESTS_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}")
# add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/compiler/plugins/target/AMD-AIE target/AMD-AIE)
# add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/tools/plugins AMD-AIE/tools)
# add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/tests/samples AMD-AIE/tests/samples)

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/compiler/plugins/target/VMVXExternal target/VMVXExternal)

# This writes to D:\dev\projects\iree-xb\compiler\plugins\external\tests
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/tests external/tests)
