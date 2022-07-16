const std = @import("std");

fn commonExeConfig(exe: *std.build.LibExeObjStep, bazel_obj_name: [] const u8) !void {
    exe.addPackagePath("clap", "deps/zig-clap/clap.zig");
    exe.linkLibC();
    exe.linkLibCpp();
    exe.addIncludePath("src/helloworld");
    exe.addIncludePath("bazel-bin");
    exe.addIncludePath("bazel-bin/src/protos");

    var buf: [200]u8 = undefined;
    const bufs = buf[0..];
    // hack: use a `cc_binary` linked with linkstatic and linkshared to build a self-contained .so:
    const obj_file = try std.fmt.bufPrint(bufs, "bazel-bin/src/helloworld/lib{s}.so", .{bazel_obj_name});
    exe.addObjectFile(obj_file);
}

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
    var greeter_server = b.addExecutable("greeter_server", "src/greeter_server.zig");
    commonExeConfig(greeter_server, "greeter_server") catch |err| {
        std.log.err("build error: {e}", .{err});
    };
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

    // Greeter client
    const greeter_client = b.addExecutable("greeter_client", "src/greeter_client.zig");
    commonExeConfig(greeter_client, "greeter_client") catch |err| {
        std.log.err("build error: {e}", .{err});
    };
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
