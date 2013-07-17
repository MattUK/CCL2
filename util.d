module util;

import std.stdio;
import std.range;
import std.typecons;

public char[] charRange(char beginning, char end) {
	char[] result;
	foreach(c; iota(cast(int)beginning, cast(int)end + 1)) {
		result ~= cast(char)c;
	}
	return result;
}

public bool charInRange(char c, char rangeBeginning, char rangeEnd) {
	char[] range = charRange(rangeBeginning, rangeEnd);
	foreach (char c1; range) {
		if (c == c1) {
			return true;
		}
	}
	return false;
}

public bool isLetter(char c) {
	if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
		return true;
	}
	return false;
}

public bool isDigit(char c) {
	if (c == '0' || charInRange(c, '1', '9')) {
		return true;
	}
	return false;
}

public bool isAlphaNumeric(char c) {
	return isLetter(c) | isDigit(c);
}

public char[] operators = ['+', '-', '*', '/', '%', '^', '=', '>', '<', '&', '|'];

// Returns true/false, along with the operator being checked
public auto isOperator(char c) {
	foreach (o; operators) {
		if (c == o) {
			return tuple(true, o);
		}
	}
	return tuple(false, ' ');
}

public string tokenizeNumericalLiteral(string line) {
	int numberLength = 0;
	bool floatingPoint = false;
	do {
		numberLength ++;
		if (line[numberLength] == '.') {
			floatingPoint = true;
		}
		writeln(numberLength);
	} while (isDigit(line[numberLength]) || line[numberLength] == '.');

	string value = line[0 .. numberLength];
	line = line[numberLength .. $];
	return "Number = " ~ value ~ ", line = " ~ line;
}