module tokenizer;

import std.range;
import std.stdio;
import std.string;
import std.uni;
import std.conv;

import util;
import handler;

public enum TokenType {
	WHITESPACE, // spaces, tabs, etc
	OP_ADD, // +
	OP_SUB, // -
	OP_MUL, // *
	OP_DIV, // /
	OP_MOD, // %
	OP_POW, // ^
	OP_ASSIGNMENT, // =
	OP_GREATER_THAN, // >
	OP_LESS_THAN, // <
	OP_GREATER_EQ_TO, // >=
	OP_LESS_EQ_TO, // <=
	OP_DOUBLE_EQUALS, // ==
	OP_LOGICAL_AND, // &
	OP_LOGICAL_OR, // |
	IDENTIFIER, // if, func, myVar, etc
	STRING_LITERAL, // "hello, world!"
	INTEGER_LITERAL,
	FLOAT_LITERAL,
	SEPARATOR, // ,
	OPEN_BRACKET, // (
	CLOSE_BRACKET, // )
	OPEN_SQUARE_BRACKET, // [
	CLOSE_SQUARE_BRACKET, // ]
	OPEN_CURVY_BRACE, // {
	CLOSED_CURVY_BRACE, // }
	END_STATEMENT // ;
}

public struct Token {
	TokenType type;
	dstring contents;
	int line;
	int position;
}

class Tokenizer {

	private int currentLine; // The current line being tokenized
	private int currentPosition; // The current position on the line, used for debugging purposes only
	private dstring[] source; // List of lines, stored as a slice

	this() {
		// Constructor code
	}

	public void addSourceLine(dstring line) {
		source ~= line; // Append this line to the source array
	}

	private bool isIdentifierCharacter(dchar c) {
		return isAlphaNumeric(c) | (c == '_');
	}

	// Consumes a number of characters from the current line
	private void consume(int size = 1) {
		source[currentLine] = source[currentLine][size .. $];
		currentPosition += size;
	}

	// Tokenizes an identifier
	private Token tokenizeIdentifier() {
		// Assume validation has already been performed

		int identifierLength = 0; 
		do {
			identifierLength ++;
		} while (source[currentLine].length > identifierLength && isIdentifierCharacter(source[currentLine][identifierLength]));

		Token token = Token(TokenType.IDENTIFIER, source[currentLine][0 .. identifierLength], currentLine, currentPosition);
		consume(identifierLength); // Remove the identifier from the line
		return token;
	}

	// Tokenizes a string literal, e.g. "Hello, world"
	private Token tokenizeStringLiteral() {
		int stringLength = 0;
		int quoteCount = 0;
		do {
			if (source[currentLine][stringLength] == '"') {
				quoteCount ++;
			}
			stringLength ++;
		} while (source[currentLine].length > stringLength && quoteCount < 2);

		if (quoteCount != 2) {
			reportError(BuildError(1, currentLine, currentPosition));
			return Token();
		}

		Token token = Token(TokenType.STRING_LITERAL, source[currentLine][0 .. stringLength], currentLine, currentPosition);
		consume(stringLength);
		return token;
	}

	// Tokenizes a numerical literal (integer or floating point), e.g. 3, 3.141, etc
	private Token tokenizeNumericalLiteral() {
		int numberLength = 0;
		int pointCount = 0;
		bool hasFractionalPart = false;

		do {
			if (source[currentLine][numberLength] == '.') {
				pointCount ++;
			}

			if (pointCount > 0) {
				hasFractionalPart = true;
			}

			numberLength ++;
		} while (source[currentLine].length > numberLength && (isDigit(source[currentLine][numberLength]) || source[currentLine][numberLength] == '.'));

		if (pointCount > 1) {
			reportError(BuildError(2, currentLine, currentPosition));
			return Token();
		}

		if (!hasFractionalPart && pointCount > 0) {
			reportError(BuildError(4, currentLine, currentPosition));
			return Token();
		}

		Token token = Token((pointCount == 1) ? TokenType.FLOAT_LITERAL : TokenType.INTEGER_LITERAL, source[currentLine][0 .. numberLength], currentLine, currentPosition);
		consume(numberLength);
		return token;
	}

	private Token tokenizeOperator() {
		auto result = isOperator(source[currentLine][0]);

		if (!result[0]) {
			reportError(BuildError(3, currentLine, currentPosition, to!dstring(source[currentLine][0])));
			return Token();
		}

		consume();

		// Identify initial type
		TokenType type;
		dstring contents;
		switch (result[1]) {
			case '+':
				type = TokenType.OP_ADD;
				break;
			case '-':
				type = TokenType.OP_SUB;
				break;
			case '*':
				type = TokenType.OP_MUL;
				break;
			case '/':
				type = TokenType.OP_DIV;
				break;
			case '%':
				type = TokenType.OP_MOD;
				break;
			case '^':
				type = TokenType.OP_POW;
				break;
			case '=':
				type = TokenType.OP_ASSIGNMENT;
				break;
			case '>':
				type = TokenType.OP_GREATER_THAN;
				break;
			case '<':
				type = TokenType.OP_LESS_THAN;
				break;
			case '&':
				type = TokenType.OP_LOGICAL_AND;
				break;
			case '|':
				type = TokenType.OP_LOGICAL_OR;
				break;
			default:
				break;
		}

		contents = ""d ~ result[1];

		if (source[currentLine].length > 0 && source[currentLine][0] == '=') {
			// Operator is followed by '='
			switch (result[1]) {
				case '=':
					// Double equals
					type = TokenType.OP_DOUBLE_EQUALS;
					contents = "==";
					consume();
					break;
				case '>':
					// Greater or equal to
					type = TokenType.OP_GREATER_EQ_TO;
					contents = ">=";
					consume();
					break;
				case '<':
					// Less or equal to
					type = TokenType.OP_LESS_EQ_TO;
					contents = "<=";
					consume();
					break;
				default:
					reportError(BuildError(3, currentLine, currentPosition, "="));
					return Token();
			}
		}

		return Token(type, contents, currentLine, currentPosition);
	}

