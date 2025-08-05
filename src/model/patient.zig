const Meta = @import("meta.zig");
const Extension = @import("extension.zig");
const Identifier = @import("identifier.zig");
const HumanName = @import("human_name.zig");
const ContactPoint = @import("contact_point.zig");
const AdministrativeGender = @import("administrative_gender.zig").AdministrativeGender;
const Address = @import("address.zig");
const MaritalStatus = @import("marital_status.zig").MaritalStatus;
const Contact = @import("contact.zig");
const Communication = @import("communication.zig");
const Reference = @import("reference.zig");
const Link = @import("link.zig");
const CodeableConcept = @import("codeable_concept.zig");

// Main Resource: https://hl7.org/fhir/patient.html

resourceType: []const u8 = "Patient", // always "Patient"
id: ?[]const u8 = null, // The logical ID of the resource
meta: ?Meta = null, // Metadata about the resource
extension: ?[]Extension = &.{},
identifier: []Identifier = &.{}, // An identifier for this patient
active: ?bool = null, // Whether this patient's record is in active use
name: []HumanName = &.{}, // A name associated with the patient
telecom: []ContactPoint = &.{}, // A contact point for the patient
gender: ?AdministrativeGender = null, // The gender of the patient
birthDate: ?[]const u8 = null, // ISO 8601 date: "YYYY-MM-DD"
deceasedBoolean: ?bool = null, // Whether the patient is deceased or not
deceasedDateTime: ?[]const u8 = null, // ISO 8601 date: "YYYY-MM-DD"
address: []Address = &.{}, // Addresses for the patient
maritalStatus: ?CodeableConcept = null, // Marital status of a patient
multipleBirthBoolean: ?bool = null, // Whether the patient is a multiple birth or not
multipleBirthInteger: ?u32 = null, // Indicates the actual birth order
contact: []Contact = &.{}, // A contact associated with the patient
communication: []Communication = &.{}, // A communication associated with the patient
generalPractitioner: ?Reference = null, // The general practitioner for the patient
managingOrganization: ?Reference = null, // The organization that is the custodian of the patient record
link: []Link = &.{}, // Link to another patient resource that the current patient is part of
