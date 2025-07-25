const std = @import("std");
const Patient = @import("patient.zig").Patient;
const expect = std.testing.expect;

test "empty patient test" {
    const json_text =
        \\{}
    ;

    const test_allocator = std.testing.allocator;
    const parsed = try std.json.parseFromSlice(Patient, test_allocator, json_text, .{});
    defer parsed.deinit();

    const patient: Patient = parsed.value;
    try expect(std.mem.eql(u8, patient.resourceType, "Patient"));
}

test "basic patient test" {
    const json_text =
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

    const test_allocator = std.testing.allocator;
    const parsed = try std.json.parseFromSlice(Patient, test_allocator, json_text, .{});
    defer parsed.deinit();

    const patient: Patient = parsed.value;
    try expect(std.mem.eql(u8, patient.resourceType, "Patient"));
}
