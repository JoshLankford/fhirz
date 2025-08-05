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

test "us core patient test" {
    const json_text =
        \\{
        \\  "resourceType": "Patient",
        \\  "meta": {
        \\    "versionId": "1",
        \\    "lastUpdated": "2024-01-01T00:00:00Z",
        \\    "profile": ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"]
        \\  },
        \\  "extension": [
        \\    {
        \\      "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex",
        \\      "valueCoding": {
        \\        "system": "http://snomed.info/sct",
        \\        "version": "http://snomed.info/sct/731000124108",
        \\        "code": "248153007",
        \\        "display": "Male (finding)"
        \\      }
        \\    }
        \\  ],
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
}

test "us core patient with extensions test" {
    const json_text =
        \\{
        \\  "resourceType": "Patient",
        \\  "meta": {
        \\    "versionId": "1",
        \\    "lastUpdated": "2024-01-01T00:00:00Z",
        \\    "profile": ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"]
        \\  },
        \\  "extension": [
        \\    {
        \\      "extension": [
        \\        {
        \\          "url": "ombCategory",
        \\          "valueCoding": {
        \\            "system": "urn:oid:2.16.840.1.113883.6.238",
        \\            "code": "2028-9",
        \\            "display": "Asian"
        \\          }
        \\        },
        \\        {
        \\          "url": "text",
        \\          "valueString": "Asian"
        \\        }
        \\    ],
        \\      "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"
        \\    },
        \\    {
        \\      "extension": [
        \\        {
        \\          "url": "ombCategory",
        \\          "valueCoding": {
        \\            "system": "urn:oid:2.16.840.1.113883.6.238",
        \\            "code": "2186-5",
        \\            "display": "Not Hispanic or Latino"
        \\          }
        \\        },
        \\        {
        \\          "url": "text",
        \\          "valueString": "Not Hispanic or Latino"
        \\        }
        \\    ],
        \\      "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity"
        \\    },
        \\    {
        \\      "url": "http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex",
        \\      "valueCoding": {
        \\        "system": "http://snomed.info/sct",
        \\        "version": "http://snomed.info/sct/731000124108",
        \\        "code": "248153007",
        \\        "display": "Male (finding)"
        \\      }
        \\    }
        \\  ],
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

    if (patient.extension) |ext| {
        try expect(ext.len == 3);
    } else {
        try expect(false);
    }
}
