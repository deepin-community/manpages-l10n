#!/bin/bash
#
# Copyright © 2010-2019 Dr. Tobias Quathamer <toddy@debian.org>
#           © 2021 Dr. Helge Kreutzmann <debian@helgefjell.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

header=$(mktemp)
tail=$(mktemp)
result=$(mktemp)

if [ "$1" == "-h" ]; then
  echo "Usage: ./`basename $0` language_code"
  echo This script reformats any *.po files. It wraps the lines at 80 characters
  echo and removes outdated messages at the end of the file. 
  echo ""
  echo It is mandatory to submit the language code as parameter.
  echo ""
  echo Alternatively call it directly from the language directory, e.g. po/fr.
  exit 0
fi

if [ -d man1 ]; then
    lcode=$(basename $(pwd))
elif [ a"$1" != a ]; then
    if [ -d $1 ]; then
        cd $1
        lcode=$1
    else
        echo "Language $1 could not be found, aborting"
        exit 11
    fi
else
    echo "Could not determine target directory, aborting"
    exit 12
fi

source ../l10n_set

translations=$(find man* -name "*.po" | LC_ALL=C sort)
for translation in $translations; do
	# Get the head of the file until first msgid line
	# and filter out all comment lines without year information
	sed -n "1,/^msgid/p" "$translation" |
	grep -v "^# $langname translation of manpages" |
	grep -v "^# This file is distributed under the same license as the manpages-l10n package." |
	grep -v "^# Copyright © of this file:" |
	grep -v "^#\s*$" > "$header"
	sed -e "1,/^msgid/d" "$translation" > "$tail"
	echo "# $langname translation of manpages" > "$result"
	echo "# This file is distributed under the same license as the manpages-l10n package." >> "$result"
	echo "# Copyright © of this file:" >> "$result"
	cat "$result" "$header" "$tail" > "$translation"
	# Reformat manpage to wrap lines
	msgcat "$translation" > "$result"
	mv "$result" "$translation"
done

# Reformat all common messages
echo "Processing common messages"
for translation in common/*po; do
	msgcat --force-po "$translation" > "$result"
	mv "$result" "$translation"
done

rm -f "$header" "$tail" "$result"
