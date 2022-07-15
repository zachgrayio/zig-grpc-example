const clap = @import("clap");
const std = @import("std");

const io = std.io;

pub const Fs3Args = struct {
    port: u16,
};

pub fn parseArgs() !*Fs3Args {
    const params = comptime clap.parseParamsComptime(
        \\-p, --port <u16>   Port to listen on.
    );
    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
    }) catch |err| {
        diag.report(io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();
    var args = Fs3Args{
        .port = 3000,
    };
    if (res.args.port) |n|
        args.port = n;
    return &args;
}