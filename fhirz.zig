const std = @import("std");

pub const Client = @import("src/client.zig").Client;

pub const Config = @import("src/config.zig").Config;
pub const readConfig = @import("src/config.zig").readConfig;

pub const Resource = @import("src/resource.zig").Resource;
pub const OperationResult = @import("src/resource.zig").OperationResult;

pub const Request = @import("src/request.zig").Request;

pub const Patient = @import("src/model/patient.zig").Patient;

pub const HumanName = @import("src/model/patient.zig").HumanName;
pub const Identifier = @import("src/model/patient.zig").Identifier;
pub const ContactPoint = @import("src/model/patient.zig").ContactPoint;
pub const Address = @import("src/model/patient.zig").Address;
pub const AdministrativeGender = @import("src/model/patient.zig").AdministrativeGender;
pub const Period = @import("src/model/patient.zig").Period;
pub const Reference = @import("src/model/patient.zig").Reference;
pub const MaritalStatus = @import("src/model/patient.zig").MaritalStatus;
pub const Contact = @import("src/model/patient.zig").Contact;
pub const Communication = @import("src/model/patient.zig").Communication;
pub const Language = @import("src/model/patient.zig").Language;

pub const Meta = @import("src/model/patient.zig").Meta;
pub const ResourceType = @import("src/model/patient.zig").ResourceType;

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
