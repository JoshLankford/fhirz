const Language = @import("language.zig").Language;
const CodeableConcept = @import("codeable_concept.zig");
const std = @import("std");

language: CodeableConcept = CodeableConcept{ .coding = null, .text = null }, // The language of the communication, required
preferred: ?bool = null, // Whether the communication is preferred
