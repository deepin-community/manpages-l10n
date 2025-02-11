#!/bin/sh
#
# Copyright © 2017-2019 Dr. Tobias Quathamer <toddy@debian.org>
#             2021,2024 Dr. Helge Kreutzmann <debian@helgefjell.de>
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
if [ "$1" == "-h" ]; then
  echo "Usage: ./`basename $0` distribution language_code"
  echo ""
  echo This script generates translated man pages from the existing *.po files.
  echo The files will be stored in the subdirectory of the chosen language and
  echo there in a directory with the distribution name.
  echo Example: de/debian-unstable/man*
  echo ""
  echo It is mandatory to submit the distribution name and the language code
  echo as parameters.
  echo ""
  echo The language code may be omitted if called from the language directory, 
  echo e.g. po/es
  exit 0
fi

if [ -d man1 ]; then
    lcode=$(basename $(pwd))
elif [ a"$2" != a ]; then
    if [ -d $2 ]; then
        cd $2
        lcode=$2
    else
        echo "Language $2 could not be found, aborting"
        exit 11
    fi
else
    echo "Could not determine target directory, aborting"
    exit 12
fi

# Require distribution name
if [ -z "$1" ]; then
	echo "Please specify the distribution." >&2
	exit 17
fi
distribution=$1

cfix=$(./cfixcheck)

echo "Processing distribution '$distribution'"
manpages=$(find "../../upstream/$distribution"/man* -type f | cut -d/ -f5- | LC_ALL=C sort)
for manpage in $manpages; do
	if [ -f "$manpage.po" ]; then
		../generate-manpage.sh $distribution "$manpage" $lcode $cfix
	fi
done
