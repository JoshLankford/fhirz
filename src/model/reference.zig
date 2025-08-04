const ResourceType = @import("resource_type.zig").ResourceType;

// Reference: https://hl7.org/fhir/datatypes.html#Reference
reference: ?[]const u8 = null, // Literal reference, Relative, internal or absolute URL
display: ?[]const u8 = null, // Text alternative for the resource
type: ?[]ResourceType = null, // Type the reference refers to (e.g. "Patient")
// TODO: consider a pointer to the idenifier later to avoid circular dependency
// identifier: ?Identifier = null, // Logical reference, when literal reference is not known
