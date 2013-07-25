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
 *		// In this case, no second index is defined: all values from index(1) to the end of the array are used.
 *		let s2: s[position toend];
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

	public void parse(TokenString tokenString) {

	}
}

public class VariableDeclaration : Statement {
	public bool hasType;
	public TypeReference type;

	public bool hasScope;
	public string scopeName;

	public bool hasArguments;
	public Expression[] arguments;

	public void parse(TokenString tokenString) {
		
	}
}

public class FunctionDeclaration : Statement {
	public TupleDeclaration returnType;
	public string functionName;
	public ParameterDeclaration parameters;

	public void parse(TokenString tokenString) {
		
	}
}

public class CallStatement : Statement {
	public string functionName;

	public Expression[] parameters;

	public void parse(TokenString tokenString) {
		
	}
}

public class ArrayAccessor : Statement {
	public Expression index1;

	public bool isRange;
	public bool toEnd;
	public Expression index2;

	public void parse(TokenString tokenString) {
		
	}
}

public class ParameterDeclaration : Statement {
	public struct Parameter {
		public TypeReference type;
		public string name;
	}
	
	public void parse(TokenString tokenString) {
		
	}
}

public class TupleDeclaration : Statement {
	public TypeReference[] types;
	
	public void parse(TokenString tokenString) {
		
	}
}

public class TypeReference : Statement {
	public string typeName;
	
	public bool isArray;
	public int dimensions;
	
	public static TypeReference parse(TokenString tokenString) {
		return null;
	}
}

public class Constant : Statement {
	public dstring typeName;
	public dstring value;

	public static Constant parse(TokenString tokenString) {
		Token t = tokenString.consume();
		Constant constant = new Constant();
		if (t.type == TokenType.STRING_LITERAL) {
			constant.typeName = "string";
			constant.value = t.contents;
		} else if (t.type == TokenType.INTEGER_LITERAL) {
			constant.typeName = "int";
			constant.value = t.contents;
		} else if (t.type == TokenType.FLOAT_LITERAL) {
			constant.typeName = "float";
			constant.value = t.contents;
		} else if (t.type == TokenType.BOOL_LITERAL) {
			constant.typeName = "bool";
			constant.value = t.contents;
		}

		return constant;
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