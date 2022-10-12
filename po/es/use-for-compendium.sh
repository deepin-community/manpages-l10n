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

# Require one argument (filename of the proofread translation)
if [ ! -f "$1" ]; then
	echo "The file '$1' could not be found." >&2
	exit 1
fi
proofread_translation=$1

tmppo1=$(mktemp)
tmppo2=$(mktemp)

for pofile in $(find common/ -type f | LC_ALL=C sort); do
	# First, extract all translations which are
	# *not* in the proofread translation.
	# The proofread translation needs to be listed twice,
	# in order to make sure that those translations are
	# not unique and therefore added to the output.
	cp $proofread_translation $tmppo1
	msgcat --use-first --unique $pofile $proofread_translation $tmppo1 > $tmppo2
	# Second, use the template and the proofread translation
	# in order to update the now missing translations.
	potfile="../../templates/$pofile""t"
	msgmerge --previous --compendium $proofread_translation $tmppo2 $potfile > $pofile
done

rm "$tmppo1" "$tmppo2"
