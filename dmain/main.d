/*
  Author  : Ky-Anh Huynh
  License : MIT
  Date    : 2018 07 27
  Purpose : just for fun
*/

import std.stdio;
public import pacapt.internals;

void main(string[] args) {
  auto pacman = guessPacman;
  if (pacman == "unknown") {
    "Unable to detect pacman.".error;
  }
  writefln("Your pacman is %s", pacman);

  auto opts = argumentParser(args, pacman);
  if (! opts.result) {
    "Unable to parse input arguments.".error;
  }

}
