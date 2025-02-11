#!/bin/sh
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
#             2022 Dr. Helge Kreutzmann <debian@helgefjell.de>
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
	echo "Please specify the name of the translation, e.g. 'de/man1/arch.1.po'." >&2
	exit 1
fi

# Determine distribution names from upstream directory.
distributions=$(find ../upstream -maxdepth 1 -type d | cut -d/ -f3- | LC_ALL=C sort)

tmppo=$(mktemp)
for distribution in $distributions; do
	# Select only msgids for the distribution
	msggrep --location="$distribution" -o $tmppo $1
	if [ -s $tmppo ]; then
		echo -n "$distribution: "
		msgfmt -cv -o /dev/null $tmppo
	fi
	rm -f $tmppo
done
