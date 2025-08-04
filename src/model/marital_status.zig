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
