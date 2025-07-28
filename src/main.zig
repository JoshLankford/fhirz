const std = @import("std");
const config = @import("config.zig");
const request = @import("request.zig");
const Patient = @import("model/patient.zig");
const Client = @import("client.zig");

fn postPatient(server: []const u8, payload: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var req = request.Request.init(allocator);
    defer req.deinit();

    const url = try std.fmt.allocPrint(allocator, "{s}/fhir/Patient", .{server});
    defer allocator.free(url);

    const result = try req.post(url, payload);

    std.debug.print("Status: {d}\n", .{result.status});
    std.debug.print("Response Body:\n{s}\n", .{req.response_body.items});
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

fn createTestPatient(allocator: std.mem.Allocator) ![]const u8 {
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

    const patient_json = try std.json.stringifyAlloc(allocator, patient, .{});
    return patient_json;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const parsed = try config.readConfig(allocator, "config.json");
    defer parsed.deinit();

    const parsed_config = parsed.value;
    std.debug.print("parsed_config.fhir_server: {s}\n", .{parsed_config.fhir_server});

    const patient = try createTestPatient(allocator);
    defer allocator.free(patient);
    try postPatient(parsed_config.fhir_server, patient);
    try getGeneric(parsed_config.fhir_server);
}
