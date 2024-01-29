# IREE external tests

Experimenting with running IREE test suites from external projects (projects
using `-DIREE_CMAKE_PLUGIN_PATHS=<dir1;dir2>`, especially those that define
custom compiler target backends and runtime HAL drivers).

Potential test suites of interest:

* [`tests/e2e/matmul/`](https://github.com/openxla/iree/tree/main/tests/e2e/matmul)
* [`runtime/src/iree/hal/cts/`](https://github.com/openxla/iree/tree/main/runtime/src/iree/hal/cts)
* 'check' test suites like [`tests/e2e/tosa_ops/`](https://github.com/openxla/iree/tree/main/tests/e2e/tosa_ops)
* (As an example of a Python test suite) [`integrations/tensorflow/test/iree_tfl_tests/`](https://github.com/openxla/iree/tree/main/integrations/tensorflow/test/iree_tfl_tests)

## Build/repro steps

With this directory structure:
```
D:\dev\projects\iree                   (Main IREE project)
D:\dev\projects\iree-external-tests    (This project)
D:\dev\projects\iree-xb                (Build directory, short path because Windows...)
```

Configure using plugins from this project:
```
D:\dev\projects\iree-external-tests
λ cmake -G Ninja -B ../iree-xb ../iree -DIREE_CMAKE_PLUGIN_PATHS=D:\dev\projects\iree-external-tests -DIREE_BUILD_SAMPLES=OFF
```

Build test deps:
```
D:\dev\projects\iree-external-tests
λ cmake --build ../iree-xb --target iree-test-deps
```

Find tests, run a test:
```
D:\dev\projects\iree-external-tests
λ ctest --test-dir ../iree-xb -N | grep external
  Test #1038: iree/../iree-external-tests/tests/e2e/check_external_llvm-cpu_local-task_abs.mlir
  Test #1039: iree/../iree-external-tests/tests/e2e/check_external_llvm-cpu_local-task_add.mlir

D:\dev\projects\iree-external-tests
λ ctest --test-dir ../iree-xb -R iree/../iree-external-tests/tests/e2e/check_external_llvm-cpu_local-task_abs.mlir
Internal ctest changing into directory: D:/dev/projects/iree-xb
Test project D:/dev/projects/iree-xb
    Start 1038: iree/../iree-external-tests/tests/e2e/check_external_llvm-cpu_local-task_abs.mlir
1/1 Test #1038: iree/../iree-external-tests/tests/e2e/check_external_llvm-cpu_local-task_abs.mlir ...   Passed    0.11 sec

100% tests passed, 0 tests failed out of 1

Label Time Summary:
driver=local-task                        =   0.11 sec*proc (1 test)
iree/../iree-external-tests/tests/e2e    =   0.11 sec*proc (1 test)

Total Test time (real) =   0.31 sec
```
