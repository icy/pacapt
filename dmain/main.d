/*
  Author  : Ky-Anh Huynh
  License : MIT
  Date    : 2018 07 27
  Purpose : just for fun
*/

import std.stdio;
public import pacapt.internals;

void main() {
  auto pacman = guessPacman;
  if (pacman == "unknown") {
    "Unable to detect pacman from program name and/or system issue information".error;
  }
  writefln("Your pacman is %s", pacman);
}
