const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    // Greeter server
    const greeter_server = b.addExecutable("greeter_server", "src/greeter_server.zig");
    greeter_server.addPackagePath("clap", "deps/zig-clap/clap.zig");
    greeter_server.linkLibC();
    greeter_server.linkLibCpp();
    greeter_server.addIncludePath("bazel-bin/src/protos");
    greeter_server.setTarget(target);
    greeter_server.setBuildMode(mode);
    greeter_server.install();

    const run_greeter_server_cmd = greeter_server.run();
    run_greeter_server_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_greeter_server_cmd.addArgs(args);
    }

    const run_greeter_server_step = b.step("run_greeter_server", "Run the greeter_server app");
    run_greeter_server_step.dependOn(&run_greeter_server_cmd.step);

    const greeter_server_tests = b.addTest("src/greeter_server.zig");
    greeter_server_tests.setTarget(target);
    greeter_server_tests.setBuildMode(mode);

    const test_greeter_server_step = b.step("test_greeter_server", "Run unit tests");
    test_greeter_server_step.dependOn(&greeter_server_tests.step);

    // const c_flags = [_][]const u8{
    //     "-std=c++14",
    //     "-fvisibility=hidden",
    //     "-Wall",
    //     "-Werror=strict-prototypes",
    //     "-Werror=old-style-definition",
    //     "-Werror=missing-prototypes",
    //     "-Wno-missing-braces",
    //     // "-DBAZEL_BUILD=1"
    // };
        
    // Greeter client
    const greeter_client = b.addExecutable("greeter_client", "src/greeter_client.zig");
    greeter_client.addPackagePath("clap", "deps/zig-clap/clap.zig");
    greeter_client.linkLibC();
    greeter_client.linkLibCpp();
    
    greeter_client.addIncludePath("src/helloworld");
    greeter_client.addIncludePath("bazel-bin");
    greeter_client.addIncludePath("bazel-bin/src/protos");

    // build greeter client CC with zig; an alternative to linking against the bazel-built version.
    // note this doesn't quite work, as we'd need to link against more objectsin bazel-out manually.
    // greeter_client.defineCMacro("BAZEL_BUILD", "1");
    // greeter_client.addIncludePath("./");
    // greeter_client.addCSourceFile("src/helloworld/greeter_client.cc", &c_flags);
    // greeter_client.addIncludePath("bazel-zig-grpc-example/external/com_github_grpc_grpc/include");
    // greeter_client.addIncludePath("bazel-zig-grpc-example/external/com_google_absl");
    // greeter_client.addIncludePath("bazel-zig-grpc-example/external/com_google_protobuf/src");

    // hack: use a `cc_binary` linked with linkstatic and linkshared to build a self-contained .so:
    greeter_client.addObjectFile("bazel-bin/src/helloworld/libgreeter_client.so");
    // instead of the more obvious
    // greeter_client.addObjectFile("bazel-bin/src/helloworld/libgreeter_client.a");

    greeter_client.setTarget(target);
    greeter_client.setBuildMode(mode);
    greeter_client.install();

    const run_greeter_client_cmd = greeter_client.run();
    run_greeter_client_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_greeter_client_cmd.addArgs(args);
    }

    const run_greeter_client_step = b.step("run_greeter_client", "Run the greeter_client app");
    run_greeter_client_step.dependOn(&run_greeter_client_cmd.step);

    const greeter_client_tests = b.addTest("src/greeter_client.zig");
    greeter_client_tests.setTarget(target);
    greeter_client_tests.setBuildMode(mode);

    const greeter_client_test_step = b.step("test_greeter_client", "Run unit tests");
    greeter_client_test_step.dependOn(&greeter_client_tests.step);
}
