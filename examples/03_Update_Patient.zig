const std = @import("std");
const fhirz = @import("fhirz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var patient_client = fhirz.Client(fhirz.Patient).init(allocator, "http://localhost:8080/fhir");
    defer patient_client.deinit();

    const patient_json = "{\"resourceType\": \"Patient\", \"id\": \"1\", \"identifier\": [{\"use\": \"official\", \"value\": \"18675309\"}], \"name\": [{\"use\": \"official\", \"family\": \"Doe\", \"given\": [\"John\"]}], \"gender\": \"male\", \"birthDate\": \"1980-04-02\"}";

    var parsed_patient = try std.json.parseFromSlice(fhirz.Patient, allocator, patient_json, .{});
    defer parsed_patient.deinit();

    var result = patient_client.update("1", parsed_patient.value) catch |err| {
        std.debug.print("Failed to update patient: {}\n", .{err});
        return;
    };

    if (result.isSuccess()) {
        std.debug.print("Patient updated successfully. Status: {d}\n", .{result.status_code});
        if (result.resource) |patient| {
            std.debug.print("Patient: {any}\n", .{patient});
        }
    } else {
        std.debug.print("Failed to update patient. Status: {d}\n", .{result.status_code});
    }
}
