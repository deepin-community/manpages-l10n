#!/bin/sh
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
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

# Require first argument (the name of the distribution)
if [ -z "$1" ]; then
	echo "Please specify the name of the distribution." >&2
	exit 1
fi
distribution="$1"

# Require a second argument (the name of the manpage)
if [ -z "$2" ]; then
	echo "Please specify the name of the manpage, e.g. 'arch.1'." >&2
	exit 1
fi

# Normalize to the basename of the manpage
manpage=$(basename $2)

# Find upstream manpages with a matching name
upstream_manpage=$(find "../upstream/$distribution/" -type f -name "$manpage")

if [ -z "$upstream_manpage" ]; then
	echo "A manpage named '$manpage' could not be found in distribution '$distribution'." >&2
	exit 1
fi

# Determine if an encoding is specified,
# otherwise fall back to ISO-8859-1
# coding=$(grep "\-\*\- coding:" "$upstream_manpage" | sed -e "s/.*coding:\s\+\([^ ]\+\).*/\1/")
# if [ -z "$coding" ]; then
# 	coding="ISO-8859-1"
# fi

# Create pot with po4a
po4a-gettextize -f man \
	--option groff_code=verbatim \
	--option generated \
	--option untranslated="a.RE,\|" \
	--option unknown_macros=untranslated \
	--master "$upstream_manpage" -M utf-8 |\
	# Reduce the location lines from the full path and line number
	# to the name of the distribution
	sed -e "s,^#: ../upstream/\([^/]\+\)/man.*$,#: \1," |\
	# Ensure the correct encoding is set
	sed -e "s/^\"Content-Type: text\/plain; charset=CHARSET\\\\n\"$/\"Content-Type: text\/plain; charset=UTF-8\\\\n\"/"
