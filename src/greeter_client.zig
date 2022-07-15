const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const debug = std.log.debug;
const grpc = global.grpc;
const greeter_client = global.greeter_client;

pub fn main() !void {
    debug("Greeter Client", .{});
    const args = try cli.parseArgs();
    debug("port {}", .{args.port});
    const target: [*c]const u8 = "localhost:3000";
    const user: [*c]const u8 = "world";
    debug("calling CC...", .{});
    const response: [*c]const u8 = greeter_client.sayHello(target.*, user.*);
    debug("response: {s}", .{response});
}
