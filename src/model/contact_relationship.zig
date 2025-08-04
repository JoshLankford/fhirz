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
