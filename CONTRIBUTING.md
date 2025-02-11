# Contributing to the manpages-l10n project

As described in the file README.md, the manpages-l10n project provides a
suitable infrastructure for man page translations. Here we describe the
workflow of fetching the upstream man pages, translating and finally publishing
the translations.

## Quick start / typical workflow

The following describes a typical workflow. You can find more details below,
if you are interested. Let's assume, you want to update echo.1.po.

First, ensure your copy of the repository is up to date:

`# git pull`

Next, ensure that you have all translations from the compendium:

`# ../update-po.sh man1/echo.1.po`

Now update man1/echo.1.po. Don't forget to put yourself in the copyright
line. Once finished, add it to the repository and compendium

`# git pull`

`# ../use-for-compendium.sh man1/echo.1.po`

Now commit the update. In this example, I assume your language code is
"NN". The exact message is of course up to you, but please always keep the
first chunk with the language code:

`# git commit -a -m "[nn] Update translation of echo.1"`

`# git push`

That's it.

## Workflow after an upstream update

During an upstream update the compendium gets lots of slightly changed
strings, e.g. new dates or updated version numbers. I recommend the
following:

Ensure you are up to date:

`# git pull`

Change to the compendium

`# cd common`

Now edit min-100-occurences.po, min-020-occurences.po, min-010-occurences.po
Update (translate, unfuzzy) all easy strings, like dates, updated versions
etc.

Next, commit them:

`# git pull`

`# git commit -a -m "[nn] Unfuzzy/translate compendium"`

The next step takes a few minutes, but saves you lots of time:

`# cd ..`

`# ../update-translations.sh`

`# git pull`

`# git commit -a -m "[nn] Update translations from compendium"`

And now you can check which other updates you'll need, by jumping back
to the typical workflow from above.

## What is the compendium?

