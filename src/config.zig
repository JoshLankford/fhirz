const std = @import("std");

pub const Config = struct {
    fhir_server: []const u8,
};

pub fn readConfig(allocator: std.mem.Allocator, path: []const u8) !std.json.Parsed(Config) {
    // 512 is the maximum size to read, if your config is larger
    // you should make this bigger.
    const data = try std.fs.cwd().readFileAlloc(allocator, path, 512);
    defer allocator.free(data);
    return std.json.parseFromSlice(Config, allocator, data, .{ .allocate = .alloc_always });
}
