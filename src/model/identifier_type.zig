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
