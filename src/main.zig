const std = @import("std");
const print = std.debug.print;
const http = std.http;

const Patient = @import("model/patient.zig").Patient;

fn getPatient() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    var response_body = std.ArrayList(u8).init(allocator);
    defer response_body.deinit();

    const result = try client.fetch(.{
        .method = .GET,
        .location = .{ .url = "http://localhost:8080/fhir/Patient/1" },
        .response_storage = .{ .dynamic = &response_body },
    });

    std.debug.print("Status: {d}\n", .{result.status});
    std.debug.print("Response Body:\n{s}\n", .{response_body.items});

    const parsed = try std.json.parseFromSlice(Patient, allocator, response_body.items, .{});
    defer parsed.deinit();

    const patient: Patient = parsed.value;
    std.debug.print("Patient:\n{}\n", .{patient});
}

fn createPatient() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    const payload =
        \\{
        \\  "resourceType": "Patient",
        \\  "identifier": [
        \\    {
        \\      "use": "official",
        \\      "value": "18675309"
        \\    }
        \\  ],
        \\  "name": [
        \\    {
        \\      "use": "official",
        \\      "family": "Doe",
        \\      "given": ["John"]
        \\    }
        \\  ],
        \\  "gender": "male",
        \\  "birthDate": "1980-04-01"
        \\}
    ;

    var response_body = std.ArrayList(u8).init(allocator);
    defer response_body.deinit();

    const result = try client.fetch(.{
        .method = .POST,
        .location = .{ .url = "http://localhost:8080/fhir/Patient" },
        .extra_headers = &[_]http.Header{
            .{ .name = "Content-Type", .value = "application/json" },
        },
        .payload = payload,
        .response_storage = .{ .dynamic = &response_body },
    });

    std.debug.print("Status: {d}\n", .{result.status});
    std.debug.print("Response Body:\n{s}\n", .{response_body.items});
}

pub fn main() !void {
    try createPatient();
    try getPatient();
}
