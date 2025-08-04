const IdentifierType = @import("identifier_type.zig").IdentifierType;
const Period = @import("period.zig");
const Reference = @import("reference.zig");

// Identifier: https://hl7.org/fhir/datatypes.html#Identifier
use: ?[]const u8 = null, // e.g., "official", "nickname"
type: ?IdentifierType = null, // The type of identifier
system: ?[]const u8 = null, // e.g., "http://example.com/fhir/identifier-system"
value: ?[]const u8 = null, // The actual identifier details (e.g., 18675309, stacymom@yahoo.com)
period: ?Period = null, // Time period when the identifier was/is in use
assigner: ?Reference = null, // Organization that issued identifier
