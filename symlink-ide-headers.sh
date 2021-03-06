#/bin/bash

# This script symlinks bazel's output base into the root of the workspace
# as a directory '/tmp/nighthawk_bazel_output_base'. This can be used by IDE's to
# get to the header files of dependencies.
# See .vscode/c_cpp_properties.json for an example.

set -e

if [ -f envoy-perf.code-workspace ]; then
    cd nighthawk
    target=$(bazel info output_base)
    ln -sf "$target/external/" external
    echo "Symlinked $target to $(pwd)/external"
else
    echo "This script should be executed from the git root"
    exit 1
fi
