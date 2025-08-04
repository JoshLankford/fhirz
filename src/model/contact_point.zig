const Period = @import("period.zig");

// ContactPoint: https://hl7.org/fhir/datatypes.html#ContactPoint
system: ?[]const u8 = null, // e.g., "phone", "email"
value: ?[]const u8 = null, // The actual contact point details (e.g., 18675309, stacymom@yahoo.com)
use: ?[]const u8 = null, // e.g., "home", "work", "temp", "old", "mobile"
rank: ?u32 = null, // Specify preferred order of use (1 = highest)
period: ?Period = null, // Time period when the contact point was/is in use
