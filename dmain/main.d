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

  if (opts.show_pacman) {
    writeln(opts.pacman);
    return;
  }

  if (opts.help_wanted) {
    show_help;
    return;
  }

  if (opts.show_version) {
    opts.showVersion;
    return;
  }

  if (opts.list_ops) {
    opts.showSupportedOps;
    return;
  }

  if (! opts.result) {
    "Unable to parse input arguments.".error;
  }

  if (opts.pacman == "unknown") {
    "Unable to detect pacman.".error;
  }

  opts.executeScript;
}
