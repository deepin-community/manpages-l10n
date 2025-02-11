#!/bin/sh
#
# Copyright © 2024 Kirill Rekhov <krekhov.dev@gmail.com>
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
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#
# This script updates the "PO-Revision-Date" field in all modified .po files.
# It retrieves the list of changed .po files using 'git status -s' and updates
# the date to the current date and time. Use it before sending your changes to
# ensure all .po files have updated revision dates.

files=$(git status -s | awk '{print $2}' | grep '\.po$')

if [ -z "$files" ]; then
	echo "There are no modified files to update."
	echo "The output of 'git status -s' is empty."
	exit 0
fi

for f in $files; do
	sed -i "s/PO-Revision-Date: .*/PO-Revision-Date: $(date +'%Y-%m-%d %H:%M%z')\\\\n\"/" "$f"
done
