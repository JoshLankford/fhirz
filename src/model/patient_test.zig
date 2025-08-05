const std = @import("std");
const Patient = @import("patient.zig");
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

test "us core patient profile test" {
    const json_text =
        \\{
        \\  "resourceType": "Patient",
        \\  "meta": {
        \\    "versionId": "1",
        \\    "lastUpdated": "2024-01-01T00:00:00Z",
        \\    "profile": ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"]
        \\  },
        \\  "identifier": [
        \\    {
        \\      "use": "usual",
        \\      "system": "http://hospital.example.org",
        \\      "value": "1032702"
        \\    }
        \\  ],
        \\  "name": [
        \\    {
        \\      "use": "official",
        \\      "family": "Shaw",
        \\      "given": ["Amy", "V."]
        \\    }
        \\  ],
        \\  "gender": "female",
        \\  "birthDate": "1987-02-20"
        \\}
    ;

    const test_allocator = std.testing.allocator;
    const parsed = try std.json.parseFromSlice(Patient, test_allocator, json_text, .{});
    defer parsed.deinit();

    const patient: Patient = parsed.value;
    try expect(std.mem.eql(u8, patient.resourceType, "Patient"));
    
    // Verify US Core profile is declared in meta
    if (patient.meta) |meta| {
        try expect(meta.profile.len == 1);
        try expect(std.mem.eql(u8, meta.profile[0], "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"));
        try expect(std.mem.eql(u8, meta.versionId.?, "1"));
        try expect(std.mem.eql(u8, meta.lastUpdated.?, "2024-01-01T00:00:00Z"));
    } else {
        try expect(false); // Meta should be present
    }
    
    // Verify required US Core Patient elements
    try expect(patient.identifier.len > 0);
    try expect(patient.name.len > 0);
    try expect(patient.gender != null);
}
