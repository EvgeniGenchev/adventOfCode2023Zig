const std = @import("std");
const print = std.debug.print;
const fs = std.fs;
const reverse = std.mem.reverse;
const isEqual = std.mem.eql;
const Array = std.ArrayList;

const digit_mapping = [_][]const u8{
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};

const digits = [_]u8{
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
};

pub fn mutateString(seq: []u8, allocator: std.mem.Allocator) ![]u8 {
    var new_seq = try allocator.alloc(u8, seq.len);
    var i: u64 = 0;
    var found: bool = false;

    while (i < seq.len) {
        for (digit_mapping, digits) |digit, num| {
            if (std.mem.startsWith(u8, seq[i..], digit)) {
                new_seq[i] = num;
                found = true;
                break;
            }
        }

        if (!found) new_seq[i] = seq[i];
        found = false;
        i += 1;
    }

    return new_seq;
}

pub fn getFirstDigit(seq: []u8) u8 {
    var i: u16 = 0;
    while (i < seq.len) : (i += 1) {
        if ((48 < seq[i]) and (seq[i] < 58)) return seq[i];
    }

    return 0;
}

pub fn getLastDigit(seq: []u8) u8 {
    const reversed = seq[0..seq.len];
    reverse(u8, reversed);
    return getFirstDigit(reversed);
}

pub fn getDigits(seq: []u8) u64 {
    const firstDigit: u8 = getFirstDigit(seq) - 48;
    const lastDigit: u8 = getLastDigit(seq) - 48;
    return firstDigit * 10 + lastDigit;
}

pub fn main() !void {
    const fileName = "calibration_document.txt";

    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var result1: u64 = 0;
    var result2: u64 = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const new_seq = try mutateString(line, allocator);
        result1 += getDigits(line);
        result2 += getDigits(new_seq);

        allocator.free(new_seq);
    }
    print("-- Day 1: Trebuchet?! --\n\n", .{});
    print("Part1: {}\n", .{result1});
    print("Part2: {}\n", .{result2});
}
