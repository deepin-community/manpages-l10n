#!/bin/sh
set -e

last_release=$(git for-each-ref --count=1 --sort="-committerdate" refs/tags | cut -f2 | cut -d/ -f3)

echo "## Version X.X"
echo
echo "* New translations:"
git diff --name-status $last_release po/*/man*/ |
grep "^A" |
cut -f2 |
LC_ALL=C sort |
cut -d"/" -f4 |
sed -e "s/\.po$//" |
perl -e "my @a; while (<>) { chomp; push(@a, \$_); } print join(', ', @a); print \"\\n\";" |
fold --spaces --width=68 |
perl -ne "print '  '; print;"

echo "* Removed translations:"
git diff --name-status $last_release po/man?/ |
grep "^D" |
cut -f2 |
LC_ALL=C sort |
cut -d"/" -f4 |
sed -e "s/\.po$//" |
perl -e "my @a; while (<>) { chomp; push(@a, \$_); } print join(', ', @a); print \"\\n\";" |
fold --spaces --width=68 |
perl -ne "print '  '; print;"


echo
echo
