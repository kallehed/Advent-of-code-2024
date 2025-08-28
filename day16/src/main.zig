fn p(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt ++ "\n", args);
}

const Tile = enum { AIR, WALL };

// East is (r)ight
const Dir = enum { r, d, l, u };
const DIRS = 4;

fn dir2move(d: Dir) [2]i64 {
    return switch (d) {
        .r => [_]i64{ 0, 1 },
        .d => [_]i64{ 1, 0 },
        .l => [_]i64{ 0, -1 },
        .u => [_]i64{ -1, 0 },
    };
}
fn dir2left(d: Dir) Dir {
    return switch (d) {
        .r => .u,
        .d => .r,
        .l => .d,
        .u => .l,
    };
}
fn dir2right(d: Dir) Dir {
    return switch (d) {
        .r => .d,
        .d => .l,
        .l => .u,
        .u => .r,
    };
}
pub fn main() !void {
    p("All your {s} are belong to us.\n", .{"codebase"});

    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    var alloc = gpa.allocator();

    const stdin = std.io.getStdIn();
    var buffer: [50000]u8 = undefined;
    const len = try stdin.readAll(buffer[0..]);
    const gotin = buffer[0..len];
    // p("{s}", .{gotin});

    // find row length
    const row_len = for (0..len) |idx| {
        if (gotin[idx] == '\n') break idx;
    } else 0;

    const col_len = (len + 1) / (row_len + 1); // MATH
    p("dimensions: row_len: {any}, col_len: {any}", .{ row_len, col_len });
    var matrix = try alloc.alloc(Tile, row_len * col_len);

    var start_i: i64 = 0;
    var start_j: i64 = 0;
    var end_i: i64 = 0;
    var end_j: i64 = 0;

    for (0..col_len) |i| {
        for (0..row_len) |j| {
            matrix[i * row_len + j] = switch (gotin[i * (row_len + 1) + j]) {
                '#' => .WALL,
                '.' => .AIR,
                'S' => b: {
                    start_i = @intCast(i);
                    start_j = @intCast(j);
                    break :b .AIR;
                },
                'E' => b: {
                    end_i = @intCast(i);
                    end_j = @intCast(j);
                    break :b .AIR;
                },
                else => @panic("wrong with input!"),
            };
        }
    }
    p("start: ({any},{any})", .{ start_i, start_j });
    p("end: ({any},{any})", .{ end_i, end_j });

    // Everything starts at infinity basically (or null in our case), then we find out the minimum cost to reach each place
    const least_cost = try alloc.alloc([DIRS]?i64, row_len * col_len);
    @memset(least_cost, [DIRS]?i64{ null, null, null, null });

    const E = struct {
        i: i64,
        j: i64,
        cost: i64,
        dir: Dir,
    };

    // this is apparently the idiomatic way to have nested functions in zig...
    const cmpfunc = struct {
        fn f(_: void, a: E, b: E) std.math.Order {
            return if (a.cost < b.cost) std.math.Order.lt else std.math.Order.gt;
        }
    }.f;

    const queueT = std.PriorityQueue(E, void, cmpfunc);
    // interesting value for void...
    var queue = queueT.init(alloc, {});
    try queue.add(E{ .i = start_i, .j = start_j, .cost = 0, .dir = .r });

    while (queue.removeOrNull()) |e| {
        const i = e.i;
        const j = e.j;
        const cost = e.cost;
        const dir = e.dir;
        if (i < 0 or j < 0 or j >= row_len or i >= col_len) continue;
        const row_len2: i64 = @intCast(row_len);
        const me = j + i * row_len2;
        if (matrix[@intCast(me)] == .WALL) continue;
        const before_cost = least_cost[@intCast(me)][@intFromEnum(dir)];
        // if it's lower than us, give up basically, already been here, better before...
        if (before_cost) |before_cost2| if (before_cost2 <= cost) continue;
        // therefore, set our new cost as the superior one, that will never be superseded
        least_cost[@intCast(me)][@intFromEnum(dir)] = cost;

        // add new 'positions to queue'
        const change = dir2move(dir);
        try queue.add(E{ .i = i, .j = j, .cost = cost + 1000, .dir = dir2left(dir) });
        try queue.add(E{ .i = i, .j = j, .cost = cost + 1000, .dir = dir2right(dir) });
        try queue.add(E{ .i = i + change[0], .j = j + change[1], .cost = cost + 1, .dir = dir });
    }
    const row_len2: i64 = @intCast(row_len);
    var min: i64 = std.math.maxInt(i64);
    var best_dir: i64 = 0;
    for (least_cost[@intCast(end_i * row_len2 + end_j)][0..], 0..) |opt, idx| {
        if (opt) |v| {
            if (v < min) {
                min = v;
                best_dir = @intCast(idx);
            }
        }
    }
    p("end square for all dirs: {any}", .{least_cost[@intCast(end_i * row_len2 + end_j)]});
    const best_dir2: Dir = @enumFromInt(best_dir);
    p("\np1 RESULT: {any}, best_dir: {any}\n", .{ min, best_dir2 });

    // SO: at the end we have a certain cost at a certain dir that is minimal, and we assume that only one end dir is best, because it is so in my case.
    // and, we know that walking along one of the best paths, we will always end up with exactly the same cost.
    // that means, walking backwards from the end, when walking along a best path, the cost should decrease always in right proportion and be 0 at the start.

    // so walk backwards from end and mark spots we 'can' walk to

    try queue.add(E{ .i = end_i, .j = end_j, .cost = min, .dir = best_dir2 });

    const on_path = try alloc.alloc(bool, row_len * col_len);
    defer alloc.free(on_path);
    @memset(on_path, false);
    while (queue.removeOrNull()) |e| {
        const i = e.i;
        const j = e.j;
        //const cost = e.cost;
        const dir = e.dir;
        if (i < 0 or j < 0 or j >= row_len or i >= col_len) continue;
        const me = j + i * row_len2;
        if (matrix[@intCast(me)] == .WALL) continue;
        on_path[@intCast(me)] = true;

        const before_cost2 = least_cost[@intCast(me)][@intFromEnum(dir)];
        const before_cost = before_cost2 orelse @panic("something wrong?");

        const change = dir2move(dir);
        const options = [3]E{ E{ .i = i, .j = j, .cost = before_cost - 1000, .dir = dir2left(dir) }, E{ .i = i, .j = j, .cost = before_cost - 1000, .dir = dir2right(dir) }, E{ .i = i - change[0], .j = j - change[1], .cost = before_cost - 1, .dir = dir } };

        //check that it qualifies
        for (options) |op| if (op.cost == least_cost[@intCast(op.i * row_len2 + op.j)][@intFromEnum(op.dir)]) try queue.add(op);
    }
    var total: i64 = 0;
    for (on_path) |x| {
        if (x) total += 1;
    }

    p("p2 res: {any}", .{total});
}
const std = @import("std");
