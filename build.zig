const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const day = b.option(u32, "day", "Which AOC day to compile.") orelse 1;

    if (day == 0) @panic("there is no day 0???");
    if (day > 31) @panic("there are only 31 days in December silly!");

    var name_buffer: [5]u8 = undefined;
    const name = std.fmt.bufPrint(&name_buffer, "day{d}", .{day}) catch unreachable;

    var path_buffer: [name_buffer.len + 8]u8 = undefined;
    const path = std.fmt.bufPrint(&path_buffer, "src/{s}.zig", .{name}) catch unreachable;

    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = b.path(path),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    b.step("run", "Run the app").dependOn(&run.step);
}
