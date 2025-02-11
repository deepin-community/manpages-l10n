#!/bin/bash
#
# Copyright © 2010-2017 Dr. Tobias Quathamer <toddy@debian.org>
#             2021 Dr. Helge Kreutzmann <debian@helgefjell.de>
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
  echo "Usage: ./`basename $0` language_code"
  echo This script updates all *.po files of a certain language. It uses both
  echo the template files in templates/man*/ and the compendium in po/common/*.
  echo ""
  echo It is mandatory to submit the language code as parameter.
  echo ""
  echo The language code may be omitted if called from the language directory,
  echo e.g. po/sv
  exit 0
fi

if [ -d man1 ]; then
    lcode=$(basename $(pwd))
elif [ a"$1" != a ]; then
    if [ -d $1 ]; then
        cd $1
        lcode=$1
    else
        echo "Language $1 could not be found, aborting"
        exit 11
    fi
else
    echo "Could not determine target directory, aborting"
    exit 12
fi

translations=$(find man* -name "*.po" | LC_ALL=C sort)
for translation in $translations; do
	echo $(basename "$translation")
	../update-po.sh "$translation"
done
