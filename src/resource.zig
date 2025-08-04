const std = @import("std");

pub fn Resource(comptime T: type) type {
    if (!@hasField(T, "resourceType")) {
        @compileError("FHIR resource must contain a 'resourceType'.");
    }

    return struct {
        const Self = @This();

        pub fn getResourceType() []const u8 {
            const default_instance = T{};
            return default_instance.resourceType;
        }
    };
}

pub fn OperationResult(comptime T: type) type {
    return struct {
        const Self = @This();

        resource: ?T = null,
        status_code: u16,
        success: bool,

        pub fn init() Self {
            return Self{
                .status_code = 0,
                .success = false,
            };
        }

        pub fn isSuccess(self: Self) bool {
            return self.success and self.status_code >= 200 and self.status_code < 300;
        }
    };
}

test "basic resource test" {
    const Patient = @import("model/patient.zig");
    const PatientResource = Resource(Patient);

    const resource_name = PatientResource.getResourceType();
    try std.testing.expect(std.mem.eql(u8, resource_name, "Patient"));
}

test "basic OperationResult test" {
    const Patient = @import("model/patient.zig");
    const PatientResource = Resource(Patient);

    var result = OperationResult(PatientResource).init();

    try std.testing.expect(!result.isSuccess());

    result.success = true;
    result.status_code = 200;

    try std.testing.expect(result.isSuccess());
}
