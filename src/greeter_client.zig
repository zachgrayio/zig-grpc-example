const cli = @import("cli.zig");
const global = @import("global.zig");
const std = @import("std");

const fmt = std.fmt;
const debug = std.log.debug;
const grpc = global.grpc;
const c_greeter = global.greeter;

pub fn main() !void {
    const args = try cli.parseArgs();
    var tb = [_]u8{undefined} ** 14;
    var target = try fmt.bufPrint(&tb, "0.0.0.0:{d}", .{args.port});

    debug("Greeter Client - Dialing {s}", .{target});
    const greeter_client = c_greeter.greeter_client_create(target.ptr);
    defer c_greeter.greeter_client_destroy(&greeter_client.?.*);

    var i: c_int = 1;
    while (i <= 10000) : (i += 1) {
        var nb = [_]u8{0} ** 15;
        var user = try fmt.bufPrint(&nb, "Elfo #{d}", .{i}); // hi, im Elfo!
        var response: [*c]const u8 = c_greeter.greeter_client_say_hello(&greeter_client.?.*, user.ptr);
        debug("\n  client said 'hi, im {s}'\n  server replied '{s}'", .{user, response});
    }
    debug("client finished; kill server with CTRL+C?", .{});
}
