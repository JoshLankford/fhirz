const Coding = @import("coding.zig");

// Meta information about a resource
versionId: ?[]const u8 = null,
lastUpdated: ?[]const u8 = null,
source: ?[]const u8 = null,
profile: [][]const u8 = &.{},
security: []Coding = &.{},
tag: []Coding = &.{},
