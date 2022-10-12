#!/bin/sh
#
# Copyright © 2018-2019 Dr. Tobias Quathamer <toddy@debian.org>
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

# Require one argument (the name of the manpage)
if [ -z "$1" ]; then
	echo "Please specify the name of the manpage, e.g. 'arch.1'." >&2
	exit 1
fi

# Normalize to the basename of the manpage
manpage=$(basename $1)
mandir="man"$(echo $manpage | sed -e "s/.*\.\([0-9]\).\?$/\1/")
pofile=$mandir/$manpage.po
potfile=../../templates/$mandir/$manpage.pot

# Create the template
cd ../../templates
./generate-one-template.sh $manpage
# Update common templates
./create-common-templates.sh
cd ../po/fa

# Update common translations
./update-common.sh

# Ensure that there is a .po file
if [ ! -f $mandir/$manpage.po ]; then
	# Create a new .po file
	msginit --no-translator --locale="fa" -i "$potfile" -o "$pofile"

	# Get the head of the file until first msgid line
	# and generate the standard header
	tmppo1=$(mktemp)
	tmppo2=$(mktemp)
	sed -e "1,/^msgid/d" "$pofile" > "$tmppo1"
	echo "# Persian translation of manpages" > "$pofile"
	echo "# This file is distributed under the same license as the manpages-l10n package." >> "$pofile"
	echo "# Copyright © of this file:" >> "$pofile"
	echo "msgid \"\"" >> "$pofile"
	cat "$pofile" "$tmppo1" > "$tmppo2"
	mv "$tmppo2" "$pofile"
	rm -f "$tmppo1" "$tmppo2"

	# Adjust two header lines
	sed -i -e "s/^\"Language-Team: none\\\n\"$/\"Language-Team: Persian <mksafavi@gmail.com>\\\n\"/" "$pofile"
	sed -i -e "s/^\"Project-Id-Version: manpages-de .*$/\"Project-Id-Version: manpages-l10n\\\n\"/" "$pofile"
fi

# Finally, populate the translation from the compendium.
./update-po.sh "$pofile"
