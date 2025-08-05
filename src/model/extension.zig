const Coding = @import("coding.zig");

url: ?[]const u8,
valueCoding: ?Coding = null,
valueString: ?[]const u8 = null,
extension: ?[]@This() = &.{},
