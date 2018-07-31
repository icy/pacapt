/*
  Author  : Ky-Anh Huynh
  License : MIT
  Date    : 2018 07 27
  Purpose : just for fun
*/

import std.stdio;
public import pacapt.internals;

void main(string[] args) {
  auto opts = pacmanOptions(args);
  if (opts.pacman == "Unknown") {
    "Unable to detect pacman.".error;
  }
  if (! opts.result && ! opts.help_wanted) {
    "Unable to parse input arguments.".error;
  }

}
