/*
  Purpose : just for fun
  Author  : Ky-Anh Huynh
  Date    : 2018 07 27
  License : MIT
*/

module pacapt.internals;

auto issue2pacman() {
  import std.stdio;
  import std.format;
  import std.file;
  import std.string;
  import std.process;

  auto pacman = "unknown";

  auto uname = execute("uname").output;
  if (uname == "SunOS") {
    pacman = "sun_tools";
    debug stderr.writefln("(debug) quickly pkg found from uname: %s", pacman);
    return pacman;
  }

  auto matches = [
    "Arch Linux"      : "pacman",
    "Debian GNU/Linux": "dpkg",
    "Ubuntu"          : "dpkg",
    "Exherbo Linux"   : "cave",
    "CentOS"          : "yum",
    "Red Hat"         : "yum",
    "SUSE"            : "zypper",
    "OpenBSD"         : "pkg_tools",
    "Bitrig"          : "pkg_tools",
    "Alpine Linux"    : "apk",
    "SunOS"           : "sun_tools",
  ];

  auto fname_issue = "/etc/issue";
  auto fname_os_release = "/etc/os-release";

  auto text = "";

  if (fname_issue.exists) {
    text ~= fname_issue.readText;
  }
  if (fname_os_release.exists) {
    text ~= "\n";
    text ~= fname_os_release.readText;
  }

  foreach (m, pkg; matches) {
    if (text.indexOf(m) > -1) {
      pacman = pkg;
      break;
    }
  }

  debug stderr.writefln("(debug) pkg found: %s", pacman);
  return pacman;
}
