const std = @import("std");
const print = std.debug.print;
const fs = std.fs;
const isDigit = std.ascii.isDigit;

const content = @embedFile(FILE_NAME);

// const FILE_NAME = "example.txt";
// const HSIZE = 6;
// const WSIZE = 48;
// const WINSIZE = 5;
// const GOTSIZE = 8;

const FILE_NAME = "game.txt";
const HSIZE = 220;
const WSIZE = 116;
const WINSIZE = 10;
const GOTSIZE = 26;

fn get_game_points(winning: [WINSIZE]u8, gotten: [GOTSIZE]u8) ?u32 {
    var result: ?u32 = null;
    for (gotten) |n| {
        for (winning) |w| {
            if (n == w) {
                if (result) |r| {
                    result = r * 2;
                } else result = 1;
            }
        }
    }
    return result;
}

fn get_cards_points(winning: [WINSIZE]u8, gotten: [GOTSIZE]u8) u32 {
    var result: u32 = 0;
    for (gotten) |n| {
        for (winning) |w| {
            if (n == w) {
                result = result + 1;
            }
        }
    }
    return result;
}

pub fn get_lines_sum(game: [HSIZE][WSIZE]u8) !u32 {
    var result: u32 = 0;
    const lines = game;

    for (lines) |line| {
        var it = std.mem.tokenizeAny(u8, &line, " ,|\n");

        var winning: [WINSIZE]u8 = undefined;
        var gotten: [GOTSIZE]u8 = undefined;

        for (0..2) |_| {
            if (it.next()) |t| {
                _ = t;
            }
        }
        for (0..WINSIZE) |i| {
            if (it.next()) |t| {
                winning[i] = try std.fmt.parseInt(u8, t, 10);
            }
        }
        for (0..GOTSIZE) |k| {
            if (it.next()) |t| {
                gotten[k] = try std.fmt.parseInt(u8, t, 10);
            }
        }

        if (get_game_points(winning, gotten)) |points| {
            result += points;
        }
    }
    return result;
}

pub fn get_file_lines() *[HSIZE][WSIZE]u8 {
    var lines = std.mem.split(u8, content, "\n");

    var engine_schematic: [HSIZE][WSIZE]u8 = undefined;
    var i: usize = 0;

    while (lines.next()) |line| {
        var j: usize = 0;
        for (line) |char| {
            engine_schematic[i][j] = char;
            j += 1;
        }
        i += 1;
    }

    return &engine_schematic;
}
// pub fn get_cards_sum(game: [HSIZE][WSIZE]u8) !u32 {
// var result: u32 = 0;
// var cardGames = std.AutoHashMap(usize, u32).init(std.heap.page_allocator);
// defer cardGames.deinit();
//
// const lines = game;
//
// for (lines, 0..) |line, n| {
// var it = std.mem.tokenizeAny(u8, &line, " ,|\n");
//
// var winning: [WINSIZE]u8 = undefined;
// var gotten: [GOTSIZE]u8 = undefined;
//
// for (0..2) |_| {
// if (it.next()) |t| {
// _ = t;
// }
// }
// for (0..WINSIZE) |i| {
// if (it.next()) |t| {
// winning[i] = try std.fmt.parseInt(u8, t, 10);
// }
// }
// for (0..GOTSIZE) |k| {
// if (it.next()) |t| {
// gotten[k] = try std.fmt.parseInt(u8, t, 10);
// }
// }
//
// const points = get_cards_points(winning, gotten);
// cardGames.put(n, points) catch unreachable;
// var j = n + 1;
// while (j < n + 1 + points) : (j += 1) {
// const currentCount = cardGames.get(j) orelse 0;
// cardGames.put(j, currentCount + points) catch unreachable;
// }
// }
//
// var it = cardGames.iterator();
// while (it.next()) |entry| {
// result += entry.value_ptr.*;
// }
// return result;
// }
pub fn get_cards_sum(game: [HSIZE][WSIZE]u8) !u32 {
    var result: u32 = 0;
    var cardQueue = std.ArrayList(usize).init(std.heap.page_allocator);
    defer cardQueue.deinit();

    // Enqueue initial card indices
    for (0..HSIZE) |i| {
        try cardQueue.append(i);
    }

    var currentIndex: usize = 0; // Index to track the current position in the queue

    while (currentIndex < cardQueue.items.len) {
        const n = cardQueue.items[currentIndex];
        currentIndex += 1; // Move to the next item in the queue

        var line = game[n];
        var it = std.mem.tokenizeAny(u8, &line, " ,|\n");

        var winning: [WINSIZE]u8 = undefined;
        var gotten: [GOTSIZE]u8 = undefined;

        for (0..2) |_| _ = it.next();

        for (0..WINSIZE) |i| {
            if (it.next()) |t| {
                winning[i] = try std.fmt.parseInt(u8, t, 10);
            }
        }
        for (0..GOTSIZE) |k| {
            if (it.next()) |t| {
                gotten[k] = try std.fmt.parseInt(u8, t, 10);
            }
        }

        const points = get_cards_points(winning, gotten);
        result += 1; // Count the current card

        // Enqueue additional cards won by this card
        for (0..points) |j| {
            const nextCardIndex = n + 1 + j;
            if (nextCardIndex < HSIZE) {
                try cardQueue.append(nextCardIndex);
            }
        }
    }

    return result;
}

pub fn main() !void {
    const lines = get_file_lines().*;
    for (lines) |line| _ = line;

    const result1 = try get_lines_sum(lines);
    // const result2 = try get_cards_sum(lines);
    const result2 = null;

    print("-- Day 3: Scratchcards --\n\n", .{});
    print("Part1: {}\n", .{result1});
    print("Part2: {}\n", .{result2});
}
