const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const day = b.option(u5, "day", "Which AOC day to compile.") orelse 1;

    var buffer: [50]u8 = undefined;
    const exe = switch (day) {
        // Zig
        1...4 => blk: {
            const path = std.fmt.bufPrint(&buffer, "src/day{d}.zig", .{day}) catch unreachable;
            break :blk b.addExecutable(.{
                .name = path[4..7],
                .root_source_file = b.path(path),
                .target = target,
                .optimize = optimize,
            });
        },
        // C
        5 => blk: {
            const path = std.fmt.bufPrint(&buffer, "src/day{d}.c", .{day}) catch unreachable;
            const exe = b.addExecutable(.{
                .name = path[4..7],
                .target = target,
                .optimize = optimize,
                .link_libc = true,
            });

            exe.addCSourceFile(.{ .file = b.path(path) });
            break :blk exe;
        },
        else => @panic("invalid day"),
    };

    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    b.step("run", "Run the app").dependOn(&run.step);
}
