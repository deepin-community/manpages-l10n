# manpages-nl

This is an attempt to partially reanimate a former localization project for
manpages, which resided at http://www.win.tue.nl/~aeb/linux/man/index.html and
has been abandoned in 2001.

As far it is possible, we try to import the old and outdated Dutch textual
translations into *.po files. Moreover, we reuse UI strings. This means, we
create localized man pages using »helpman -L« and import the contents. This way
all man pages from the »coreutils« package are already present.

The tarball of the latest release is still available from:
https://www.win.tue.nl/~aeb/ftpdocs/linux-local/manpages/translations/man-pages-nl-0.13.3.tar.gz

The translation of tar.1 is based on the work of Erwin Poeze, Elros Cyriatan
and Benno Schulenberg, available at the GNU Translation Project:
https://translationproject.org/latest/tar/nl.po
Because this man page is generated with help2man, it was easier to import from
the UI translation than to write a new translation from scratch.
