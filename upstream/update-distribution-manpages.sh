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

# Determine directory names.
# The path "../upstream" points here. This way, it's possible
# to filter out the current directory named ".".
directories=$(find ../upstream -maxdepth 1 -type d | cut -d/ -f3- | LC_ALL=C sort)

for directory in $directories; do
	echo "Processing directory '$directory'"

	# Call the script inside the directory for handling
	# the needed instructions for the given distribution.
	cd $directory
	./update-packages.py
	cd ..

	# Copy all manpages and handle the links
	./copy-manpages.py "$directory"

	# Finally, collect all links files and merge them together
	links=$(mktemp)
	for i in "$directory/downloads/*/links.txt"; do
		cat $i >> links
	done
	LC_ALL=C sort links > "$directory/links.txt"
	rm links

	# Special case for init.8, because the manpage contains
	# a syntax error, so that the manpage cannot be translated
	# with po4a. The bug has been reported upstream.
	# https://savannah.nongnu.org/bugs/?55678
	if [ -f $directory/man8/init.8 ]; then
	  sed -i -e "s|\\\fB/run/initctl\\\f\\\P, closed. This may be used to make sure init is not|\\\fB/run/initctl\\\fP, closed. This may be used to make sure init is not|" $directory/man8/init.8
	fi

	# Another special case for man.7, which uses \c and
	# is therefore not translatable by po4a.
	# Reformat the part to display equally in the man browser.
	# Line 272 and 273:
	# .B \&.UE \c
	# .RI [ trailer ]
	# Reformat to: \fB\&.UE\fP [ \fItrailer\fP ]
	if [ -f $directory/man7/man.7 ]; then
	  sed -i -e "/^\.B \\\&\.UE \\\c/{N; s/.*/\\\fB\\\\\&.UE\\\fP [ \\\fItrailer\\\fP ]/}" $directory/man7/man.7
	fi

	# Special case for grub-mknetdir.1. This file contains an unprintable
	# character (detected as "\v") which po4a can't handle.
	# See https://savannah.gnu.org/bugs/?58936
	if [ -f $directory/man1/grub-mknetdir.1 ]; then
	  sed -i -e "s|Prepares|Prepares|" $directory/man1/grub-mknetdir.1
	fi

	# The same for grub2-mknetdir.1. This file contains an unprintable
	# character (detected as "\v") which po4a can't handle.
	# See https://savannah.gnu.org/bugs/?58936
	if [ -f $directory/man1/grub2-mknetdir.1 ]; then
	  sed -i -e "s|Prepares|Prepares|" $directory/man1/grub2-mknetdir.1
	fi

done
