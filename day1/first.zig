const std = @import("std");
const print = std.debug.print;
const fs = std.fs;
const reverse = std.mem.reverse;

const sNumbers = [][]u8{
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

pub fn a(sub_seq: []u8) u8 {
    // for (0..sub_seq.len) |a|
    // if seq.len - i < 3
    // for (1..sNumbers) |i|
    // if std.mem.eql(u8, sub_seq[a..sNumbers[i].len], sNumbers[i]) return i
    return sub_seq[sub_seq.len];
}

pub fn getFirstDigit(seq: []u8) u8 {
    var i: u16 = 0;
    while (i < seq.len) : (i += 1) {
        if ((48 < seq[i]) and (seq[i] < 58)) return seq[i];
        // if seq.len - i < 3 : continue
        // if (getStringNumber(seq[i..])) |a| return a;
    }

    return 0;
}

pub fn getLastDigit(seq: []u8) u8 {
    const reversed = seq[0..seq.len];
    reverse(u8, reversed);
    return getFirstDigit(reversed);
}

pub fn main() !void {
    const fileName = "calibration_document.txt";

    var file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var result: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const firstDigit: u8 = getFirstDigit(line) - 48;
        const lastDigit: u8 = getLastDigit(line) - 48;
        result += firstDigit * 10 + lastDigit;
    }

    print("{}\n", .{result});
}
