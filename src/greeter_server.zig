const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const fmt = std.fmt;
const debug = std.log.debug;
const grpc = global.grpc;
const greeter_server = global.greeter_server;

pub fn main() !void {
    const alloc = std.heap.c_allocator;
    const args = try cli.parseArgs();
    const server_address = try fmt.allocPrint(alloc, "0.0.0.0:{any}", .{args.port});
    defer alloc.free(server_address);
    debug("Greeter Server - Running on {s}", .{server_address});
    const res: c_int = greeter_server.runBlocking(server_address.ptr); // this call blocks
    debug("server exited with code {any}", .{res});
}
