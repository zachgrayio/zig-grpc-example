const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const fmt = std.fmt;
const debug = std.log.debug;
const grpc = global.grpc;
const greeter_server = global.greeter_server;

pub fn main() !void {
    const args = try cli.parseArgs();
    var sb = [_]u8{0} ** 14;
    const server_address = try fmt.bufPrint(&sb, "0.0.0.0:{any}", .{args.port});
    debug("Greeter Server - Running on {s}", .{server_address});
    const res: c_int = greeter_server.runBlocking(server_address.ptr); // this call blocks
    debug("server exited with code {any}", .{res});
}
