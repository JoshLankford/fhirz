const std = @import("std");
const config = @import("config.zig");
const request = @import("request.zig");
const Patient = @import("model/patient.zig");
const Client = @import("client.zig");

fn updateGeneric(server: []const u8, payload: Patient.Patient) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = Client.Client(Patient.Patient).init(allocator, server);
    defer client.deinit();

    var result = client.update("1", payload) catch |err| {
        std.debug.print("Failed to update patient: {}\n", .{err});
        return;
    };

    if (result.isSuccess()) {
        std.debug.print("✓ Patient updated successfully! Status: {d}\n", .{result.status_code});
        if (result.resource) |updated_patient| {
            std.debug.print("Updated patient: {}\n", .{updated_patient});
        }
    } else {
        std.debug.print("✗ Failed to update patient. Status: {d}\n", .{result.status_code});
    }
}

fn createGeneric(server: []const u8, payload: Patient.Patient) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create a generic FHIR client for Patient resources
    var client = Client.Client(Patient.Patient).init(allocator, server);
    defer client.deinit();

    var result = client.create(payload) catch |err| {
        std.debug.print("Failed to create patient: {}\n", .{err});
        return;
    };

    if (result.isSuccess()) {
        std.debug.print("✓ Patient created successfully! Status: {d}\n", .{result.status_code});
        if (result.resource) |created_patient| {
            std.debug.print("Created patient: {}\n", .{created_patient});
        }
    } else {
        std.debug.print("✗ Failed to create patient. Status: {d}\n", .{result.status_code});
    }
}

fn getGeneric(server: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create a generic FHIR client for Patient resources
    var client = Client.Client(Patient.Patient).init(allocator, server);
    defer client.deinit();

    var result = client.get("1") catch |err| {
        std.debug.print("Failed to get patient: {}", .{err});
        return;
    };

    if (result.isSuccess()) {
        std.debug.print("Patient retrieved successfully. Status: {d}\n", .{result.status_code});
        if (result.resource) |patient| {
            std.debug.print("Retrieved patient: {}\n", .{patient});
        }
    } else {
        std.debug.print("Failed to retrieve patient. Status: {d}\n", .{result.status_code});
    }
}

fn createTestPatient() Patient.Patient {
    var identifiers = [_]Patient.Identifier{.{ .use = "official", .value = "18675309" }};
    var given_names = [_][]const u8{"John"};
    var names = [_]Patient.HumanName{.{ .use = "official", .family = "Doe", .given = given_names[0..] }};

    const patient: Patient.Patient = .{
        .resourceType = "Patient",
        .identifier = identifiers[0..],
        .name = names[0..],
        .gender = .male,
        .birthDate = "1980-04-01",
    };

    return patient;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const parsed = try config.readConfig(allocator, "config.json");
    defer parsed.deinit();

    const parsed_config = parsed.value;
    std.debug.print("parsed_config.fhir_server: {s}\n", .{parsed_config.fhir_server});

    const patient = createTestPatient();

    try createGeneric(parsed_config.fhir_server, patient);
    try updateGeneric(parsed_config.fhir_server, patient);
    try getGeneric(parsed_config.fhir_server);
}
