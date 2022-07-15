const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const fmt = std.fmt;
const debug = std.log.debug;
const grpc = global.grpc;
const greeter_client = global.greeter_client;

pub fn main() !void {
    const alloc = std.heap.c_allocator;
    const args = try cli.parseArgs();
    const target = try fmt.allocPrint(alloc, "0.0.0.0:{any}", .{args.port});
    defer alloc.free(target);
    debug("Greeter Client - Dialing {s}", .{target});

    var i: i16 = 1;
    while (i <= 100) : (i += 1) {
        const user = try fmt.allocPrint(alloc, "Elfo_{}", .{i});
        defer alloc.free(user);
        const response: [*c]const u8 = greeter_client.sayHello(target.ptr, user.ptr);
        debug("response: {s}", .{response});
    }
    debug("client finished; kill server with CTRL+C?", .{});
}
