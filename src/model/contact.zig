const ContactRelationship = @import("contact_relationship.zig").ContactRelationship;
const HumanName = @import("human_name.zig");
const ContactPoint = @import("contact_point.zig");
const Address = @import("address.zig");
const AdministrativeGender = @import("administrative_gender.zig").AdministrativeGender;
const Reference = @import("reference.zig");
const CodeableConcept = @import("codeable_concept.zig");

// Contact: https://hl7.org/fhir/datatypes.html#Contact
relationship: ?[]CodeableConcept = null, // The nature of the relationship
name: ?HumanName = null, // A name associated with the contact
telecom: []ContactPoint = &.{}, // A contact point for the contact
address: ?Address = null, // Address for the contact
gender: ?AdministrativeGender = null, // The gender of the contact
organization: ?Reference = null, // The organization associated with the contact
