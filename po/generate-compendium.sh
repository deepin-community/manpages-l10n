#!/bin/sh
#
# Copyright © 2017-2019 Dr. Tobias Quathamer <toddy@debian.org>
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

# Require two arguments (.po file name and compendium file name)
if [ ! -f "$1" ]; then
	echo "The file '$1' could not be found."
	exit 13
fi
if [ -z "$2" ]; then
	echo "Specify the compendium filename."
	exit 2
fi

# Extract header entry for compendium (first line until first blank line)
header=$(mktemp)
sed -n "1,/^$/p" "$1" > "$header"

# Join all files into one compendium
giant=$(mktemp)
msgcat common/*po > "$giant"

# Remove untranslated and fuzzy entries
tmpcompendium=$(mktemp)
msgattrib --translated --no-fuzzy "$giant" > "$tmpcompendium"

# Create a custom compendium with the header from the translation
msgcat --use-first "$header" "$tmpcompendium" > "$2"
rm -f "$header" "$giant" "$tmpcompendium"
