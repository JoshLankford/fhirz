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
    communication: []Communication = &.{}, // A communication associated with the patient
    generalPractitioner: ?Reference = null, // The general practitioner for the patient
    managingOrganization: ?Reference = null, // The organization that is the custodian of the patient record
    link: []Link = &.{}, // Link to another patient resource that the current patient is part of
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
    assigner: ?Reference = null, // Organization that issued identifier
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
    display: ?[]const u8 = null, // Text alternative for the resource
    type: ?[]ResourceType = null, // Type the reference refers to (e.g. "Patient")
    // TODO: consider a pointer to the idenifier later to avoid circular dependency
    // identifier: ?Identifier = null, // Logical reference, when literal reference is not known
};

// ResourceType: https://hl7.org/fhir/valueset-resource-types.html
pub const ResourceType = enum {
    account,
    activity_definition,
    actor_definition,
    administrable_product_definition,
    adverse_event,
    allergy_intolerance,
    appointment,
    appointment_response,
    artifact_assessment,
    audit_event,
    basic,
    binary,
    biologically_derived_product,
    biologically_derived_product_dispense,
    body_structure,
    bundle,
    capability_statement,
    care_plan,
    care_team,
    charge_item,
    charge_item_definition,
    citation,
    claim,
    claim_response,
    clinical_impression,
    clinical_use_definition,
    code_system,
    communication,
    communication_request,
    compartment_definition,
    composition,
    concept_map,
    condition,
    condition_definition,
    consent,
    contract,
    coverage,
    coverage_eligibility_request,
    coverage_eligibility_response,
    detected_issue,
    device,
    device_association,
    device_definition,
    device_dispense,
    device_metric,
    device_request,
    device_usage,
    diagnostic_report,
    document_reference,
    encounter,
    encounter_history,
    endpoint,
    enrollment_request,
    enrollment_response,
    episode_of_care,
    event_definition,
    evidence,
    evidence_report,
    evidence_variable,
    example_scenario,
    explanation_of_benefit,
    family_member_history,
    flag,
    formulary_item,
    genomic_study,
    goal,
    graph_definition,
    group,
    guidance_response,
    healthcare_service,
    imaging_selection,
    imaging_study,
    immunization,
    immunization_evaluation,
    immunization_recommendation,
    implementation_guide,
    ingredient,
    insurance_plan,
    inventory_item,
    inventory_report,
    invoice,
    library,
    linkage,
    list,
    location,
    manufactured_item_definition,
    measure,
    measure_report,
    medication,
    medication_administration,
    medication_dispense,
    medication_knowledge,
    medication_request,
    medication_statement,
    medicinal_product_definition,
    message_definition,
    message_header,
    molecular_sequence,
    naming_system,
    nutrition_intake,
    nutrition_order,
    nutrition_product,
    observation,
    observation_definition,
    operation_definition,
    operation_outcome,
    organization,
    organization_affiliation,
    packaged_product_definition,
    parameters,
    patient,
    payment_notice,
    payment_reconciliation,
    permission,
    person,
    plan_definition,
    practitioner,
    practitioner_role,
    procedure,
    provenance,
    questionnaire,
    questionnaire_response,
    regulated_authorization,
    related_person,
    request_orchestration,
    requirements,
    research_study,
    research_subject,
    risk_assessment,
    schedule,
    search_parameter,
    service_request,
    slot,
    specimen,
    specimen_definition,
    structure_definition,
    structure_map,
    subscription,
    subscription_status,
    subscription_topic,
    substance,
    substance_definition,
    substance_nucleic_acid,
    substance_polymer,
    substance_protein,
    substance_reference_information,
    substance_source_material,
    supply_delivery,
    supply_request,
    task,
    terminology_capabilities,
    test_plan,
    test_report,
    test_script,
    transport,
    value_set,
    verification_result,
    vision_prescription,
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

pub const Communication = struct {
    language: ?Language = null, // The language of the communication
    preferred: ?bool = null, // Whether the communication is preferred
};

// Language: https://hl7.org/fhir/valueset-languages.html
pub const Language = enum {
    ar, // Arabic
    bg, // Bulgarian
    bg_BG, // Bulgarian (Bulgaria)
    bn, // Bengali
    cs, // Czech
    cs_CZ, // Czech (Czechia)
    bs, // Bosnian
    bs_BA, // Bosnian (Bosnia and Herzegovina)
    da, // Danish
    da_DK, // Danish (Denmark)
    de, // German
    de_AT, // German (Austria)
    de_CH, // German (Switzerland)
    de_DE, // German (Germany)
    el, // Greek
    el_GR, // Greek (Greece)
    en, // English
    en_AU, // English (Australia)
    en_CA, // English (Canada)
    en_GB, // English (Great Britain)
    en_IN, // English (India)
    en_NZ, // English (New Zealand)
    en_SG, // English (Singapore)
    en_US, // English (United States)
    es, // Spanish
    es_AR, // Spanish (Argentina)
    es_ES, // Spanish (Spain)
    es_UY, // Spanish (Uruguay)
    et, // Estonian
    et_EE, // Estonian (Estonia)
    fi, // Finnish
    fr, // French
    fr_BE, // French (Belgium)
    fr_CH, // French (Switzerland)
    fr_FR, // French (France)
    fi_FI, // Finnish (Finland)
    fr_CA, // French (Canada)
    fy, // Frisian
    fy_NL, // Frisian (Netherlands)
    hi, // Hindi
    hr, // Croatian
    hr_HR, // Croatian (Croatia)
    is, // Icelandic
    is_IS, // Icelandic (Iceland)
    it, // Italian
    it_CH, // Italian (Switzerland)
    it_IT, // Italian (Italy)
    ja, // Japanese
    ko, // Korean
    lt, // Lithuanian
    lt_LT, // Lithuanian (Lithuania)
    lv, // Latvian
    lv_LV, // Latvian (Latvia)
    nl, // Dutch
    nl_BE, // Dutch (Belgium)
    nl_NL, // Dutch (Netherlands)
    no, // Norwegian
    no_NO, // Norwegian (Norway)
    pa, // Punjabi
    pl, // Polish
    pl_PL, // Polish (Poland)
    pt, // Portuguese
    pt_PT, // Portuguese (Portugal)
    pt_BR, // Portuguese (Brazil)
    ro, // Romanian
    ro_RO, // Romanian (Romania)
    ru, // Russian
    ru_RU, // Russian (Russia)
    sk, // Slovakian
    sk_SK, // Slovakian (Slovakia)
    sl, // Slovenian
    sl_SI, // Slovenian (Slovenia)
    sr, // Serbian
    sr_RS, // Serbian (Serbia)
    sv, // Swedish
    sv_SE, // Swedish (Sweden)
    te, // Telugu
    zh, // Chinese
    zh_CN, // Chinese (China)
    zh_HK, // Chinese (Hong Kong)
    zh_SG, // Chinese (Singapore)
    zh_TW, // Chinese (Taiwan)
};

// Link: https://hl7.org/fhir/patient-definitions.html#Patient.link
pub const Link = struct {
    other: ?Reference = null, // Reference to another patient resource that the current patient is part of
    type: ?LinkType = null, // The type of link
};

// LinkType: https://hl7.org/fhir/valueset-link-type.html
pub const LinkType = enum {
    replaced_by, // replaced-by
    replaces, // replaces
    refer, // refer
    seealso, // seealso
};
