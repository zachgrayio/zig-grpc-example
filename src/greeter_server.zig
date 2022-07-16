const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const fmt = std.fmt;
const debug = std.log.debug;
const grpc = global.grpc;
const c_greeter = global.greeter;

pub fn main() !void {
    const args = try cli.parseArgs();
    var sb = [_]u8{0} ** 14;
    const server_address = try fmt.bufPrint(&sb, "0.0.0.0:{any}", .{args.port});

    const greeter_server = c_greeter.greeter_server_create(server_address.ptr);
    defer c_greeter.greeter_server_destroy(&greeter_server.?.*);

    debug("Greeter Server - Starting on {s}", .{server_address});

    c_greeter.greeter_server_start(&greeter_server.?.*);
    debug("server exited", .{});
}
