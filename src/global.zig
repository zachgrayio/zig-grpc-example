const std = @import("std");
const c = std.c;

pub const grpc = @cImport({
    @cDefine("BAZEL_BUILD", 1);
    @cInclude("helloworld.pb.h");
    @cInclude("helloworld.grpc.pb.h");
    @cInclude("keyvaluestore.pb.h");
    @cInclude("keyvaluestore.grpc.pb.h");
});

pub const greeter_client = @cImport({
    @cInclude("greeter_client.h");
});
