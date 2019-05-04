#/bin/bash

go get github.com/buchgr/bazel-remote
go run github.com/buchgr/bazel-remote --dir ${HOME}/bazel_cache --host 127.0.0.1 --port 28080 --max_size 64
