const std = @import("std");
const print = std.debug.printl;
const fs = std.fs;
const FILE_NAME = "engine_schematic.txt";
const SIZE = 140;
const content = @embedFile(FILE_NAME);
const isDigit = std.ascii.isDigit;

fn is_symbol(char: u8) bool {
    const symbols = [_]u8{ '*', '+', '#', '$', '&', '-', '=', '@', '/', '%' };
    for (symbols) |symbol| if (symbol == char) return true;
    return false;
}

fn find_number_size(line: [SIZE]u8, c: u32) u8 {
    var size: u8 = 0;

    for (line[c..]) |char| {
        if (isDigit(char)) {
            size += 1;
            continue;
        }
        break;
    }
    return size;
}

fn has_adjecent_symbol(schematic: [SIZE][SIZE]u8, col: u32, row: usize, n: u8) bool {
    var prev_line: ?[SIZE]u8 = null;
    var next_line: ?[SIZE]u8 = null;

    const line = schematic[row];

    if (row != 0) {
        prev_line = schematic[row - 1];
    }

    if (row + 1 < SIZE) {
        next_line = schematic[row + 1];
    }

    if (col != 0) {
        if (is_symbol(line[col - 1])) return true;
        if (prev_line) |pline| {
            for (col - 1..col + n) |i| {
                if (is_symbol(pline[i])) return true;
            }
        }
        if (next_line) |nline| {
            for (col - 1..col + n) |i| {
                if (is_symbol(nline[i])) return true;
            }
        }
    }

    if (col + n < SIZE) {
        if (is_symbol(line[col + n])) return true;
        if (next_line) |nline| {
            for (col..col + n + 1) |i| {
                if (is_symbol(nline[i])) return true;
            }
        }
        if (prev_line) |pline| {
            for (col..col + n + 1) |i| {
                if (is_symbol(pline[i])) return true;
            }
        }
    }

    return false;
}

fn get_parts_sum(schematic: [SIZE][SIZE]u8) !u64 {
    var result: u64 = 0;

    for (schematic, 0..) |line, n| {
        var c: u32 = 0;
        while (c < SIZE) {
            const char = line[c];
            if (isDigit(char)) {
                const n_size = find_number_size(line, c);
                const number = try std.fmt.parseInt(u16, line[c .. c + n_size], 10);
                if (has_adjecent_symbol(schematic, c, n, n_size)) {
                    result += number;
                }
                c += n_size;
            } else {
                c += 1;
            }
        }
    }
    return result;
}

fn get_gears_sum(schematic: [SIZE][SIZE]u8) !u64 {
    var result: u64 = 0;

    for (schematic, 0..) |line, n| {
        var c: u32 = 0;
        while (c < SIZE) {
            const char = line[c];
            if (isDigit(char)) {
                const n_size = find_number_size(line, c);
                const number = try std.fmt.parseInt(u16, line[c .. c + n_size], 10);
                // check if it has adjecent star if so check if the star has adjecet number
                // then divide by two
                if (has_adjecent_symbol(schematic, c, n, n_size)) {
                    result += number;
                }
                c += n_size;
            } else {
                c += 1;
            }
        }
    }
    return result;
}

pub fn get_file_lines() *[SIZE][SIZE]u8 {
    var lines = std.mem.split(u8, content, "\n");

    var engine_schematic: [SIZE][SIZE]u8 = undefined;
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

pub fn main() !void {
    const lines = get_file_lines().*;
    // When i add this line it works when i remove it, it doesn't ?
    for (lines) |line| _ = line;

    const result1 = try get_parts_sum(lines);
    std.debug.print("{d}", .{result1});
}
