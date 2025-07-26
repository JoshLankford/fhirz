const std = @import("std");
const http = std.http;

pub const Request = struct {
    const Self = @This();
    allocator: std.mem.Allocator,
    http_client: http.Client,
    response_body: std.ArrayList(u8),

    pub fn init(allocator: std.mem.Allocator) Self {
        return Self{
            .allocator = allocator,
            .http_client = http.Client{ .allocator = allocator },
            .response_body = std.ArrayList(u8).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.http_client.deinit();
        self.response_body.deinit();
    }

    pub fn get(self: *Self, url: []const u8) !http.Client.FetchResult {
        const result = try self.http_client.fetch(.{
            .method = .GET,
            .location = .{ .url = url },
            .response_storage = .{ .dynamic = &self.response_body },
        });

        return result;
    }

    pub fn post(self: *Self, url: []const u8, payload: []const u8) !http.Client.FetchResult {
        const result = try self.http_client.fetch(.{
            .method = .POST,
            .location = .{ .url = url },
            .extra_headers = &[_]http.Header{
                .{ .name = "Content-Type", .value = "application/json" },
            },
            .payload = payload,
            .response_storage = .{ .dynamic = &self.response_body },
        });

        return result;
    }
};
