#!/bin/sh
#
# Copyright © 2010-2019 Dr. Tobias Quathamer <toddy@debian.org>
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

# Require one argument (the .po file of the manpage)
if [ ! -f "$1" ]; then
	echo "The file '$1' could not be found."
	exit 1
fi

# path to the templates
templatedir="../../templates"

# Find the pot file by adding the letter 't'
potfile="$templatedir/$1""t"
if [ ! -f "$potfile" ]; then
	echo "The potfile '$potfile' could not be found." >&2
	exit 1
fi

# Create backup, to be able later to run diff on the files.
backup=$(mktemp)
cp "$1" "$backup"

# Generate compendium
compendium=$(mktemp)
./generate-compendium.sh "$1" "$compendium"

# Update .po file from .pot file
tmppo=$(mktemp)
msgmerge --previous --compendium "$compendium" "$1" "$potfile" > "$tmppo"

# Remove obsolete strings
msgattrib --no-obsolete "$tmppo" > "$1"

# Translate dates, if possible
./translate-dates.pl < "$1" > "$tmppo"

# Prefer the translations from the compendium
msgmerge --compendium "$compendium" --no-fuzzy-matching /dev/null "$tmppo" > "$1"

# Determine if the only change is the "POT-Creation-Date:" header
# If so, copy back the backup to revert that change
sed -f remove-potcdate.sed < "$backup" > "$tmppo"
sed -f remove-potcdate.sed < "$1" > "$compendium"
if cmp "$tmppo" "$compendium" >/dev/null 2>&1; then \
	mv "$backup" "$1"; \
fi

# Cleanup
rm -f "$tmppo" "$compendium" "$backup"
