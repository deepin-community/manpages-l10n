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

# Create pot files for common msgids
echo "Generating pot files for common msgids ..."

previous_step=""
steps="100 20 10 4 3 2"

for step in $steps; do
  if [ "X$previous_step" = "X" ] ; then
    echo Generating $step - ...
  else
    echo Generating $step - $(($previous_step - 1))
  fi
  # Get all msgids with at least $step and at most $previous_step occurences
  LC_ALL=C msgcat --less-than=$previous_step --more-than=$(($step - 1)) \
    --sort-output man*/*pot > step.pot
  # Remove most comment lines, preserve "#, no-wrap" etc.
  sed -i -e "/^# /d;/^#$/d;/^#\. /d" step.pot
  # Remove first (empty) msgid with all combined headers
  sed -i -e "1,/^$/d" step.pot
  # Create a temporary header for the pot file
  header=$(mktemp)
  cat > "$header" <<END_OF_HEADER
# Common msgids
msgid ""
msgstr ""
"Project-Id-Version: manpages-l10n\n"
"POT-Creation-Date: CURRENT_DATE\n"
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
"Language-Team: LANGUAGE <LL@li.org>\n"
"Language: \n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"

END_OF_HEADER
  current_date=$(date +"%Y-%m-%d %H:%M%z")
  sed -i -e "s/CURRENT_DATE/$current_date/" "$header"
  cat "$header" step.pot > tmp2.pot

  # Create a filename with leading zeros
  min_step_file=$(printf "min-%03d-occurences.pot" $step)

  # Remove dates, as they are translated automatically
  msggrep --msgid -v -E -e "^[0-9]{4}-[0-9]{2}-[0-9]{2}$" tmp2.pot > $min_step_file

  # Remove msgids which are listed in the exclude file.
  # Ensure that excluded msgids are not unique by creating
  # a temporary copy of that file.
  cp exclude.pot tmp.pot
  msgcat --unique tmp.pot exclude.pot $min_step_file > tmp2.pot

  # Remove first (empty) msgid with all combined headers
  sed -i -e "1,/^$/d" tmp2.pot
  cat "$header" tmp2.pot > $min_step_file

  # Determine if the only change is the "POT-Creation-Date:" header
  # If so, do not copy to the common directory
  sed -f remove-potcdate.sed < common/$min_step_file > old.pot
  sed -f remove-potcdate.sed < $min_step_file > new.pot
  if cmp old.pot new.pot >/dev/null 2>&1; then
    rm $min_step_file
  else
    mv $min_step_file common/
  fi

  # Clean up
  previous_step=$step
  rm -rf tmp.pot tmp2.pot step.pot new.pot old.pot "$header"
done
