#!/usr/bin/python3

# Add all languages which should build a binary package
languages = {
    "cs": "Czech",
    "da": "Danish",
    "de": "German",
    "el": "Greek",
    "es": "Spanish",
    "fi": "Finnish",
    "fr": "French",
    "hu": "Hungarian",
    "id": "Indonesian",
    "it": "Italian",
    "mk": "Macedonian",
    "nb": "Norwegian",
    "nl": "Dutch",
    "pl": "Polish",
    "pt-br": "Brazilian Portuguese",
    "ro": "Romanian",
    "ru": "Russian",
    "sr": "Serbian",
    "sv": "Swedish",
    "uk": "Ukrainian",
    "vi": "Vietnamese",
}

# Add all languages which should *not* build a -dev binary package,
# because there are no translations yet
no_dev_packages = {
    "el",
    "fi",
    "hu",
    "id",
    "mk",
    "nb",
    "ro",
    "ru",
    "sv",
    "sr",
    "vi",
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

    if code not in no_dev_packages:
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

    if code not in no_dev_packages:
        with open("manpages-{}-dev.install".format(code), "w") as out:
            out.write("usr/share/man/{}/man2/*\n".format(locale(code)))
            out.write("usr/share/man/{}/man3/*\n".format(locale(code)))

# FIXME Should write out .links files as well?

with open("rules", "w") as out:
    out.write("#! /usr/bin/make -f\n\n")
    out.write("include /usr/share/dpkg/pkg-info.mk\n\n")
    out.write("%:\n")
    out.write("\tdh $@\n\n")
    out.write("override_dh_installman:\n")
    out.write("\tdh_installman\n")
    out.write("\t# Prevent broken symlinks, see https://bugs.debian.org/876047\n")
    out.write("\t# and https://bugs.debian.org/875419\n")
    for code, language in languages.items():
        out.write("\tif [ -L $(CURDIR)/debian/manpages-{}/usr/share/man/{}/man4/console_ioctl.4.gz ]; then \\\n".format(code, locale(code)))
        out.write("\t\tmkdir -p $(CURDIR)/debian/manpages-{}-dev/usr/share/man/{}/man4 ; \\\n".format(code, locale(code)))
        out.write("\t\tmv $(CURDIR)/debian/manpages-{}/usr/share/man/{}/man4/console_ioctl.4.gz \\\n".format(code, locale(code)))
        out.write("\t\t  $(CURDIR)/debian/manpages-{}-dev/usr/share/man/{}/man4 ; \\\n".format(code, locale(code)))
        out.write("\tfi\n")
        out.write("\tif [ -L $(CURDIR)/debian/manpages-{}/usr/share/man/{}/man4/tty_ioctl.4.gz ]; then \\\n".format(code, locale(code)))
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
Maintainer: Dr. Helge Kreutzmann <debian@helgefjell.de>
Uploaders: Dr. Tobias Quathamer <toddy@debian.org>
Section: doc
Priority: optional
Build-Depends: debhelper-compat (= 12)
Build-Depends-Indep: po4a (>> 0.71)
Rules-Requires-Root: no
Standards-Version: 4.7.0
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
        out.write("Description: {} man pages\n".format(language))
        out.write(" This package contains manual pages translated into {},\n".format(language))
        out.write(""" originating from a large number of projects which do not ship
 translated man pages themselves, including the traditional Linux
 manpages. The exact projects and man pages might change from
 release to release, so please look at the actually shipped files
 for the current set.
 .
 The following sections are included:
  * 1 = User programs (e.g. ls, ln)
  * 4 = Devices (e.g. hd, sd).
  * 5 = File formats and protocols, syntaxes of several system
        files (e.g. wtmp, /etc/passwd, nfs).
  * 6 = Games etc.
  * 7 = Conventions and standards, macro packages, etc.
        (e.g. nroff, ascii).
  * 8 = System administration commands.
 .
 The original (software) packages contain additional manual pages
 which have not been translated yet.

""")

        if code not in no_dev_packages:
            out.write("Package: manpages-{}-dev\n".format(code))
            out.write("""Architecture: all
Multi-Arch: foreign
Depends: ${misc:Depends}
Suggests: man-browser,
          manpages-dev,
          glibc-doc
""")
            out.write("Description: {} development manpages\n".format(language))
            out.write(" This package contains the Linux development manual pages\n")
            out.write(" translated into {}.\n".format(language))
            out.write(""" .
 The following sections are included:
  * 2 = Linux system calls.
  * 3 = Libc calls (note that a more comprehensive source of
        information may be found in one of the libc-doc packages).
 .
 The English package manpages-dev contains additional manual pages
 which have not been translated yet.
""")
