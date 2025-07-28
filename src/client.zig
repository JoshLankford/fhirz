const std = @import("std");
const request = @import("request.zig");
const resource = @import("resource.zig");

pub fn Client(comptime ResourceType: type) type {
    const ResourceInterface = resource.Resource(ResourceType);

    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        http_client: request.Request,
        server: []const u8,

        pub fn init(allocator: std.mem.Allocator, server: []const u8) Self {
            return Self{
                .allocator = allocator,
                .http_client = request.Request.init(allocator),
                .server = server,
            };
        }

        pub fn deinit(self: *Self) void {
            self.http_client.deinit();
        }

        fn buildResourceUrl(self: *Self) ![]const u8 {
            const resource_type = ResourceInterface.getResourceType();

            return std.fmt.allocPrint(self.allocator, "{s}/fhir/{s}", .{
                self.server,
                resource_type,
            });
        }
    };
}

test "resource_url test" {
    const config = @import("config.zig");
    const Patient = @import("model/patient.zig");

    const allocator = std.testing.allocator;

    const test_config = try config.readConfig(allocator, "config.json");
    defer test_config.deinit();

    const server = test_config.value.fhir_server;

    var client = Client(Patient.Patient).init(allocator, server);
    defer client.deinit();

    const expected_url = try std.fmt.allocPrint(allocator, "{s}/fhir/Patient", .{server});
    defer allocator.free(expected_url);

    const resource_url = try client.buildResourceUrl();
    defer allocator.free(resource_url);

    try std.testing.expect(std.mem.eql(u8, resource_url, expected_url));
}
