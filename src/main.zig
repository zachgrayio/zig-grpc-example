const cli = @import("cli.zig");
const zig_grpc_example = @import("global.zig");
const std = @import("std");

pub fn main() !void {
    const args = try cli.parseArgs();
    std.log.debug("port {}", .{args.port});
}
