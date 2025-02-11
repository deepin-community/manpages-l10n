#!/bin/bash
#
# Copyright © 2018-2019 Dr. Tobias Quathamer <toddy@debian.org>
#             2021,2022,2024 Dr. Helge Kreutzmann <debian@helgefjell.de>
#             2024 Aleksandr Felda <isk8da@gmail.com>
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
  echo "Usage: ./`basename $0` man_pages_name language_code translators_list"
  echo ""
  echo This script generates *.po manpage files from the original files in
  echo English. The files will be saved in the appropriate subdirectories of
  echo the selected language. Example: "ru/man1".
  echo ""
  echo "At the top of the file, the translators are marked up. By default "
  echo "this list is empty (since this is a fresh file with only translations "
  echo "from the compendium)."
  echo ""
  echo "If you add content before committing the file, you can specify an"
  echo "optional 3rd parameter, which is a file with a translation header"
  echo "already included. Be sure that the string(s) in that file have"
  echo "the right format."
  echo ""
  echo If the file containing the list of authors of the translation is not
  echo defined or this file is empty, then a standard file header will be
  echo created
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

source ../l10n_set

# Require one argument (the name of the manpage)
if [ -z "$1" ]; then
	echo "Please specify the name of the manpage, e.g. 'arch.1'." >&2
	exit 1
fi

# Normalize to the basename of the manpage
manpage=$(basename ${1%%.po})
mandir="man"$(echo $manpage | sed -e 's/[a-z]*$//' | sed -e "s/.*\.\([0-9]\).\?$/\1/")
pofile=$mandir/$manpage.po
potfile=../../templates/$mandir/$manpage.pot

# Create the template
cd ../../templates
./generate-one-template.sh $manpage
returncode=$(echo $?)

if [ $returncode != 0 ]; then
    exit 16
fi

# Update common templates
./create-common-templates.sh
cd ../po/$lcode

# Update common translations
../update-common.sh

# Ensure that there is a .po file
if [ ! -f $mandir/$manpage.po ]; then
	# Create a new .po file
	msginit --no-translator --locale="$lcode" -i "$potfile" -o "$pofile"

	# Get the head of the file until first msgid line
	# and generate the standard header
	tmppo1=$(mktemp)
	tmppo2=$(mktemp)
	sed -e "1,/^msgid/d" "$pofile" > "$tmppo1"
	echo "# $langname translation of manpages" > "$pofile"
	echo "# This file is distributed under the same license as the manpages-l10n package." >> "$pofile"
	echo "# Copyright © of this file:" >> "$pofile"
# The variable in which contains the prepared translation header
	file=$3
	if [[ -e ${file} ]] # If the file exists.
	then
	rows=`cat -u $file` # The variable in which the contents of the file will be saved.
		if [[ -n $rows ]] # If the file is not empty.
		then
			echo "$rows" >> "$pofile"
		else
			echo ""
		fi
	else
		echo ""
	fi
	echo "msgid \"\"" >> "$pofile"
	cat "$pofile" "$tmppo1" > "$tmppo2"
	mv "$tmppo2" "$pofile"
	rm -f "$tmppo1" "$tmppo2"

	# Adjust two header lines
	#sed -i -e "s/^\"Language-Team: none\\\n\"$/\"Language-Team: German <debian-l10n-german@lists.debian.org>\\\n\"/" "$pofile"
	sed -i -e "s/^\"Language-Team: none\\\n\"$/\"Language-Team: $langmail\\\n\"/" "$pofile"
	sed -i -e "s/^\"Project-Id-Version: manpages-de .*$/\"Project-Id-Version: manpages-l10n\\\n\"/" "$pofile"
fi

# Finally, populate the translation from the compendium.
../update-po.sh "$pofile" "$lcode"
