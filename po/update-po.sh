#!/bin/bash
#
# Copyright © 2010-2019 Dr. Tobias Quathamer <toddy@debian.org>
#             2021 Dr. Helge Kreutzmann <debian@helgefjell.de>
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

if [ -d man1 ]; then
    lcode=$(basename $(pwd))
    manname=$1
elif [ a"$2" != a ]; then
    if [ -d $2 ]; then
        cd $2
        lcode=$2
	# Due to the cd, we need to reconstruct $1
	mfilename=$(basename $1)
	mdirname=$(basename $(dirname $1))
	manname=$mdirname/$mfilename
    else
        echo "Language $2 could not be found, aborting"
        exit 11
    fi
else
    echo "Could not determine target directory, aborting"
    exit 12
fi

# Require one argument (the .po file of the manpage)
if [ ! -f "$manname" ]; then
	echo "The file '$manname' could not be found."
	exit 13
fi

# path to the templates
templatedir="../../templates"

# Find the pot file by adding the letter 't'
potfile="$templatedir/$manname""t"
if [ ! -f "$potfile" ]; then
	echo "The potfile '$potfile' could not be found." >&2
	exit 14
fi

# Create backup, to be able later to run diff on the files.
backup=$(mktemp)
cp "$manname" "$backup"

# Generate compendium
compendium=$(mktemp)
../generate-compendium.sh "$manname" "$compendium" "$lcode"

# Update .po file from .pot file
tmppo=$(mktemp)
msgmerge --previous --compendium "$compendium" "$manname" "$potfile" > "$tmppo"

# Remove obsolete strings
msgattrib --no-obsolete "$tmppo" > "$manname"

# Translate dates, if possible
./translate-dates.pl < "$manname" > "$tmppo"

# Prefer the translations from the compendium
msgmerge --compendium "$compendium" --no-fuzzy-matching /dev/null "$tmppo" > "$manname"

# Determine if the only change is the "POT-Creation-Date:" header
# If so, copy back the backup to revert that change
sed -f ../remove-potcdate.sed < "$backup" > "$tmppo"
sed -f ../remove-potcdate.sed < "$manname" > "$compendium"
if cmp "$tmppo" "$compendium" >/dev/null 2>&1; then \
	mv "$backup" "$manname"; \
fi

# Cleanup
rm -f "$tmppo" "$compendium" "$backup"
