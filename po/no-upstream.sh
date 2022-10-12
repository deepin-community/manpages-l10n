#!/bin/sh
#
# Copyright © 2012 Dr. Tobias Quathamer <toddy@debian.org>
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

# Check if there is a .po file without the corresponding
# upstream manpage, e.g. when a package has been removed.

# Determine directory names from upstream directory.
distributions=$(find ../upstream -maxdepth 1 -type d | cut -d/ -f3- | LC_ALL=C sort)

# path to the upstream manpages
upstreamdir="../upstream"

translations=$(find man* -name "*.po" | LC_ALL=C sort)
for translation in $translations; do
	found_upstream="no"
	# Find the manpage by removing the .po extension
	manpage=$(basename $translation .po)
	mandir=$(dirname $translation)
	for distribution in $distributions; do
		upstream_manpage="$upstreamdir/$distribution/$mandir/$manpage"
		if [ -f "$upstream_manpage" ]; then
			found_upstream="yes"
			break
		fi
	done
	if [ $found_upstream = "no" ]; then
		echo "No upstream found for '$translation'"
	fi
done
