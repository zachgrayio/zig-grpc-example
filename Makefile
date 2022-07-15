.PHONY: build
build: #clean
	bazel build //...
	zig build

.PHONY: run_greeters
run_greeters: run_greeter_server run_greeter_client

.PHONY: run_greeter_server
run_greeter_server: build
	zig build run_greeter_server -- --port=8000

.PHONY: run_greeter_client
run_greeter_client: build
	zig build run_greeter_client -- --port=8000

.PHONY: clean
clean:
	bazel clean
