const std = @import("std");
const Request = @import("request.zig").Request;
const Patient = @import("model/patient.zig").Patient;

fn getPatient() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var req = Request.init(allocator);
    defer req.deinit();

    const result = try req.get("http://localhost:8080/fhir/Patient/1");

    std.debug.print("Status: {d}\n", .{result.status});
    std.debug.print("Response Body:\n{s}\n", .{req.response_body.items});

    if (result.status == .ok) {
        const parsed = try std.json.parseFromSlice(Patient, allocator, req.response_body.items, .{});
        defer parsed.deinit();

        const patient: Patient = parsed.value;
        std.debug.print("Patient:\n{}\n", .{patient});
    } else {
        std.debug.print("Failed to retrieve patient. Status: {d}\n", .{result.status});
    }
}

fn createPatient(payload: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var req = Request.init(allocator);
    defer req.deinit();

    const result = try req.post("http://localhost:8080/fhir/Patient", payload);

    std.debug.print("Status: {d}\n", .{result.status});
    std.debug.print("Response Body:\n{s}\n", .{req.response_body.items});
}

pub fn main() !void {
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
    try createPatient(payload);
    try getPatient();
}
