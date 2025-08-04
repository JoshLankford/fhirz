const Period = @import("period.zig");

// Address: https://hl7.org/fhir/datatypes.html#Address
use: ?[]const u8 = null, // e.g., "home", "work", "temp", "old", "mobile"
type: ?[]const u8 = null, // The type of address (physical / postal)
text: ?[]const u8 = null, // Text representation of the address
line: []const []const u8 = &.{}, // Street name, number, direction, and/or P.O. box
city: ?[]const u8 = null, // Name of city, town, suburb, etc.
district: ?[]const u8 = null, // Sub-unit of country (abbreviations ok)
state: ?[]const u8 = null, // Sub-unit of country (abbreviations ok)
postalCode: ?[]const u8 = null, // Postal code for area
country: ?[]const u8 = null, // Country (e.g., "US")
period: ?Period = null, // Time period when the address was/is in use
