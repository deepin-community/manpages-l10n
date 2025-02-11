#!/bin/sh
#
# Copyright © 2010-2017 Dr. Tobias Quathamer <toddy@debian.org>
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

translation="$1"
addendum="$2"


ismdoc=$(grep -l $translation ../mdoc.cache)

# Use the header up until the first msgid
# and remove the comment character
translators=$(sed '/msgid/q;s/^#\s\+//' "$translation" |
# Throw away the common (non translator) lines
grep -a -v "Indonesian translation of manpages" |
grep -a -v "This file is distributed under the same license as the manpages-l10n package." |
grep -a -v "Copyright © of this file:" |
grep -a -v "FIXME:" |
grep -a -v "msgid" |
grep -a -v '^#[[:space:]]*$' |
# Split lines to extract the name (and e-mail address)
cut -f1 -d",")
# Determine number of translators
number_translators=$(echo "$translators" | wc -l)

# Output of common header
echo "PO4A-HEADER:mode=after;position=^\.(TH|Dt);beginboundary=FakePo4aBoundary" > "$addendum"

# Special case for manpages which use mdoc syntax
if [ $ismdoc ]; then
    # MDOC File
    echo ".Pp" >> "$addendum"
    echo ".Sh TERJEMAHAN" >> "$addendum"
else
    # Groff file
    echo ".PP" >> "$addendum"
    echo ".SH TERJEMAHAN" >> "$addendum"
fi
echo "Terjemahan bahasa Indonesia dari halaman manual ini dibuat oleh" >> "$addendum"

# Warn if the translators string is empty
if [ -z "$translators" ]; then
	echo "Warning: No translators found for '$translation'." >&2
fi
# Apply correct formatting, depending on the number of translators
if [ $number_translators -eq 1 ]; then
	echo "$translators" >> "$addendum"
fi
if [ $number_translators -eq 2 ]; then
	echo "$translators" | head -n1 >> "$addendum"
	echo "dan" >> "$addendum"
	echo "$translators" | tail -n1 >> "$addendum"
fi
if [ $number_translators -ge 3 ]; then
	echo "$translators" | head -n$(($number_translators - 2)) | perl -pe "s/$/,/" >> "$addendum"
	echo "$translators" | tail -n2 | head -n1 >> "$addendum"
	echo "dan" >> "$addendum"
	echo "$translators" | tail -n1 >> "$addendum"
fi

# Output of common ending
echo "." >> "$addendum"

# Special case for manpages which use mdoc syntax
if [ $ismdoc ]; then
    # MDOC File
    cat license-mdoc.add >> "$addendum"
else
    # Groff file
    cat license-groff.add >> "$addendum"
fi