Several strings are re-used. For example, section headings (like "SEE
ALSO"), dates, or typical strings like
"This is free software: you are free to change and redistribute it.  There is "
"NO WARRANTY, to the extent permitted by law."

The compendium takes care that you only translate those strings once.
When you update a page with `../update-po.sh` or create a new po file
for translation, the scripts look in the compendium. If they find some
of the strings, they automatically add them to your translation.

For example, when I create a German translation for a man page in
section 2 or 3, sometimes 60-70% of the strings are reused, i.e.
already present from the compendium.

This saves quite a bit of work and takes care that subtle translation
errors and inconsistencies are avoided.

Therefore, I recommend to add a translation (once finished or if it was
proof read) to the compendium, using `../use-for-compendium.sh`. Also, if
you fix a translation you should usually call this script.

The compendium files are located under common/, where you can also
edit them directly (they are po files). The higher the number in the
file name, the more often the string appears. So once in a while, e.g.
after an upstream update, it might be sensible to edit them first and
then run

`#../update-translations.sh`

This script takes a few minutes to complete, but saves you tedious
work, e.g. with updated version strings or dates.

## Getting the upstream man pages

We support multiple distributions. To get the upstream man pages, we maintain
package lists for each distribution in
upstream/*distribution_name*/packages.txt. Usually we download all the listed
packages once or twice a month and unpack the man pages, using the script
upstream/update-distribution-manpages.sh. This script puts also the links
together so that they don't appear later as translatable files.

Note: Sometimes it is needed to keep the version number of a package in the
packages.txt files. In such cases, make sure that a package with that version
number really exists in the distribution repositories. If it doesn't exist,
nothing will be downloaded and the man pages of that package will vanish from
the upstream/ directory and finally vanish from the appropriate translation
templates. Currently this applies to some systemd* packages and sane-backends
in Opensuse (both Tumbleweed and Leap) and openssl in Archlinux. Improvements
of the script are welcome!

To get an overview which man pages are available from the supported packages,
but are still untranslated, the files
upstream/*distribution_name*/untranslated.txt will be created. This includes
only the man pages for which a template already exists, means: for which are
.po files available from other languages. Therefore the list is incomplete.
If you like to translate a certain man page, run the script
`../create-new-translation.sh` from the po/*your_language* directory. If it
succeeds, the appropriate man page already exists in at least one of the
upstream directories, and the .po file and the corresponding template
get created. If it fails, contact the manpages-l10n maintainer, giving some
hints where the man page can be found (package name).


## Creating the templates

After updating the contents of upstream/*distribution_name*/man*, we create the
templates. The script templates/update-all-templates.py updates the existing
\*.pot files based on the new upstream man pages. You can run the script
templates/generate-one-template.sh to generate a new or to update an existing
template.


## Updating the translations

Run the command `../update-translations.sh` to update the existing \*.po files
(ideally as `../update-translations.sh` from your language directory),
based on the previously changed templates. Later you can run
`../update-po.sh` to update a single .po file or
`../update-translations.sh` to update all existing .po files again
from the current templates and compendium files (see below for how to use the
compendium).


## Use consistent file headers

The header of a .po file usually looks as follows:

~~~
# German translation of manpages
# This file is distributed under the same license as the manpages-l10n package.
# Copyright © of this file:
# Mario Blättermann <mario.blaettermann@gmail.com>, 2015.
~~~

The first three lines will be added automatically if they don't exist. But from
the fourth line on, you must not write other lines than those with translator
names, mail addresses and the copyright year. Otherwise, some of our scripts
won't work properly. The script `../generate-manpage.sh`
needs this for generate the addendum. The script `create-authors-file.sh` also
reads translator names from there and would produce garbage if there are some
additional lines.

One exception: Comment lines starting with # FIXME will be ignored by the
scripts. But maybe it is more useful to put such FIXMEs directly above the
affected Gettext messages.

*NOTE:* Lokalize in version 23.08.1 generates header lines in the following shape:
~~~
# SPDX-FileCopyrightText: 2023 Mario Blättermann <mario.blaettermann@gmail.com>
~~~
This would lead to odd entries in the man page addendum and the file AUTHORS.md.
You need to fix this line manually. Obviously this can't be fixed in the
configuration of Lokalize. It has been filed as a bug:
https://bugs.kde.org/show_bug.cgi?id=475166

## Git workflow for reviewed .po files

After translating and reviewing a .po file (assuming you was using a copy of
that file and haven't applied your changes directly in your local Git checkout),
you should do the following steps:

* Run `git pull` to get the latest changes from other submitters.
* Verify your .po file with `msgfmt -vc`.
* Put your .po file at the right place in the Git hierarchy (don't commit it for
  the time being).
* Run `git status` and/or `git diff` to see what would be changed.
* Run the script `../update-po.sh` to merge your .po file
  with the latest template and the messages from compendium. Now you should take
  a look again at the .po file. If there's something wrong, fix it.
* Commit your .po file. The command should look as follows:

~~~
git commit -a -m "[de] Update chown.1.po"
~~~

* To make it easier to distinguish between the different languages, prepend
  [your_language_code] to the commit message.
* Run `git push`. Normally, all should be fine after typing your SSH password.
  But in some cases, another contributor has applied some changes in the
  meantime. Then Git refuses the commit. Just run `git pull` first. This applies
  the remote changes to your local repo and opens an editor where you can change
  the commit message. In most cases, it is unneeded to change anything, just
  close the editor (after saving the message, if needed).
  
  
## Using the helper scripts

Most of the helper scripts in po/ accept the `-h` switch to display a short help
message. Usually the scripts are intended to be called from your language
subdirectory, for example `cd po/de && ../format-po.sh`

### Creating new translations

The script `../create-new-translation.sh` creates a new .po
file. This presupposes that the original Groff or Mdoc file already exists in
upstream/man\* for at least one of our supported distributions. If not, try to
figure out the name of the distribution package which contains that man page and
contact [Mario Blättermann](mailto:mario.blaettermann@gmail.com) to get it into
manpages-l10n. Besides the .po file creation, the script creates - if needed - a
template and updates the compendium templates in templates/common/ and the compendium
files for your language in po/*your_language_code*/common. The script never affects
other languages than your own. Note: Remember to run `git add <file>`
after you have created and/or updated the new file before you make the `git push` command.


### Fill and use the compendium

After reviewing and committing a .po file, you can run
`../use-for-compendium.sh` to add the previously reviewed
Gettext messages to your compendium. Example:
`../use-for-compendium.sh man1/chown.1.po`. This makes sense if your .po file
contains some messages which also appear in other .po files. The script
recognizes messages with at least two occurrences in our man page collection.
Note, you always have to submit the relative path, a simple file name isn't
sufficient.

After adding the file to the compendium, you can write the changes back to all
.po files with the command `../update-translations.sh`.

It might happen that you encounter a Gettext message which is ambiguous and
shouldn't be used for the compendium. In such cases, add the message to the file
templates/exclude.pot, as follows:

~~~
msgid "I<source>"
msgstr ""
~~~

Don't forget the empty `msgstr ""`, otherwise the update of the templates will
fail next time! After adding the message, first run the script
`templates/create-common-templates.sh`. This makes sure that the undesired
message really vanishes from the compendium. After that, you should also run the
script `../update-common.sh` (at least for your own language) to prevent other
scripts like `../create-new-translation.sh` or `../update-po.sh` from
using this Gettext message again. Although this procedure will be done for all
supported languages during the next update from upstream packages, in the
meantime it can happen that the mentioned scripts let the undesired messages
reappear in your .po files.

### Formatting \*.po files

The script `../format-po.sh` formats all .po files of your
language as `msgcat -w 80` would do; it wraps all lines at 80 characters.
Besides that, the unused Gettext messages at the end of the .po files will be
removed. Note, this script expects proper .po files; run
`msgfmt -vc *your_po_file*` to make sure the file is properly formatted in terms
of Gettext. Otherwise, the script can destroy a file completely and you need to
revert the changes.


### Generating translated man pages

A single translated man page can be created with the command
`../generate-manpage.sh *distribution_name* *your_po_file*`,
for example (from your .po directory) `../generate-manpage.sh archlinux man1/chown.1.po`.
This creates the man page in a subdirectory named »archlinux«. But you can also
generate all man pages from the whole .po collection using the command
`../generate-all-manpages.sh *distribution_name*`. All the
generated man pages get an addendum, which consists of the translators names and
mail addresses as found in the .po file headers, and a license declaration,
taken from the file po/*your_language_code*/license.add.

### Safety checks using git hooks

Git hooks are a way to run scripts before or after specific steps.
The `hooks` directory currently contains the `pre-commit` script, which will check the formatting of .po files about to be committed and abort the commit with an explanation in case some of these files are invalid.

To 'install' this hook, run from the root folder of the project:

~~~
ln -s ../../hooks/pre-commit .git/hooks/pre-commit
~~~

### Automatic composing of [DONE] messages using git hooks

Using the same git hook as above, it as also possible to enable the automatic composing of "[DONE]" messages to your l10n mailing list when you commit new translations.
To enable this feature, follow the same instruction as above to activate the git hook, then create a configuration file using the template provided:

~~~
cp hooks/pre-commit.conf.template hooks/pre-commit.conf
~~~

Once the file _pre-commit.conf_ exists, just fill it with the required info.

WARNING: this hook requires the curl package to be installed.

## Get involved in the package management

manpages-l10n has a multidistro purpose, thus would need to be released every
3 months. If you want to help for this administrative tasks, here is what you need to do.

First, you need to get the appropriate rights on the salsa repo.

Next:
* Search with grep for the current version number. You'll get some
occurrences in 'configure', 'configure.ac', 'CHANGES.md' etc.
(Don't bother with the version numbers in .po file headers)

~~~
grep '^AC_INIT' configure.ac | sed 's/.*\[\(.*\)\].*/\1/'
grep '^##' CHANGES.md | head -n1
~~~

* Replace the old version number with the new one in configure.ac
* Write an appropriate entry in CHANGES.md.
* Run 'autoreconf'
* Commit and push the changes.

* Create the appropriate tag:
** In commandline:
~~~
git tag -a -m 'Release 4.22.0' 4.22.0
~~~

replace with the appropriate release number
"-a" for annotation, commonly used for releases
(https://git-scm.com/docs/git-tag)

"-m " is the message you mentioned

"4.22.0" is the tag name

* Push the tag:
~~~
git push --tags
~~~

Once the pipeline completed, do the release in the web interface under
Deploy → Releases. Use the 'Release 4.21.0' and add the changelog
into the form.

That's all. Users and downstream packagers can now download the
tarball from the known location.
