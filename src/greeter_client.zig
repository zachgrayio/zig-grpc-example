const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const fmt = std.fmt;
const debug = std.log.debug;
const grpc = global.grpc;
const greeter_client = global.greeter_client;

pub fn main() !void {
    const args = try cli.parseArgs();
    var tb = [_]u8{undefined} ** 14;
    var target = try fmt.bufPrint(&tb, "0.0.0.0:{d}", .{args.port});
    debug("Greeter Client - Dialing {s}", .{target});

    var i: c_int = 1;
    while (i <= 100) : (i += 1) {
        var nb = [_]u8{0} ** 10;
        var user = try fmt.bufPrint(&nb, "Elfo #{d}", .{i});
        var response: [*c]const u8 = greeter_client.sayHello(target.ptr, user.ptr);
        debug("response: '{s}'", .{response});
    }
    debug("client finished; kill server with CTRL+C?", .{});
}
