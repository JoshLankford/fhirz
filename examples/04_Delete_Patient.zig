const std = @import("std");
const fhirz = @import("fhirz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var patient_client = fhirz.Client(fhirz.Patient).init(allocator, "http://localhost:8080/fhir");
    defer patient_client.deinit();

    var result = patient_client.delete("1") catch |err| {
        std.debug.print("Failed to delete patient: {}\n", .{err});
        return;
    };

    if (result.isSuccess()) {
        std.debug.print("Patient deleted successfully. Status: {d}\n", .{result.status_code});
    } else {
        std.debug.print("Failed to delete patient. Status: {d}\n", .{result.status_code});
    }
}
