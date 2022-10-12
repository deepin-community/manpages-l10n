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

# Require distribution name
if [ -z "$1" ]; then
	echo "Please specify the distribution." >&2
	exit 1
fi
distribution=$1

echo "Processing distribution '$distribution'"
manpages=$(find "../../upstream/$distribution"/man* -type f | cut -d/ -f5- | LC_ALL=C sort)
for manpage in $manpages; do
	if [ -f "$manpage.po" ]; then
		./generate-manpage.sh $distribution "$manpage"
	fi
done
