#!/usr/bin/python3

# Add all languages which should build a binary package
languages = {
    "de": "German",
    "es": "Spanish",
    "fr": "French",
    "it": "Italian",
    "mk": "Macedonian",
    "nl": "Dutch",
    "pl": "Polish",
    "pt-br": "Brazilian Portuguese",
    "ro": "Romanian",
}

def locale(code):
    locale = code
    parts = code.split("-")
    if len(parts) > 1:
        locale = parts[0] + "_" + parts[1].upper()
    return locale

# Generate helper control files
for code, name in languages.items():
    with open("manpages-{}.docs".format(code), "w") as out:
        out.write("README.md\n")

    with open("manpages-{}-dev.docs".format(code), "w") as out:
        out.write("README.md\n")

    with open("manpages-{}.install".format(code), "w") as out:
        out.write("usr/share/man/{}/man1/*\n".format(locale(code)))
        out.write("usr/share/man/{}/man2/intro.2.gz\n".format(locale(code)))
        out.write("usr/share/man/{}/man3/intro.3.gz\n".format(locale(code)))
        out.write("usr/share/man/{}/man4/*\n".format(locale(code)))
        out.write("usr/share/man/{}/man5/*\n".format(locale(code)))
        out.write("usr/share/man/{}/man6/*\n".format(locale(code)))
        out.write("usr/share/man/{}/man7/*\n".format(locale(code)))
        out.write("usr/share/man/{}/man8/*\n".format(locale(code)))

    with open("manpages-{}-dev.install".format(code), "w") as out:
        out.write("usr/share/man/{}/man2/*\n".format(locale(code)))
        out.write("usr/share/man/{}/man3/*\n".format(locale(code)))

with open("rules", "w") as out:
    out.write("#! /usr/bin/make -f\n\n")
    out.write("%:\n")
    out.write("\tdh $@\n\n")
    out.write("override_dh_installman:\n")
    out.write("\tdh_installman\n")
    out.write("\t# Prevent broken symlinks, see https://bugs.debian.org/876047\n")
    out.write("\t# and https://bugs.debian.org/875419\n")
    for code, language in languages.items():
        out.write("\tif [ -e $(CURDIR)/debian/manpages-{}/usr/share/man/{}/man4/console_ioctl.4.gz ]; then \\\n".format(code, locale(code)))
        out.write("\t\tmkdir -p $(CURDIR)/debian/manpages-{}-dev/usr/share/man/{}/man4 ; \\\n".format(code, locale(code)))
        out.write("\t\tmv $(CURDIR)/debian/manpages-{}/usr/share/man/{}/man4/console_ioctl.4.gz \\\n".format(code, locale(code)))
        out.write("\t\t  $(CURDIR)/debian/manpages-{}-dev/usr/share/man/{}/man4 ; \\\n".format(code, locale(code)))
        out.write("\tfi\n")
        out.write("\tif [ -e $(CURDIR)/debian/manpages-{}/usr/share/man/{}/man4/tty_ioctl.4.gz ]; then \\\n".format(code, locale(code)))
        out.write("\t\tmkdir -p $(CURDIR)/debian/manpages-{}-dev/usr/share/man/{}/man4 ; \\\n".format(code, locale(code)))
        out.write("\t\tmv $(CURDIR)/debian/manpages-{}/usr/share/man/{}/man4/tty_ioctl.4.gz \\\n".format(code, locale(code)))
        out.write("\t\t  $(CURDIR)/debian/manpages-{}-dev/usr/share/man/{}/man4 ; \\\n".format(code, locale(code)))
        out.write("\tfi\n")
    out.write("\t# Remove intro.{2,3} manpages from manpages-LANGUAGE-dev,\n")
    out.write("\t# they are included in manpages-LANGUAGE\n")
    for code, language in languages.items():
        out.write("\trm -f debian/manpages-{}-dev/usr/share/man/{}/man2/intro.2\n".format(code, locale(code)))
        out.write("\trm -f debian/manpages-{}-dev/usr/share/man/{}/man3/intro.3\n".format(code, locale(code)))

with open("control", "w") as out:
    out.write("""Source: manpages-l10n
Maintainer: Dr. Tobias Quathamer <toddy@debian.org>
Uploaders: Dr. Helge Kreutzmann <debian@helgefjell.de>
Section: doc
Priority: optional
Build-Depends: debhelper-compat (= 12)
Build-Depends-Indep: po4a
Rules-Requires-Root: no
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/debian/manpages-l10n
Vcs-Git: https://salsa.debian.org/debian/manpages-l10n.git
Homepage: https://manpages-l10n-team.pages.debian.net/manpages-l10n/
""")

    for code, language in languages.items():
        out.write("\nPackage: manpages-{}\n".format(code))
        out.write("""Architecture: all
Multi-Arch: foreign
Depends: ${misc:Depends}
Suggests: man-browser,
          manpages
""")
        out.write("Description: {} manpages\n".format(language))
        out.write(" This package contains the Linux manual pages translated into {}.\n".format(language))
        out.write(""" The following sections are included:
  * 1 = User programs (e.g. ls, ln)
  * 4 = Devices (e.g. hd, sd).
  * 5 = File formats and protocols, syntaxes of several system
        files (e.g. wtmp, /etc/passwd, nfs).
  * 6 = Games etc.
  * 7 = Conventions and standards, macro packages, etc.
        (e.g. nroff, ascii).
  * 8 = System administration commands.
 .
 The English package manpages contains additional manual pages
 which have not been translated yet.

""")
        out.write("Package: manpages-{}-dev\n".format(code))
        out.write("""Architecture: all
Multi-Arch: foreign
Depends: ${misc:Depends}
Suggests: man-browser,
          manpages-dev,
          glibc-doc
""")
        out.write("Description: {} development manpages\n".format(language))
        out.write(" This package contains the Linux manual pages translated into {}.\n".format(language))
        out.write(""" The following sections are provided:
  * 2 = Linux system calls.
  * 3 = Libc calls (note that a more comprehensive source of
        information may be found in one of the libc-doc packages).
 .
 The English package manpages-dev contains additional manual pages
 which have not been translated yet.
""")
