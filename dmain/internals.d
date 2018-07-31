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
  import std.process: execute;

  auto pacman = "unknown";

  auto uname = "uname".execute.output;
  if (uname == "SunOS") {
    pacman = "sun_tools";
    debug stderr.writefln("(debug) quickly pkg found from uname: %s", pacman);
    return pacman;
  }

  auto const matches = [
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

  auto const fname_issue = "/etc/issue";
  auto const fname_os_release = "/etc/os-release";

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
  auto const standard_pacman = "/usr/bin/pacman";
  if (standard_pacman.isExecutable && (thisExePath != standard_pacman)) {
    pacman = "pacman";
    debug stderr.writefln("(debug) possibly found standard pacman: %s", standard_pacman);
    return pacman;
  }

  auto const executable_checks = [
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

  import std.process: executeShell;
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
  auto const exec_mode = octal!100; /* 00100, S_IXUSR, S_IEXEC*/
  return mode & exec_mode ? true : false;
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
    auto last_name = names[$-1];
    pacman = last_name;
  }

  return pacman;
}

unittest {
  auto p1 = programName2pacman("/usr/bin/pacman-foobar");
  auto p2 = programName2pacman("/usr/bin/pacman-conda");
  auto p3 = programName2pacman("/usr/bin/pacman.conda");
  assert(p1 == "foobar", "pacman-foobar should return unknown pacman [foobar]");
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


auto warning(in string text) {
  import std.stdio;
  stderr.writeln(":: Warning: " ~ text);
}

auto error(in string text) {
  import std.stdio;
  stderr.writeln(":: Error: " ~ text);
  throw new Exception(":: Error: " ~ text);
}

unittest {
  import std.exception: assertThrown, assertNotThrown;
  assertNotThrown("This is a test warning.".warning);
  assertThrown("This is an error message.".error);
}

auto buildPacmanMethod(pacmanOptions opts) {
  return false;
}

struct pacmanOptions {
  bool
    verbose = false,
    download_only = false,
    no_confirm = false,
    show_help = false,
    show_version = false,
    list_ops = false,
    quiet_mode = false,
    upgrades = false,
    refresh = false,
    result = true
    ;

  uint
    pQ = 0,
    pR = 0,
    pS = 0,
    pU = 0,
    ss = 0,
    sl = 0,
    si = 0,
    sp = 0,
    so = 0,
    sm = 0,
    sn = 0,
    clean = 0
    ;

  string[] args0;
  string[] remained;
  string pacman;
}
/*
  FIXME: This would be part of the help message.

  An overview of options from the stable pacapt script

    -h --help                 Help
    --noconfirm --no-confirm  No confirmation [Need translation]
    --                        Termination
    -V                        pacapt version
    -P                        List of supported operations
    -Q R S U  (+)             Primary action
    -s l i p o m n (+)        Secondary action
    -q                        Third option
    -u                        Converted to uy or u
    -y                        Same as above
    -c (+)                    Clean (c, cc, ccc)
    -w                        Download only [Need translation]
    -v                        Verbose [Need translation]
*/
auto argumentParser(string[] args) {
  import std.getopt;

  pacmanOptions opts;

  auto getopt_results = getopt(args,
    std.getopt.config.caseSensitive,
    std.getopt.config.bundling,
    std.getopt.config.passThrough,
    "query|Q+", "Query", &opts.pQ,
    "remove|R+", "Remove", &opts.pR,
    "sync|S+", "Sync", &opts.pS,
    "upgrade|U+", "Upgrade", &opts.pU,
    "search|s+", "Search", &opts.ss,
    "recursive+", "Recursive option used with --remove. Short version: -s", &opts.ss,
    "list|l+", "listing option", &opts.sl,
    "info|i+", &opts.si,
    "file|p+", &opts.sp,
    "owns|o+", &opts.so,
    "foreign|m+", &opts.sm,
    "n|nosave|native+", &opts.sn,
    "verbose|v", "Be verbose", &opts.verbose,
    "download-only|w", "Download without installing", &opts.download_only,
    "version|V", "Show pacapt version", &opts.show_version,
    "P", "Print list of supported options", &opts.list_ops,
    "quiet|q", "Be quiet in some operation", &opts.quiet_mode,
    "upgrades|u", &opts.upgrades,
    "refresh|y", "Refresh local package database", &opts.refresh,
    "noconfirm", "Assume yes to all questions", &opts.no_confirm,
    "no-confirm", "Assume yes to all questions", &opts.no_confirm,
    "clean|c+", "Clean packages.", &opts.clean,
  );

  opts.args0 = args[0..1];
  opts.remained = args[1..$];

  opts.pacman = programName2pacman(opts.args0.length > 0 ? opts.args0[0] : "");
  if (opts.pacman == "unknown") {
    opts.pacman = issue2pacman;
  }

  if (getopt_results.helpWanted) {
    defaultGetoptPrinter("List of options:", getopt_results.options);
    opts.result = false;
  }

  // FIXME: We should passthrough option
  if (opts.pQ + opts.pR + opts.pS + opts.pU != 1) {
    "Primary option (Q R S U) must be specified at most once.".warning;
    opts.result = false;
  }

  if (opts.download_only) {
    auto tx_download_only = translateWoption(opts.pacman);
    opts.args0 ~= tx_download_only;
    opts.result &= (tx_download_only.length > 0);
  }

  if (opts.verbose) {
    auto tx_verbose = translateDebugOption(opts.pacman);
    opts.args0 ~= tx_verbose;
    opts.result &= (tx_verbose.length > 0);
  }

  if (opts.no_confirm) {
    auto tx_no_confirm = translateNoConfirmOption(opts.pacman);
    opts.args0 ~= tx_no_confirm;
    opts.result &= (tx_no_confirm.length > 0);
  }

  debug(2) {
    import std.stdio, std.format;
    stderr.writefln(
"
(debug)
  Query         : %d
  Remove        : %d
  Sync          : %d
  Upgrade       : %d
  s             : %d
  l             : %d
  i             : %d
  p             : %d
  o             : %d
  m             : %d
  n             : %d
  download only : %b
  no confirm    : %b
  show version  : %b
  print ops     : %b
  quiet mode    : %b
  upgrades      : %b
  refresh       : %b
  remains       : %(%s %)
",
      opts.pQ, opts.pR, opts.pS, opts.pU,
      opts.ss, opts.sl, opts.si, opts.sp, opts.so, opts.sm, opts.sn,
      opts.download_only, opts.no_confirm, opts.show_version, opts.list_ops,
      opts.quiet_mode, opts.upgrades, opts.refresh,
      opts.remained,
    );
  }

  return opts;
}

unittest {
  import std.format;

  auto p1 = argumentParser(["pacman", "-R", "-U"]);
  assert(! p1.result, "Multiple primary action -RU is rejected.");

  auto p2 = argumentParser(["pacman", "-i", "-s"]);
  assert(! p2.result, "Primary action must be specified.");

  auto primary_actions = ["R", "S", "Q", "U"];
  foreach (p; primary_actions) {
    auto px = argumentParser(["pacman", "-" ~ p]);
    assert(px.result, "At least on primary action (%s) is acceptable.".format(p));
    auto py = argumentParser(["pacman", "-" ~ p ~ p]);
    assert(! py.result, "Multiple primary action (%s) is not acceptable.".format(p));
  }

  auto p3 = argumentParser(["/usr/bin/pacman", "-R", "-s", "-h"]);
  assert(! p3.result, "Help query should return false");
  assert(p3.pacman == "pacman", "Found pacman package manager.");

  auto p4 = argumentParser(["pacman", "-R", "--", "-R"]);
  assert(p4.result, "Termination (--) is working fine.");

  auto p5 = argumentParser(["pacman", "-S", "-cc", "-c"]);
  assert(p5.result && (p5.clean >= 3), "-Sccc (%d) bundling is working fine".format(p5.clean));

  auto p6 = argumentParser(["/usr/bin/pacapt-tazpkg", "-Suw"]);
  assert(p6.result == false, "tarzpkg does not support -w.");
  assert(p6.pacman == "tazpkg", "Found correct pacman: tazpkg");

  auto p7 = argumentParser(["/usr/local/bin/pacapt-macports", "-Suwv"]);
  assert(p7.result, "macports supports -w.");
  assert(p7.pacman == "macports", "Should found macports");
  assert(p7.args0[1] == "fetch", "macports injects custom options [%(%s, %), %(%s, %)]".format(p7.args0, p7.remained));
}

auto translateWoption(in string pacman) {
  auto const translations = [
    "pacman": "-w",
    "dpkg": "-d",
    "dave": "-f",
    "macports": "fetch",
    "portage": "--fetchonly",
    "zypper": "--download-only",
    "pkgng": "fetch",
    "yum": "--downloadonly", /* FIXME: require package 'yum-downloadonly' */
    "apk": "fetch",
  ];

  if (pacman == "tazpkg") {
    "Please use tazpkg get ... to download and save packages".warning;
  }

  string[] result = [];
  foreach (k,v; translations) {
    if (pacman == k) {
      result ~= v;
      break;
    }
  }

  return result;
}

unittest {
  assert(translateWoption("tazpkg") == []);
  assert(translateWoption("pkgng") == ["fetch"]);
  assert(translateWoption("foobar") == []);
}

// FIXME: Update environment DEBIAN_FRONTEND=noninteractive
// FIXME: There is also --force-yes for a stronger case
auto translateNoConfirmOption(in string pacman) {
  auto const translations = [
    "pacman": "--noconfirm",
    "dpkg": "--yes",
    "dnf": "--assumeyes",
    "yum": "--assumeyes",
    "zypper": "--no-confirm",
    "pkgng": "-y",
    "tazpkg": "--auto",
  ];

  string[] result = [];
  foreach (k,v; translations) {
    if (pacman == k) {
      result ~= v;
      break;
    }
  }

  return result;
}

unittest {
  assert(translateNoConfirmOption("foobar") == []);
}

auto translateDebugOption(in string pacman, in string opt = "-v") {
  string[] result = [];
  if (pacman == "tazpkg") {
    "Debug option (-v) is not supported by tazpkg".warning;
  }
  else {
    result ~= opt;
  }
  return result;
}

unittest {
  assert(translateDebugOption("tazpkg") == []);
  assert(translateDebugOption("pacman") != []);
}
