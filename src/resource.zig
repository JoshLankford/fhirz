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

test "basic resource test" {
    const Patient = @import("model/patient.zig");
    const PatientResource = Resource(Patient.Patient);

    const resource_name = PatientResource.getResourceType();
    try std.testing.expect(std.mem.eql(u8, resource_name, "Patient"));
}
