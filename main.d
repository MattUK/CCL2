/**
 * ========= Written in the D programming language =========
 * ========================= CCL2 ==========================
 * An interpreted, dynamically-typed programming language.
 **/

module main;

import std.stdio;
import std.range;
import std.conv;
import std.array;
import util;

import tokenizer;

 

void main(string[] args)
{
	/* ===== Flags =====
	 * -v = verbose output
	 * 
	 */
	dstring t = "£";
	writeln(t);

	dchar c = t[0];
	writeln(c);

	writeln(t[0]);
}

