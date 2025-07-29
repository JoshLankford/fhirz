const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const fhirz_mod = b.addModule("fhirz", .{
        .root_source_file = b.path("fhirz.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "fhirz",
        .root_module = fhirz_mod,
    });

    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_module = fhirz_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // Examples compilation
    const examples = [_]struct {
        file: []const u8,
        name: []const u8,
    }{
        .{ .file = "examples/01_Get_Patient.zig", .name = "example_get_patient" },
        .{ .file = "examples/02_Create_Patient.zig", .name = "example_create_patient" },
        .{ .file = "examples/03_Update_Patient.zig", .name = "example_update_patient" },
    };

    {
        for (examples) |ex| {
            const exe = b.addExecutable(.{
                .name = ex.name,
                .root_module = b.createModule(.{
                    .root_source_file = b.path(ex.file),
                    .target = target,
                    .optimize = optimize,
                }),
            });
            exe.root_module.addImport("fhirz", fhirz_mod);
            b.installArtifact(exe);

            const run_cmd = b.addRunArtifact(exe);
            run_cmd.step.dependOn(b.getInstallStep());
            if (b.args) |args| {
                run_cmd.addArgs(args);
            }

            const run_step = b.step(ex.name, ex.file);
            run_step.dependOn(&run_cmd.step);
        }
    }
}
