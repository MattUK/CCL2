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
	string t = "£";
	writeln(t); // Output: $

	char c = t[0];
	writeln(c); // Output: ?

	writeln(t[0]); // Output: ?
}

