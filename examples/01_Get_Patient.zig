const std = @import("std");
const fhirz = @import("fhirz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var patient_client = fhirz.Client(fhirz.Patient).init(allocator, "http://localhost:8080/fhir");
    defer patient_client.deinit();

    var result = patient_client.get("1") catch |err| {
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
