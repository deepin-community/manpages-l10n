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

# Find all translation mandirs
mandirs=$(find ../po/* -maxdepth 1 -type d -name "man*"  | cut -d/ -f3- | LC_ALL=C sort)

for mandir in $mandirs; do
  echo Section $mandir

  # Find all translations of the section
  translations=$(find "../po/$mandir" -type f | cut -d/ -f3- | LC_ALL=C sort)
  for translation in $translations; do
    manpage=$(basename $translation .po)
    ./generate-one-template.sh $manpage
  done
done
