module tokenizer;

import std.range;
import util;
import handler;

import std.stdio;

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
	string contents;
	int row;
	int column;
}

class Tokenizer {

	private int currentLine; // The current line being tokenized
	private int currentPosition; // The current position on the line, used for debugging purposes only
	private string[] source; // List of lines, stored as a slice

	this() {
		// Constructor code
	}

	public void addSourceLine(string line) {
		source ~= line; // Append this line to the source array
	}

	private bool isIdentifierCharacter(char c) {
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
		} while (source[currentLine].length > stringLength && source[currentLine][stringLength] != '"');

		if (quoteCount != 2) {
			handler.reportError(BuildError(1, currentPosition, currentLine));
			handler.abortIfErrors();
		}

		Token token = Token(TokenType.STRING_LITERAL, source[currentLine][0 .. stringLength], currentLine, currentPosition);
		consume(stringLength);
		return token;
	}

	// Tokenizes a numerical literal (integer or floating point), e.g. 3, 3.141, etc
	private Token tokenizeNumericalLiteral() {
		int numberLength = 0;
		int pointCount = 0;
		do {
			numberLength ++;
			if (source[currentLine][numberLength] == '.') {
				pointCount ++;
			}
		} while (source[currentLine].length > numberLength && (isDigit(source[currentLine][numberLength]) || source[currentLine][numberLength] == '.'));

		if (pointCount > 1) {
			handler.reportError(BuildError(2, currentPosition, currentLine));
			handler.abortIfErrors();
		}

		Token token = Token((pointCount == 1) ? TokenType.FLOAT_LITERAL : TokenType.INTEGER_LITERAL, source[currentLine][0 .. numberLength], currentLine, currentPosition);
		consume(numberLength);
		return token;
	}

	private void tokenizeOperator() {
//		OP_ADD, // +
//		OP_SUB, // -
//		OP_MUL, // *
//		OP_DIV, // /
//		OP_MOD, // %
//		OP_POW, // ^
//		OP_ASSIGNMENT, // =
//		OP_GREATER_THAN, // >
//		OP_LESS_THAN, // <
//		OP_GREATER_EQ_TO, // >=
//		OP_LESS_EQ_TO, // <=
//		OP_DOUBLE_EQUALS, // ==
//		OP_LOGICAL_AND, // &
//		OP_LOGICAL_OR, // |
		auto result = isOperator(source[currentLine][0]);
		consume();

		// Identify initial type
		TokenType type;
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

		}

		if (source[currentLine][0] == '=') {
			// Operator is followed by '='
//			switch (result[1]) {
//				case '=':
//			}
		}
	}
	
////	private Token[] tokenizeLine() {
////
////	}
}

unittest {
	Tokenizer tokenizer = new Tokenizer();
	string identifierLine = "function";
	string integerLine = "1024";
	string floatLine = "3.14159265";
	string stringLine = """Hello, World!""";

	Token result;

	tokenizer.addSourceLine(identifierLine);
	result = tokenizer.tokenizeIdentifier();
	assert(result.type == TokenType.IDENTIFIER);
	tokenizer.currentLine ++;
	writeln(result.contents);

	tokenizer.addSourceLine(integerLine);
	assert(tokenizer.tokenizeNumericalLiteral().type == TokenType.INTEGER_LITERAL);
	tokenizer.currentLine ++;

	tokenizer.addSourceLine(floatLine);
	assert(tokenizer.tokenizeNumericalLiteral().type == TokenType.FLOAT_LITERAL);
	tokenizer.currentLine ++;

	tokenizer.addSourceLine(stringLine);
	assert (tokenizer.tokenizeStringLiteral().type == TokenType.STRING_LITERAL);
	tokenizer.currentLine ++;

	handler.reportWarning("Unit testing completed", 0, 0);
}
