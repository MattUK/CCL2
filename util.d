module util;

import std.stdio;
import std.range;
import std.typecons;

public dchar[] charRange(dchar beginning, dchar end) {
	dchar[] result;
	foreach(c; iota(cast(int)beginning, cast(int)end + 1)) {
		result ~= cast(dchar)c;
	}
	return result;
}

public bool charInRange(dchar c, dchar rangeBeginning, dchar rangeEnd) {
	dchar[] range = charRange(rangeBeginning, rangeEnd);
	foreach (c1; range) {
		if (c == c1) {
			return true;
		}
	}
	return false;
}

public bool isLetter(dchar c) {
	if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
		return true;
	}
	return false;
}

public bool isDigit(dchar c) {
	return std.uni.isNumber(c);
//	if (c == '0' || charInRange(c, '1', '9')) {
//		return true;
//	}
//	return false;
}

public bool isAlphaNumeric(dchar c) {
	return isLetter(c) | isDigit(c);
}

public dchar[] operators = ['+', '-', '*', '/', '%', '^', ':', '=', '>', '<', '&', '|', '~', '.'];

// Returns true/false, along with the operator being checked
public auto isOperator(dchar c) {
	foreach (dchar o; operators) {
		if (c == o) {
			return tuple(true, o);
		}
	}
	return tuple(false, cast(dchar)' ');
}