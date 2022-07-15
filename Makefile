.PHONY: build
build:
	bazel build //...
	zig build

.PHONY: run
run: build
	zig build run -- --port=8000

.PHONY: clean
clean:
	bazel clean
