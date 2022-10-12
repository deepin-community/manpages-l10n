#!/bin/sh
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
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

# Require one argument (the name of the manpage)
if [ -z "$1" ]; then
	echo "Please specify the name of the manpage, e.g. 'arch.1'." >&2
	exit 1
fi

# Normalize to the basename of the manpage
manpage=$(basename $1)
potfile=$(find man* -type f -name "$manpage.pot")

# If the file exists, create a backup.
if [ -f "$potfile" ]; then
  cp "$potfile" backup.pot
fi

tmp1=$(mktemp)
tmp2=$(mktemp)

# Get the current time to ensure that all potfiles
# have the exact same date and time of creation in the header.
# datetime=$(date --iso-8601=minutes | sed -e "s/T/ /")
datetime=$(date "+%Y-%m-%d %H:%M%z")

# Find all upstream manpages with a matching name
potfiles=""
upstream_manpages=$(find ../upstream/*/ -type f -name "$manpage" | LC_ALL=C sort)
if [ -z "$upstream_manpages" ]; then
  echo "The manpage '$manpage' could not be found." >&2
  exit 1
fi

# Create pot file
echo "Generating pot file for manpage '$manpage'"

for upstream_manpage in $upstream_manpages; do
  # Create a template for each distribution
  distribution=$(echo $upstream_manpage | cut -d/ -f3)

  potfile=$(mktemp --tmpdir "$distribution.$manpage.XXX.pot")
  potfiles="$potfiles $potfile"
  ./generate-template.sh $distribution $manpage > $potfile

  # Ensure the same timestamp
  if [ -f "$potfile" ]; then
    sed -i -e "s/^\"POT-Creation-Date: .*$/\"POT-Creation-Date: $datetime\\\\n\"/" "$potfile"
  fi
done
mandir=$(basename $(dirname $upstream_manpage))

# Merge all pot files into one
msgcat -o "$mandir/$manpage.pot" $potfiles

# Remove random characters from multiple file information
# and reformat the comment into something more readable, e.g.:
# "#. #-#-#-#-#  archlinux.fclose.3.0bX.pot (PACKAGE VERSION)  #-#-#-#-#"
sed -i -e "s/^#\(\.\?\) #-#-#-#-# \([^.]*\)\.\(.\+\)\.[A-Za-z0-9]\{3\}\.pot/#\1 #-#-#-#-# \2: \3.pot/" "$mandir/$manpage.pot"

# Determine if the only change is the "POT-Creation-Date:" header
# If so, copy back the backup to revert that change
if [ -f "$mandir/$manpage.pot" -a -f "backup.pot" ]; then
  sed -f remove-potcdate.sed < "backup.pot" > "$tmp1"
  sed -f remove-potcdate.sed < "$mandir/$manpage.pot" > "$tmp2"
  if cmp "$tmp1" "$tmp2" >/dev/null 2>&1; then
    mv "backup.pot" "$mandir/$manpage.pot"
  fi
fi

rm -f $tmp1 $tmp2 backup.pot $potfiles
