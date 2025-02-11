#!/bin/sh
#
# Copyright © 2010-2019 Dr. Tobias Quathamer <toddy@debian.org>
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

# Start with clean directories and no leftover links.txt
rm -rf man* links.txt

mkdir man1 man2 man3 man4 man5 man6 man7 man8

# Process packages
while read package; do
	mkdir tmp

	# Download HTML page and discover the correct link
	echo "Downloading and updating package '$package'"
	url=$(wget --quiet -O - "http://packages.debian.org/sid/amd64/$package/download" |
	grep "http://ftp.de.debian.org/debian/pool/" |
	sed -e "s,.*\(http://ftp.de.debian.org/debian/pool/[^\"]*\).*,\1,")
	wget --quiet --directory-prefix=tmp/downloads "$url"


	# Update the manpages from the package
	latest_deb=$(ls tmp/downloads/$package\_*.deb)
	if [ -z $latest_deb ]; then
		echo "Warning: Could not find .deb for package '$package'"
	else
		data_tar=$(ar t $latest_deb | grep data.tar)
		ar x $latest_deb $data_tar
		tar xaf $data_tar --directory=tmp 2>/dev/null
		./move-manpages.sh
	fi
	# Finally, remove the tarball, so that the regexp
	# matching does not match the wrong tarball.
	# See pacman and pacman-contrib for an example.
	rm -rf tmp data.tar.*
done < packages.txt

if [ -f links.txt ]; then
	LC_ALL=C sort links.txt > tmp.links
	mv tmp.links links.txt
fi

	# Special case for grub-mknetdir.1. This file contains an unprintable
	# character (detected as "\v") which po4a can't handle.
	# See https://savannah.gnu.org/bugs/?58936
	if [ -f ./man1/grub-mknetdir.1 ]; then
	  sed -i -e "s|Prepares|Prepares|" ./man1/grub-mknetdir.1
	fi
	
	# Remove some files due to licensing issues
	rm -f ./man1/hpcdtoppm.1
	rm -f ./man1/zipgrep.1
