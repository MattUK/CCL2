module handler;

import core.runtime;
import std.stdio;
import std.string;

public struct BuildError {
	public int errorID;
	public int line, position;
	public string values;
}

public immutable string[] errorMessages =
	["%d errors were found during build, check output for details.",
	 "Unterminated string literal",
	 "Unexpected '.'",
	 "Unexpected character '%s',"];

private BuildError[] errors;

public void reportError(BuildError error) {
	errors ~= error;
}

public void reportWarning(string warning, int line, int position) {
	writeln(format("Warning: " ~ warning ~ " found at position %d, line %d.", position, line));
}

public void abortIfErrors() {
	if (errors.length > 0) {
		foreach(err; errors) {
			writeln(format("Error: " ~ errorMessages[err.errorID] ~ " found at position %d, line %d.", err.values, err.position, err.line));
		}

		writeln(format(errorMessages[0], errors.length));

		Runtime.terminate();
	}
}