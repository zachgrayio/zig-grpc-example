# Note: Bazel is only used for CC and gRPC
workspace(name = "com_github_zachgrayio_zig_grpc_example")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Todo: Use Zig as a hermetic CC toolchain under Bazel:
# BAZEL_ZIG_CC_VERSION = "v0.8.2"
# http_archive(
#     name = "bazel-zig-cc",
#     sha256 = "216ee0e15417aa7ed3d1cb4627485fd00ae142e6bba10d3bcad1590e99e13e4c",
#     strip_prefix = "bazel-zig-cc-{}".format(BAZEL_ZIG_CC_VERSION),
#     urls = ["https://git.sr.ht/~motiejus/bazel-zig-cc/archive/{}.tar.gz".format(BAZEL_ZIG_CC_VERSION)],
# )
# load("@bazel-zig-cc//toolchain:defs.bzl", zig_toolchains = "toolchains")
# # https://dl.jakstys.lt/zig/zig-macos-aarch64-0.10.0-dev.2977+7d2e14267.tar.xz
# zig_toolchains(
#     version = "0.10.0-dev.2977+7d2e14267",
#     host_platform_sha256 = {
#        "macos-aarch64": "19b69c1b720f9694b6564ccd47cd15670b548e91c5e86c3906534bec5cc7c5ab",     
#     },
# )
# register_toolchains(
#     "@zig_sdk//toolchain:linux_amd64_gnu.2.19",
#     "@zig_sdk//toolchain:linux_arm64_gnu.2.28",
#     "@zig_sdk//toolchain:darwin_amd64",
#     "@zig_sdk//toolchain:darwin_arm64",
#     "@zig_sdk//toolchain:windows_amd64",
#     "@zig_sdk//toolchain:windows_arm64",
# )

# gRPC
http_archive(
    name = "com_github_grpc_grpc",
    urls = [
        "https://github.com/grpc/grpc/archive/b590d192dc9e3e048af1a2d3d88c827b8c5834bb.tar.gz",
    ],
    strip_prefix = "grpc-b590d192dc9e3e048af1a2d3d88c827b8c5834bb",
)
load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")
grpc_deps()
load("@com_github_grpc_grpc//bazel:grpc_extra_deps.bzl", "grpc_extra_deps")
grpc_extra_deps()
