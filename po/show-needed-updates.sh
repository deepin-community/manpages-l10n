#!/bin/bash
#
# Copyright © 2010-2019 Dr. Tobias Quathamer <toddy@debian.org>
#             2021      Dr. Helge Kreutzmann <debian@helgefjell.de>
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
  echo This script shows the translation percentages of *.po files.
  echo Note, you get only totals instead of distribution-related values.
  echo ""
  echo It is mandatory to submit the language code as parameter.
  echo ""
  echo The language code may be omitted if called from the language directory,
  echo e.g. po/fi
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

source ../l10n_set

translations=$(find man* -name "*.po" | LC_ALL=C sort)
for translation in $translations; do
	stats=$(msgfmt -cv -o /dev/null $translation 2>&1)
	fuzzy_or_untranslated=$(echo $stats | grep "[0-9]\+[^0-9]\+[0-9]\+")
	if [ -n "$fuzzy_or_untranslated" ]; then
		# Remove the last text part
		all=$(echo $stats | sed -e "s/[^0-9]\+$//")
		# Replace all remaining text parts with the plus sign
		all=$(echo $all | sed -e "s/[^0-9]\+/+/g")
		# Calculate the sum
		all=$(echo $all | bc)
		# Get the translated messages
		translated=$(echo $stats | sed -e "s/\([0-9]\+\).*/\1/")
		# Calculate the percentage
		percentage=$(echo "100 * $translated / $all" | bc)
		# Calculate needed translations for 80%
		hint=""
		if [ $percentage -lt 80 ]; then
			number=$(echo "(800 * $all / 100 + 9) / 10 - $translated" | bc)
			# $hint1 and $hint2 are localized strings from the configuration file
			hint="$hint1 $number $hint2"
		fi
		echo $translation: $percentage%$hint
		echo $stats
		echo
	fi
done
