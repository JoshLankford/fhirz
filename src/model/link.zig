const Reference = @import("reference.zig");
const LinkType = @import("link_type.zig").LinkType;

// Link: https://hl7.org/fhir/patient-definitions.html#Patient.link

other: ?Reference = null, // Reference to another patient resource that the current patient is part of
type: ?LinkType = null, // The type of link
