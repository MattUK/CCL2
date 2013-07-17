module handler;

import core.runtime;
import std.stdio;
import std.string;

public struct BuildError {
	public int errorID;
	public int row, column;
}

public immutable string[] errorMessages =
	["%d errors were found during build, check output for details.",
	 "Unterminated string literal",
	 "Unexpected '.'"];

private BuildError[] errors;

public void reportError(BuildError error) {
	errors ~= error;
}

public void reportWarning(string warning, int row, int column) {
	writeln(format("Warning: " ~ warning ~ " found at row %d, line %d.", row, column));
}

public void abortIfErrors() {
	if (errors.length > 0) {
		foreach(err; errors) {
			writeln(format("Error: " ~ errorMessages[err.errorID] ~ " found at row %d, line %d.", err.row, err.column));
		}

		writeln(format(errorMessages[0], errors.length));

		Runtime.terminate();
	}
}