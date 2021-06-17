%global debug_package %{nil}
Name:           pacapt
Version:        2.3.15
Release:        1%{?dist}
Summary:        An Arch's pacman-like package manager for some Unices
License:        Fair
URL:            https://github.com/icy/pacapt
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

%description
An Arch's pacman-like package manager for some Unices. Actually this Bash script provides a wrapper for system's package manager. For example, on CentOS machines, you can install htop with command

$ pacapt -S htop

Instead of remembering various options/tools on different OSs, you only need a common way to manipulate packages. Not all options of the native package manager are ported; the tool only provides a very basic interface to search, install, remove packages, and/or update the system.

Arch's pacman is chosen, as pacman is quite smart when it divides all packages-related operations into three major groups: Synchronize, Query and Remove/Clean up. It has a clean man page, and it is the only tool needed to manipulate official packages on system. (Debian, for example, requires you to use apt-get, dpkg, and/or aptitude.)

The tool supports the following package managers:

    pacman by Arch Linux, ArchBang, Manjaro, etc.
    dpkg/apt-get by Debian, Ubuntu, etc.
    homebrew by Mac OS X
    macports by Mac OS X
    yum/rpm by Redhat, CentOS, Fedora, etc.
    portage by Gentoo
    zypper by OpenSUSE
    pkgng by FreeBSD
    cave by Exherbo Linux
    pkg_tools by OpenBSD
    sun_tools by Solaris(SunOS)
    apk by Alpine Linux

%prep
%setup -q

%build
rm -rf bin,contrib,tests,lib,.gitignore,CHANGELOG.md,CONTRIBUTING.md,COPYING,Makefile,README.md,TODO

%install
mkdir -p %buildroot/usr/local/bin
install -m755 pacapt %buildroot/usr/local/bin
ln -s /usr/local/bin/pacapt %buildroot/usr/local/bin/pacman

%clean
rm -rf %_buildrootdir

%files
/usr/local/bin/pacapt
/usr/local/bin/pacman

%changelog
* Sun Jun 17 2018 Ky-Anh Huynh(icy) <kyanh@theslinux.org> - 1
- Updated version (2.3.14 -> 2.3.15)
* Thu Oct 20 2017 Ky-Anh Huynh(icy) <kyanh@theslinux.org> - 1
- Updated version (2.3.13 -> 2.3.14)
* Thu Jul 21 2016 Ky-Anh Huynh(icy) <kyanh@theslinux.org> - 1
- Updated version (2.3.12 -> 2.3.13)
* Wed Jul 20 2016 Ky-Anh Huynh(icy) <kyanh@theslinux.org> - 1
- Updated version (2.3.11 -> 2.3.12)
* Mon Jul 11 2016 Ky-Anh Huynh(icy) <kyanh@theslinux.org> - 1
- Updated version (2.3.10 -> 2.3.11)
* Mon Jul 11 2016 Ky-Anh Huynh(icy) <kyanh@theslinux.org> - 1
- Updated version (2.3.9 -> 2.3.10)
* Fri Jul 8 2016 Ky-Anh Huynh(icy) <kyanh@theslinux.org> - 1
- Updated version (2.3.8 -> 2.3.9)
* Fri Jul 8 2016 Valerio Pizzi(Pival81) <pival81@yahoo.com> - 1
- Changed the installation directory (/usr/local/bin instead of /bin).
* Fri Jun 10 2016 Valerio Pizzi(Pival81) <pival81@yahoo.com> - 1
- Updated version (2.2.7 -> 2.3.8)
* Thu Jun 9 2016 Valerio Pizzi(Pival81) <pival81@yahoo.com> - 1
- Initial package.
