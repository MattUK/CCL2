module handler;

import core.runtime;
import std.stdio;
import std.string;

public struct BuildError {
	public int errorID;
	public int line, position;
	public dstring values;
}

public immutable dstring[] errorMessages =
	["%d errors were found during build, check output for details.",
	 "Unterminated string literal",
	 "Unexpected '.'",
	 "Unexpected character '%s',",
	 "Expected digit to follow decimal point"];

private BuildError[] errors;
private bool[dstring] flags;

public void setCompileFlag(dstring flag, bool value) {
	flags[flag] = value;
}

public bool getCompileFlag(dstring flag) {
	return flags[flag];
}

public void reportError(BuildError error) {
	errors ~= error;
}

public void reportWarning(dstring warning, int line, int position) {
	writeln(format("Warning: " ~ warning ~ " found at position %d, line %d.", position, line));
}

public void abortIfErrors() {
	if (errors.length > 0) {
		foreach(err; errors) {
			if (err.values.length > 0) {
				writeln(format("Error: " ~ errorMessages[err.errorID] ~ " found at position %d, line %d.", err.values, err.position, err.line));
			} else {
				writeln(format("Error: " ~ errorMessages[err.errorID] ~ " found at position %d, line %d.", err.position, err.line));
			}
		}

		writeln(format(errorMessages[0], errors.length));

		Runtime.terminate();
	}
}