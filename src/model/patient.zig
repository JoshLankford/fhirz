// Main Resource: https://hl7.org/fhir/patient.html
pub const Patient = struct {
    resourceType: []const u8 = "Patient", // always "Patient"
    id: ?[]const u8 = null, // The logical ID of the resource
    meta: ?Meta = null, // Metadata about the resource
    identifier: []Identifier = &.{}, // An identifier for this patient
    active: ?bool = null, // Whether this patient's record is in active use
    name: []HumanName = &.{}, // A name associated with the patient
    telecom: []ContactPoint = &.{}, // A contact point for the patient
    gender: ?AdministrativeGender = null, // The gender of the patient
    birthDate: ?[]const u8 = null, // ISO 8601 date: "YYYY-MM-DD"
    deceasedBoolean: ?bool = null, // Whether the patient is deceased or not
    deceasedDateTime: ?[]const u8 = null, // ISO 8601 date: "YYYY-MM-DD"
    address: []Address = &.{}, // Addresses for the patient
    maritalStatus: ?MaritalStatus = null, // Marital status of a patient
    multipleBirthBoolean: ?bool = null, // Whether the patient is a multiple birth or not
    multipleBirthInteger: ?u32 = null, // Indicates the actual birth order
    contact: []Contact = &.{}, // A contact associated with the patient
};

// Meta information about a resource
pub const Meta = struct {
    versionId: ?[]const u8 = null,
    lastUpdated: ?[]const u8 = null,
};

// Identifier: https://hl7.org/fhir/datatypes.html#Identifier
pub const Identifier = struct {
    use: ?[]const u8 = null, // e.g., "official", "nickname"
    type: ?IdentifierType = null, // The type of identifier
    system: ?[]const u8 = null, // e.g., "http://example.com/fhir/identifier-system"
    value: ?[]const u8 = null, // The actual identifier details (e.g., 18675309, stacymom@yahoo.com)
    period: ?Period = null, // Time period when the identifier was/is in use
    // TODO: research this later, assigner is a Reference type that contains an Identifier so it's a circular dependency
    assigner: ?[]const u8 = null, // Organization that issued identifier
};

// IdentifierType: https://hl7.org/fhir/valueset-identifier-type.html
pub const IdentifierType = enum {
    drivers_license_number, // DL - Driver's license number
    passport_number, // PPN - Passport number
    breed_registry_number, // BRN - Breed Registry Number
    medical_record_number, // MR - Medical record number
    microchip_number, // MCN - Microchip Number
    employer_number, // EN - Employer number
    tax_id_number, // TAX - Tax ID number
    national_insurance_payor_identifier, // NIIP - National Insurance Payor Identifier (Payor)
    provider_number, // PRN - Provider number
    medical_license_number, // MD - Medical License number
    donor_registration_number, // DR - Donor Registration Number
    accession_id, // ACSN - Accession ID
    universal_device_identifier, // UDI - Universal Device Identifier
    serial_number, // SNO - Serial Number
    social_beneficiary_identifier, // SB - Social Beneficiary Identifier
    placer_identifier, // PLAC - Placer Identifier
    filler_identifier, // FILL - Filler Identifier
    jurisdictional_health_number, // JHN - Jurisdictional health number
};

// HumanName: https://hl7.org/fhir/datatypes.html#HumanName
pub const HumanName = struct {
    use: ?[]const u8 = null, // e.g., "official", "nickname"
    family: ?[]const u8 = null,
    given: []const []const u8 = &.{}, // list of given names
};

// ContactPoint: https://hl7.org/fhir/datatypes.html#ContactPoint
pub const ContactPoint = struct {
    system: ?[]const u8 = null, // e.g., "phone", "email"
    value: ?[]const u8 = null, // The actual contact point details (e.g., 18675309, stacymom@yahoo.com)
    use: ?[]const u8 = null, // e.g., "home", "work", "temp", "old", "mobile"
    rank: ?u32 = null, // Specify preferred order of use (1 = highest)
    period: ?Period = null, // Time period when the contact point was/is in use
};

// AdministrativeGender: https://hl7.org/fhir/valueset-administrative-gender.html
pub const AdministrativeGender = enum {
    male,
    female,
    other,
    unknown,
};

// Address: https://hl7.org/fhir/datatypes.html#Address
pub const Address = struct {
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
};

// Period: https://hl7.org/fhir/datatypes.html#Period
pub const Period = struct {
    start: ?[]const u8 = null, // Start time with inclusive boundary (e.g., "2013-01-01")
    end: ?[]const u8 = null, // End time with inclusive boundary (e.g., "2014-01-01")
};

// MaritalStatus: https://hl7.org/fhir/valueset-marital-status.html
pub const MaritalStatus = enum {
    annulled, // A - Marriage contract has been declared null and to not have existed
    divorced, // D - Marriage contract has been declared dissolved and inactive
    interlocutory, // I - Subject to an Interlocutory Decree
    legally_separated, // L - Legally Separated
    married, // M - A current marriage contract is active
    common_law, // C - Common law marriage
    polygamous, // P - More than 1 current spouse
    domestic_partner, // T - Person declares that a domestic partner relationship exists
    unmarried, // U - Currently not in a marriage contract
    never_married, // S - No marriage contract has ever been entered
    widowed, // W - The spouse has died
    unknown, // UNK - A proper value is applicable, but not known
};

// Reference: https://hl7.org/fhir/datatypes.html#Reference
pub const Reference = struct {
    reference: ?[]const u8 = null, // Literal reference, Relative, internal or absolute URL
    type: ?[]const u8 = null, // Type the reference refers to (e.g. "Patient")
    identifier: ?Identifier = null, // Logical reference, when literal reference is not known
    display: ?[]const u8 = null, // Text alternative for the resource
};

// Contact: https://hl7.org/fhir/datatypes.html#Contact
pub const Contact = struct {
    relationship: ?ContactRelationship = null, // The nature of the relationship
    name: ?HumanName = null, // A name associated with the contact
    telecom: []ContactPoint = &.{}, // A contact point for the contact
    address: ?Address = null, // Address for the contact
    gender: ?AdministrativeGender = null, // The gender of the contact
    organization: ?Reference = null, // The organization associated with the contact
};
// ContactRelationship: https://hl7.org/fhir/valueset-patient-contactrelationship.html
pub const ContactRelationship = enum {
    billing_contact_person, // BP - Billing contact person
    contact_person, // CP - Contact person
    emergency_contact_person, // EP - Emergency contact person
    person_preparing_referral, // PR - Person preparing referral
    employer, // E - Employer
    emergency_contact, // C - Emergency Contact
    federal_agency, // F - Federal Agency
    insurance_company, // I - Insurance Company
    next_of_kin, // N - Next-of-Kin
    state_agency, // S - State Agency
    unknown, // U - Unknown
};
