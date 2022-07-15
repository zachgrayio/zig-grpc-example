# zig-grpc-example

Noob attempt at getting up and running with gRPC and Zig.

## Prerequisites

- Zig code requires latest `zig` built from source against `master` or installed via homebrew with `brew install zig --HEAD`. If errors occur during installation, get latest Xcode on macOS.  
- gRPC and proto code is built with Bazel; install with `brew install bazelisk`

## Running

### Greeter client & server
- In a terminal, `make run_greeters -j2`