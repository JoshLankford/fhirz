const std = @import("std");

pub const Client = @import("client.zig").Client;

pub const Resource = @import("resource.zig").Resource;
pub const OperationResult = @import("resource.zig").OperationResult;

pub const Request = @import("request.zig").Request;

pub const Patient = @import("model/patient.zig").Patient;

pub const HumanName = @import("model/patient.zig").HumanName;
pub const Identifier = @import("model/patient.zig").Identifier;
pub const ContactPoint = @import("model/patient.zig").ContactPoint;
pub const Address = @import("model/patient.zig").Address;
pub const AdministrativeGender = @import("model/patient.zig").AdministrativeGender;
pub const Period = @import("model/patient.zig").Period;
pub const Reference = @import("model/patient.zig").Reference;
pub const MaritalStatus = @import("model/patient.zig").MaritalStatus;
pub const Contact = @import("model/patient.zig").Contact;
pub const Communication = @import("model/patient.zig").Communication;
pub const Language = @import("model/patient.zig").Language;

pub const Meta = @import("model/patient.zig").Meta;
pub const ResourceType = @import("model/patient.zig").ResourceType;

pub fn createPatientClient(allocator: std.mem.Allocator, server_url: []const u8) Client(Patient) {
    return Client(Patient).init(allocator, server_url);
}

pub fn createMinimalPatient() Patient {
    return Patient{
        .resourceType = "Patient",
    };
}

test "fhirz exports" {
    const testing = std.testing;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = createPatientClient(allocator, "http://example.com/fhir");
    defer client.deinit();

    const patient = createMinimalPatient();
    try testing.expectEqualStrings("Patient", patient.resourceType);

    var result = OperationResult(Patient).init();
    try testing.expect(!result.isSuccess());

    result.success = true;
    result.status_code = 200;
    try testing.expect(result.isSuccess());
}
