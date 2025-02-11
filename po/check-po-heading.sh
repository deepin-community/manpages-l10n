#!/bin/bash
#
# Copyright @ 2024 Rafael Fontenelle <rafaelff@gnome.org>
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



if [ $# -lt 1 ]; then
  echo "Expected one or more PO file but none was found, aborting;" > /dev/stderr
  exit 1
fi

# Validate each entry for existing PO file
pofiles=""
for f in $*; do
  if [ -f $f ] && [[ $f == *.po ]]; then
    pofiles+="$f "
  else
    echo "$0: $f: Ignoring invalid input file;" > /dev/stderr
  fi
done

# Clean up files
rm -f step-*.txt

for po in $pofiles; do
  language_dir=$(dirname $(dirname $po))
  conf=$language_dir/lang.config

  # If failed to load configs, stop processing PO file
  if ! source $conf; then
    echo "$0: $po: Failed to load language's configuration from ${conf}." > /dev/stderr
    continue
  fi

  email_pattern="[A-Za-z0-9\._%+\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}"

  # Extracts from the given PO file(s) everything before headers msgid, then
  # exclude:
  #   1) expected language name line,
  #   2) expected license line,
  #   3) expected copyright line,
  #   4) blank line,
  #   5) hash sign #,
  #   6) fuzzy flag for the header field msgid
  # and store for next stage
  sed -n '/^msgid ""$/q;p' $po | \
  grep -av "# $langname translation of manpages" | \
  grep -av "# This file is distributed under the same license as the manpages-l10n package." | \
  grep -av "# Copyright © of this file:" | \
  grep -av "^$" | \
  grep -av "^# *$" | \
  grep -av "#, fuzzy" \
  >> step-1.txt
done

# Deduplicate entries for same years
cat step-1.txt | sort -u > step-2.txt

# List FIXME present in the files' heading, possibly needing attention
grep '^# FIXME:' step-2.txt > step-fixme.txt

# Should be only credits from now on
sed -i '\|^# FIXME:|d' step-2.txt

# List credits not matching "name <email>" (email without name, name without email)
grep -av "# .* <" step-2.txt > step-noemail.txt

# List credits without year (name only, name with email)
grep -avP '\d{4}' step-2.txt > step-noyear.txt

# List credits not ending line with full stop character
grep -av '\.$' step-2.txt > step-nofullstop.txt

# Needed to loop through the list of output file
# because the 'data' of multiple files is too long
for outfile in step-noemail.txt step-noyear.txt step-nofullstop.txt; do
  ${IFS+"false"} && unset oldifs || oldifs="$IFS"
  IFS=''
  while read data; do
      sed -i "\|${data}|d" step-2.txt
  done < $outfile
  ${oldifs+"false"} && unset IFS || IFS="$oldifs"
done

# List credits with what should be the expected format, but with a typo
grep -avP '^# [A-Za-z].* <.*>, \d{4}(\s*(,|-)\s*\d{4})*\.' step-2.txt > step-malformated.txt
sed -i '/^# [A-Za-z].* <.*>, \d{4}(\s*(,|-)\s*\d{4})*\./d' step-2.txt
