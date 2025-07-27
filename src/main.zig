const std = @import("std");
const Request = @import("request.zig").Request;
const Patient = @import("model/patient.zig");

fn getPatient(id: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var req = Request.init(allocator);
    defer req.deinit();

    const url = try std.fmt.allocPrint(allocator, "http://localhost:8080/fhir/Patient/{s}", .{id});
    defer allocator.free(url);

    const result = try req.get(url);

    std.debug.print("Status: {d}\n", .{result.status});
    std.debug.print("Response Body:\n{s}\n", .{req.response_body.items});

    if (result.status == .ok) {
        const parsed = try std.json.parseFromSlice(Patient.Patient, allocator, req.response_body.items, .{});
        defer parsed.deinit();

        const patient: Patient.Patient = parsed.value;
        std.debug.print("Patient:\n{}\n", .{patient});
    } else {
        std.debug.print("Failed to retrieve patient. Status: {d}\n", .{result.status});
    }
}

fn postPatient(payload: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var req = Request.init(allocator);
    defer req.deinit();

    const result = try req.post("http://localhost:8080/fhir/Patient", payload);

    std.debug.print("Status: {d}\n", .{result.status});
    std.debug.print("Response Body:\n{s}\n", .{req.response_body.items});
}

fn createTestPatient() ![]const u8 {
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

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const patient_json = try std.json.stringifyAlloc(allocator, patient, .{});
    defer allocator.free(patient_json);

    return patient_json;
}

pub fn main() !void {
    const patient = try createTestPatient();
    try postPatient(patient);
    try getPatient("1");
}
