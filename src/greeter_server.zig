const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const grpc = global.grpc;

pub fn main() !void {
    std.log.debug("Greeter Server", .{});
    const args = try cli.parseArgs();
    std.log.debug("port {}", .{args.port});
}
