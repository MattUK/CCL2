module basic_parser;

import tokenizer;
import handler;

import std.conv;

/*
 * // This function returns multiple values in the form of a tuple (object array).
 * func (string, string) splitString(string s, int position)
 * {
 * 		// The 'to' keyword means from index(1) to index(2) of the array (a.k.a. splicing).
 *		let s1: s[0 to position];
 *
 *		// In this case, no second index is defined: all values from index(1) to the end of the array are specified.
 *		let s2: s[position - 1 to];
 *
 *		// Return acts as a function with the parameters being the return types.
 *		return (s1, s2);
 * }
 *  ^^^^ Get this parsing!
*/

public class Statement {
}

public class Expression : Statement {
	public bool negative;
	public Statement value;
	public Token operator;

	public Expression followingExpression;
}

public class VariableDeclaration : Statement {
	public bool hasType;
	public TypeReference type;

	public bool hasScope;
	public string scopeName;

	public bool hasArguments;
	public Expression[] arguments;
}

public class TypeReference : Statement {
	public string typeName;

	public bool isArray;
	public int dimensions;
}

public class FunctionDeclaration : Statement {
	public TupleDeclaration returnType;
	public string functionName;
	public ParameterDeclaration parameters;
}

public class ParameterDeclaration : Statement {
	public struct Parameter {
		public TypeReference type;
		public string name;
	}
}

public class TupleDeclaration : Statement {
	public TypeReference[] types;
}

public class CallStatement : Statement {
	public string functionName;

	public Expression[] parameters;
}

public class Constant : Statement {
	public TypeReference type;
	public string value;
}

public void consume(ref Token[] tokens, int size = 1) {
	tokens = tokens[size .. $];
}

public void removeWhitespace(ref Token[] tokens) {
	bool finished = false;
	int counter;

	while (!finished) {
		if (tokens[counter].type == TokenType.WHITESPACE) {
			// Split the line into two, excluding the whitespace token.
			Token[] a1 = tokens[0 .. counter];
			Token[] a2 = tokens[counter + 1 .. $];
			// Merge the two remainders.
			tokens = a1 ~ a2;
		}

		counter ++;

		if (counter == tokens.length) {
			finished = true;
		}
	}
}

public class Parser {

	this() {
		// Constructor
	}

//	public Expression parseExpression() {
//
//	}

}

unittest {
	Tokenizer t = new Tokenizer();

	t.addSourceLine("func test()");
	auto tokens = t.start();

	reportStatus(to!dstring(tokens[0].length));

	removeWhitespace(tokens[0]);

	reportStatus(to!dstring(tokens[0].length));
}