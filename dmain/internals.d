/*
  Purpose : just for fun
  Author  : Ky-Anh Huynh
  Date    : 2018 07 27
  License : MIT
*/

module pacapt.internals;

auto issue2pacman() {
  debug import std.stdio;
  debug import std.format;
  import std.file;
  import std.string: indexOf;
  import std.process: execute, executeShell;

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

  if (pacman != "unknown") {
    debug stderr.writefln("(debug) pkg found: %s", pacman);
    return pacman;
  }

  // Loop detection
  auto standard_pacman = "/usr/bin/pacman";
  if (standard_pacman.isExecutable && (thisExePath != standard_pacman)) {
    pacman = "pacman";
    debug stderr.writefln("(debug) possibly found standard pacman: %s", standard_pacman);
    return pacman;
  }

  auto executable_checks = [
    "/data/data/com.termux/files/usr/bin/apt-get" : "dpkg",
    "/usr/bin/apt-get"    : "dpkg",
    "/usr/bin/cave"       : "cave",
    "/usr/bin/dnf"        : "dnf",
    "/usr/bin/yum"        : "yum",
    "/opt/local/bin/port" : "macports",
    "/usr/bin/emerge"     : "portage",
    "/usr/bin/zypper"     : "zypper",
    "/usr/sbin/pkg"       : "pkgng",
    "/usr/sbin/pkgadd"    : "sun_tools",
    "/sbin/apk"           : "apk",
    "/usr/bin/tazpkg"     : "tazpkg",
    "/usr/bin/swupd"      : "swupd",
  ];


  foreach (path, pkg; executable_checks) {
    if (path.isExecutable) {
      pacman = pkg;
      break;
    }
  }

  if (pacman != "unknown") {
    debug stderr.writefln("(debug) pkg from executable file: %s", pacman);
    return pacman;
  }

  // make sure pkg_add is after pkgng, FreeBSD base comes with it until converted
  if ("/usr/sbin/pkg_add".isExecutable) {
    debug stderr.writefln("(debug) FreeBSD pkg_add found");
    pacman = "pkg_tools";
    return pacman;
  }

  auto brew_status = "command -v brew >/dev/null".executeShell.status;
  if (brew_status == 0) {
    debug stderr.writefln("(debug) Found homebrew in search path");
    pacman = "homebrew";
    return pacman;
  }

  // We give up now.
  return pacman;
}

auto isExecutable(in string path) {
  import std.file: getAttributes, exists;
  import std.conv: octal;
  auto mode = path.exists ? path.getAttributes() : 0;
  auto exec_mode = octal!100; /* 00100, S_IXUSR, S_IEXEC*/
  if (mode & exec_mode) {
    return true;
  }
  else {
    return false;
  }
}

unittest {
  auto a10 = "/usr/bin/chmod".isExecutable;
  auto a11 = "/sbin/chmod".isExecutable;
  auto b10 = "/usr/non/existent".isExecutable;
  assert(a10 || a11, "chmod is executable and found from /usr/bin/ or /sbin");
  assert(! b10, "Non existent file should not be executable");
}

auto programName2pacman(in string path = "") {
  import std.file: thisExePath;
  import std.path: baseName, stripExtension;
  import std.string: split, indexOf;

  auto base_name = (path == "" ? thisExePath : path).baseName.stripExtension;
  auto names = base_name.split("-");
  auto pacman = "unknown";

  if (names.length > 1) {
    auto const supported_pacmans = ":conda:tlmgr:texlive:gem:npm:pip:";
    auto last_name = names[$-1];
    if (supported_pacmans.indexOf(":" ~ last_name ~ ":") > -1) {
      pacman = last_name;
    }
  }

  return pacman;
}

unittest {
  auto p1 = programName2pacman("pacman-foobar");
  auto p2 = programName2pacman("pacman-conda");
  auto p3 = programName2pacman("pacman.conda");
  assert(p1 == "unknown", "pacman-foobar should return unknown pacman");
  assert(p2 == "conda", "pacman-conda should return conda pacman");
  assert(p3 == "unknown", "pacman.conda with dot splitter is not supported");
}

auto guessPacman() {
  auto pacman = programName2pacman;
  if (pacman == "unknown") {
    pacman = issue2pacman;
  }
  return pacman;
}