	private Token[] tokenizeCurrentLine() {
		Token[] line;
		bool finishedLine = false;

		writeln(source[currentLine]);

		while (!finishedLine) {
			Token token;

			if (source[currentLine].length == 0) {
				finishedLine = true;
				continue;
			}

//			WHITESPACE, // spaces, tabs, etc
//			OP_ADD, // +
//			OP_SUB, // -
//			OP_MUL, // *
//			OP_DIV, // /
//			OP_MOD, // %
//			OP_POW, // ^
//			OP_ASSIGNMENT, // =
//			OP_GREATER_THAN, // >
//			OP_LESS_THAN, // <
//			OP_GREATER_EQ_TO, // >=
//			OP_LESS_EQ_TO, // <=
//			OP_DOUBLE_EQUALS, // ==
//			OP_LOGICAL_AND, // &
//			OP_LOGICAL_OR, // |
//			IDENTIFIER, // if, func, myVar, etc
//			STRING_LITERAL, // "hello, world!"
//			INTEGER_LITERAL,
//			FLOAT_LITERAL,
//			SEPARATOR, // ,
//			OPEN_BRACKET, // (
//			CLOSE_BRACKET, // )
//			OPEN_SQUARE_BRACKET, // [
//			CLOSE_SQUARE_BRACKET, // ]
//			OPEN_CURVY_BRACE, // {
//			CLOSED_CURVY_BRACE, // }
//			END_STATEMENT // ;

			dchar c = source[currentLine][0];
			if (source[currentLine].length > 2 && (c == '/' && source[currentLine][1] == '/')) {
				finishedLine = true; // Skip line
				continue;
			} else if (isDigit(c)) {
				line ~= tokenizeNumericalLiteral();
			} else if (isLetter(c) || c == '_') {
				line ~= tokenizeIdentifier();
			} else if (c == '"') {
				line ~= tokenizeStringLiteral();
			} else if (isOperator(c)[0]) {
				line ~= tokenizeOperator();
			} else if (c == ',') {
				line ~= Token(TokenType.SEPARATOR, ",", currentLine, currentPosition);
				consume();
			} else if (c == '(') {
				line ~= Token(TokenType.OPEN_BRACKET, "(", currentLine, currentPosition);
				consume();
			} else if (c == ')') {
				line ~= Token(TokenType.CLOSE_BRACKET, ")", currentLine, currentPosition);
				consume();
			} else if (c == '[') {
				line ~= Token(TokenType.OPEN_SQUARE_BRACKET, "[", currentLine, currentPosition);
				consume();
			} else if (c == ']') {
				line ~= Token(TokenType.CLOSE_SQUARE_BRACKET, "]", currentLine, currentPosition);
				consume();
			} else if (c == '{') {
				line ~= Token(TokenType.OPEN_CURVY_BRACE, "{", currentLine, currentPosition);
				consume();
			} else if (c == '}') {
				line ~= Token(TokenType.CLOSED_CURVY_BRACE, "}", currentLine, currentPosition);
				consume();
			} else if (c == ';') {
				line ~= Token(TokenType.END_STATEMENT, ";", currentLine, currentPosition);
				consume();
			} else if (isWhite(c)) {
				line ~= Token(TokenType.WHITESPACE, " ", currentLine, currentPosition);
				consume();
			} else {
				reportError(BuildError(3, currentLine, currentPosition, to!dstring(source[currentLine][0])));
				consume();
			}
		}

		abortIfErrors();

		return line;
	}

}

unittest {

	Tokenizer tokenizer = new Tokenizer();
	dstring identifierLine = "function helloWorld";
	dstring integerLine = "1024";
	dstring floatLine = "3.14159265";
	dstring stringLine = "\"Hello, World!\"";

	void incrementTokenizer() {
		tokenizer.currentLine ++;
		tokenizer.currentPosition = 0;
	}

	Token result;

	tokenizer.addSourceLine(identifierLine);
	result = tokenizer.tokenizeIdentifier();
	assert(result.type == TokenType.IDENTIFIER);
	incrementTokenizer();
	writeln(result.contents);

	tokenizer.addSourceLine(integerLine);
	result = tokenizer.tokenizeNumericalLiteral();
	assert(result.type == TokenType.INTEGER_LITERAL);
	incrementTokenizer();
	writeln(result.contents);

	tokenizer.addSourceLine(floatLine);
	result = tokenizer.tokenizeNumericalLiteral();
	assert(result.type == TokenType.FLOAT_LITERAL);
	incrementTokenizer();
	writeln(result.contents);

	tokenizer.addSourceLine(stringLine);
	result = tokenizer.tokenizeStringLiteral();
	assert(result.type == TokenType.STRING_LITERAL);
	incrementTokenizer();
	writeln(result.contents);

	tokenizer.addSourceLine(">=");
	result = tokenizer.tokenizeOperator();
	assert(result.type == TokenType.OP_GREATER_EQ_TO);
	incrementTokenizer();
	writeln(result.contents);

	tokenizer.addSourceLine("function _ HelloWorld {+-/& = == > < >= <=");
	auto lineResult = tokenizer.tokenizeCurrentLine();
	foreach (t; lineResult) {
		writeln("Type = " ~ (to!dstring(t.type)) ~ ", Contents = " ~ t.contents);
	}

	writeln("Tokenizer: Unit testing completed.");
}
