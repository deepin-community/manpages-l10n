# Templates directory

In this directory, the .po templates for already translated
upstream manpages are collected. For historical reasons, the
*primary* directory is updated from the Debian unstable
manpages. All other directories are considered secondary.

All directories are created automatically according to the
already existing directories in the *upstream* directory.
See the file README.md in the upstream directory for details.

The special directory *common-primary* contains template files
for msgids with multiple occurences, in order to create
a compendium for those strings. This can reduce the
workload of translators.

## Scripts

The script *update-templates.sh* is used to create or
update all template files from the upstream manpages.
It must be run each time after an update to the upstream
directory.

The script *create-common-templates.sh* is used to create or
update the template files which contain msgids with multiple
occurences.

They are grouped by the number of occurences, starting with
at least two same msgids.

If for some reason a msgid should not be included in the
common files, because it needs a different translation
depending on the context, it must be added to the file
*exclude.pot*. All msgids in that file will
not be part of the common .po template files.
