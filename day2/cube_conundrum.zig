const std = @import("std");
const print = std.debug.print;
const fs = std.fs;

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

// very original name i know;
pub fn part2(line: []u8) u32 {
    var it = std.mem.tokenizeAny(u8, line, ":");
    var game_id_str: []const u8 = undefined;
    var games_str: []const u8 = undefined;
    var isTitleToken: bool = true;

    while (it.next()) |token| {
        if (isTitleToken) {
            game_id_str = token[5..];
            isTitleToken = false;
        } else games_str = token;
    }
    it = std.mem.tokenizeAny(u8, games_str, ";");
    const result: u128 = 0;
    _ = result;

    var max_red: u32 = 0;
    var max_green: u32 = 0;
    var max_blue: u32 = 0;

    while (it.next()) |token| {
        var jt = std.mem.tokenizeAny(u8, token, " ,");
        var temp: u8 = 1;
        // std.debug.print("\t-|{s}\n", .{token});
        while (jt.next()) |v| {
            if (jt.next()) |k| {
                if (std.mem.eql(u8, k, "blue")) {
                    temp = int(v) catch 99;
                    if (temp > max_blue) max_blue = temp;
                } else if (std.mem.eql(u8, k, "red")) {
                    temp = int(v) catch 99;
                    if (temp > max_red) max_red = temp;
                } else if (std.mem.eql(u8, k, "green")) {
                    temp = int(v) catch 99;
                    if (temp > max_green) max_green = temp;
                }
                // std.debug.print("\t-[b:{d},g:{d},r:{d},\n", .{ max_blue, max_green, max_red });
            }
        }
    }

    // std.debug.print("power {}\n", .{max_green * max_blue * max_red});
    return max_green * max_blue * max_red;
}

pub fn main() !void {
    const fileName = "game.txt";

    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var result1: u64 = 0;
    var result2: u32 = 0;

    result1 = 0;
    result2 = 0;

    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const allocator = arena.allocator();
    // var game_id = 1;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        result1 += isPossibleGame(line);
        result2 += part2(line);

        //if game is possible;
        // result1 += game_id;
        // game_id += 1;
    }

    print("-- Day 2: Cube Conundrum?! --\n\n", .{});
    print("Part1: {}\n", .{result1});
    print("Part2: {}\n", .{result2});
}
