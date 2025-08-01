const std = @import("std");
const request = @import("request.zig");
const resource = @import("resource.zig");

const ClientError = error{
    ResourceAlreadyHasId,
    ResourceMissingId,
    ResourceIdMismatch,
};

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

        fn buildResourceUrl(self: *Self, id: ?[]const u8) ![]const u8 {
            const resource_type = ResourceInterface.getResourceType();

            if (id) |resource_id| {
                return std.fmt.allocPrint(self.allocator, "{s}/{s}/{s}", .{
                    self.server,
                    resource_type,
                    resource_id,
                });
            } else {
                return std.fmt.allocPrint(self.allocator, "{s}/{s}", .{
                    self.server,
                    resource_type,
                });
            }
        }

        pub fn get(self: *Self, id: []const u8) !resource.OperationResult(ResourceType) {
            const url = try self.buildResourceUrl(id);
            defer self.allocator.free(url);

            var result = resource.OperationResult(ResourceType).init();

            const http_result = self.http_client.get(url) catch {
                result.success = false;
                result.status_code = 0;
                return result;
            };

            result.status_code = @intFromEnum(http_result.status);
            result.success = http_result.status == .ok;

            if (result.success) {
                const parsed = std.json.parseFromSlice(ResourceType, self.allocator, self.http_client.response_body.items, .{}) catch {
                    result.success = false;
                    return result;
                };
                defer parsed.deinit();

                result.resource = parsed.value;
            }

            return result;
        }

        pub fn create(self: *Self, resource_type: ResourceType) !resource.OperationResult(ResourceType) {
            // Reject resources that already have an ID - FHIR servers should assign IDs during creation
            if (resource_type.id != null) {
                return ClientError.ResourceAlreadyHasId;
            }

            const url = try self.buildResourceUrl(null);
            defer self.allocator.free(url);

            var out: std.io.Writer.Allocating = .init(self.allocator);
            defer out.deinit();
            var write_stream: std.json.Stringify = .{
                .writer = &out.writer,
                .options = .{},
            };
            try write_stream.write(resource_type);

            var result = resource.OperationResult(ResourceType).init();

            const http_result = self.http_client.post(url, out.getWritten()) catch {
                result.success = false;
                result.status_code = 0;
                return result;
            };

            result.status_code = @intFromEnum(http_result.status);
            result.success = http_result.status == .created or http_result.status == .ok;

            if (result.success and self.http_client.response_body.items.len > 0) {
                const parsed = std.json.parseFromSlice(ResourceType, self.allocator, self.http_client.response_body.items, .{}) catch {
                    // Creation succeeded but parsing response failed - still consider it a success
                    result.resource = resource_type;
                    return result;
                };
                defer parsed.deinit();

                result.resource = parsed.value;
            } else if (result.success) {
                // Creation succeeded but no response body - use the original resource
                result.resource = resource_type;
            }

            return result;
        }

        pub fn update(self: *Self, id: []const u8, resource_type: ResourceType) !resource.OperationResult(ResourceType) {
            // Strict validation: resource must have an ID that matches the parameter
            const resource_id = resource_type.id orelse return ClientError.ResourceMissingId;

            if (!std.mem.eql(u8, id, resource_id)) {
                return ClientError.ResourceIdMismatch;
            }

            const url = try self.buildResourceUrl(id);
            defer self.allocator.free(url);

            var out: std.io.Writer.Allocating = .init(self.allocator);
            defer out.deinit();
            var write_stream: std.json.Stringify = .{
                .writer = &out.writer,
                .options = .{},
            };
            try write_stream.write(resource_type);

            var result = resource.OperationResult(ResourceType).init();

            const http_result = self.http_client.put(url, out.getWritten()) catch {
                result.success = false;
                result.status_code = 0;
                return result;
            };

            result.status_code = @intFromEnum(http_result.status);
            result.success = http_result.status == .ok or http_result.status == .created;

            if (result.success and self.http_client.response_body.items.len > 0) {
                const parsed = std.json.parseFromSlice(ResourceType, self.allocator, self.http_client.response_body.items, .{}) catch {
                    // Update succeeded but parsing response failed
                    result.resource = resource_type;
                    return result;
                };
                defer parsed.deinit();

                result.resource = parsed.value;
            } else if (result.success) {
                result.resource = resource_type;
            }

            return result;
        }

        pub fn delete(self: *Self, id: []const u8) !resource.OperationResult(ResourceType) {
            const url = try self.buildResourceUrl(id);
            defer self.allocator.free(url);

            var result = resource.OperationResult(ResourceType).init();

            const http_result = self.http_client.delete(url) catch {
                result.success = false;
                result.status_code = 0;
                return result;
            };

            result.status_code = @intFromEnum(http_result.status);
            result.success = http_result.status == .no_content or http_result.status == .ok;

            return result;
        }
    };
}

test "resource_url test" {
    const Patient = @import("model/patient.zig");

    const allocator = std.testing.allocator;

    var client = Client(Patient.Patient).init(allocator, "http://localhost:8080/fhir");
    defer client.deinit();

    const expected_url = try std.fmt.allocPrint(allocator, "{s}/Patient", .{"http://localhost:8080/fhir"});
    defer allocator.free(expected_url);

    const resource_url = try client.buildResourceUrl(null);
    defer allocator.free(resource_url);

    try std.testing.expect(std.mem.eql(u8, resource_url, expected_url));
}
