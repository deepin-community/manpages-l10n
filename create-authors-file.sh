#!/bin/bash
#
# Copyright © 2012-2018 Dr. Tobias Quathamer <toddy@debian.org>
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

# List of languages sorted by language name, which must be double-quoted
language_list=(
    '"Brazilian Portuguese" pt_BR'
    '"Czech"      cs'
    '"Danish"     da'
    '"Dutch"      nl'
    '"French"     fr'
    '"German"     de'
    '"Hungarian"  hu'
    '"Italian"    it'
    '"Macedonian" mk'
    '"Persian"    fa'
    '"Polish"     pl'
    '"Romanian"   ro'
    '"Spanish"    es'
)

# Generate AUTHORS file
echo "# Authors

The following people have contributed to the translation
of Linux manpages. The list is sorted alphabetically." > AUTHORS.md

# Loop through the language list to get translators and then populate AUTHORS
for language in "${language_list[@]}"; do

    lang_name=$(echo $language | cut -d\" -f2)
    lang_code=${language##* }
    
    # Generate authors list for the given language
    echo -e "\n\n## ${lang_name}:\n" >> AUTHORS.md

    # Extract all translators from the copyright headers for the given language
    files=$(find po/${lang_code}/man? -name "*po" | sort)
    # files="$files $(find po/secondary-*/man? -name "*po" | sort)"
    for translation in $files; do
	    # Use the header up until the first msgid
	    # and remove the comment character
	    translators=$(sed '/msgid/q;s/^#\s\+//' "$translation" |
	    # Throw away the common (non translator) lines
	    grep -v "${lang_name} translation of manpages" |
	    grep -v "This file is distributed under the same license as the manpages-l10n package" |
	    grep -v "Copyright © of this file:" |
	    grep -v "FIXME:" |
	    grep -v "msgid" |
	    grep -a -v '^#[[:space:]]*$' |
	    # Split lines to extract the name (and e-mail address)
	    cut -f1 -d",")
	    # Save a list of all translators in a temporary file for copyright determination
	    echo "$translators" >> translators_${lang_code}.list
    done
    # Sort, unique, remove blank lines from file, and indent with an asterisk
    sort -u translators_${lang_code}.list | sed -e "/^$/d; s/^/* /" > tmp_${lang_code}.list
    cat tmp_${lang_code}.list >> AUTHORS.md

done

# Finally, delete all temporary lists
rm tmp*.list translators*.list
