const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

// const Color = struct {
// name: []const u8,
// found: u8,
// type: MaxValues,
//
// pub fn isPossible(self: *Color) bool {
// switch (self.type) {
// MaxValues.blue => {
// return (self.found <= MaxValues.blue);
// },
// MaxValues.green => {
// return (self.found <= MaxValues.green);
// },
// MaxValues.red => {
// return (self.found <= MaxValues.red);
// },
// }
// }
// };
//
// const Game = struct {
// game_id: u8,
// blue: *Color,
// green: *Color,
// red: *Color,
//
// pub fn isPossible(self: *Game) bool {
// return (self.blue.isPossible() and
// self.green.isPossible() and
// self.red.isPossible());
// }
// };

// const MaxValues = enum(u8) {
// blue = 14,
// green = 13,
// red = 15,
// };
const colors = [_][]const u8{
    "blue",
    "green",
    "red",
};

const maxes = [_][]const u8{
    "14",
    "13",
    "12",
};

fn int(str: anytype) !u8 {
    return try std.fmt.parseInt(u8, str, 10);
}

pub fn isPossibleGame(line: []u8) u8 {
    // var blue = Color { .name="blue", .found=0, .type=MaxValues.blue};
    // var green = Color { .name="green", .found=0, .type=MaxValues.green};
    // var red = Color { .name="red", .found=0, .type=MaxValues.red};

    var it = std.mem.tokenizeAny(u8, line, ":");
    var game_id_str: []const u8 = undefined;
    var games_str: []const u8 = undefined;
    var isTitleToken: bool = true;
    var isValid: bool = true;

    while (it.next()) |token| {
        if (isTitleToken) {
            game_id_str = token[5..];
            isTitleToken = false;
        } else games_str = token;
    }
    const game_id = std.fmt.parseInt(u8, game_id_str, 10) catch 0;
    // const game = Game { .game_id=game_id, .blue=*blue, .green=*green, .red=*red };

    it = std.mem.tokenizeAny(u8, games_str, ";");

    while (it.next()) |token| {
        var jt = std.mem.tokenizeAny(u8, token, " ,");
        // std.debug.print("\t-|{s}\n", .{token});
        while (jt.next()) |v| {
            if (jt.next()) |k| {
                // std.debug.print("-|{s}:{d}\n", .{ k, int(v) catch 99 });
                for (colors, maxes) |color, max| {
                    if (std.mem.eql(u8, k, color)) {
                        isValid = isValid and ((int(v) catch 0) <= (int(max) catch 99));
                    }
                }
                // std.debug.print("-|{}|\n", .{isValid});
            }
        }
    }

    // std.debug.print("[{d}]\n", .{game_id});
    if (isValid) return game_id else return 0;
}

pub fn main() !void {
    const fileName = "game.txt";

    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var result1: u64 = 0;
    var result2: u64 = 0;

    result1 = 0;
    result2 = 1;

    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const allocator = arena.allocator();
    // var game_id = 1;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        result1 += isPossibleGame(line);

        //if game is possible;
        // result1 += game_id;
        // game_id += 1;
    }

    print("-- Day 2: Cube Conundrum?! --\n\n", .{});
    print("Part1: {}\n", .{result1});
    print("Part2: {}\n", .{result2});
}
