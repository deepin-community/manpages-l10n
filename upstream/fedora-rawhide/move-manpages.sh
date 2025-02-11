#!/bin/sh
#
# Copyright © 2018 Dr. Tobias Quathamer <toddy@debian.org>
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

for mandir in tmp/usr/share/man/man*; do
  section=$(echo $mandir | cut -d/ -f5)
  # Only copy directories with files
  files=$(ls $mandir)
  if [ -n "$files" ]; then
    # Remove manpages which are links, add them to links.txt
    for manpage in $mandir/*; do
      existing=$(readlink $manpage)
      if [ -n "$existing" ]; then
        linked_section=$(basename $existing .gz | sed -e "s/.\+\.//")
        echo man$linked_section/$(basename $existing) $section/$(basename $manpage) >> links.txt
        rm $manpage
      fi
    done
    # See if there are regular files left
    files=$(ls $mandir)
    if [ -n "$files" ]; then
      mkdir tmp/$section
      # Copy remaining manpages
      cp $mandir/* tmp/$section
      gzip -d tmp/$section/*
      # Remove manpages which contain only .so links
      for manpage in tmp/$section/*; do
        existing=$(grep "^\.so" $manpage | sed -e "s/^\.so //")
        if [ -n "$existing" ]; then
          echo $existing.gz $section/$(basename $manpage).gz >> links.txt
          rm $manpage
        fi
      done
      # Copy remaining manpages
      cp tmp/$section/* $section
    fi
  fi
done
