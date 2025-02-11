#!/bin/sh
#
# Copyright © 2018-2019 Dr. Tobias Quathamer <toddy@debian.org>
#           © 2021 Dr. Helge Kreutzmann <debian@helgefjell.de>
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

mkdir man0p man1 man1p man2 man2type man3 man3const man3head man3type man3p man4 man5 man6 man7 man8

# Process packages
while read line; do
	mkdir tmp

	repo=$(echo "$line" | cut -d" " -f1)
	package=$(echo "$line" | cut -d" " -f2)

	# Download HTML page and discover the correct link
	echo -n "Downloading and updating package '$package' from '$repo' format "
	url=$(wget --quiet -O - "https://mirror.netcologne.de/archlinux/$repo/os/x86_64/" |
        grep -E "\"$package-[0-9][^\"]*\.pkg\.tar\.(zst|xz)[^.]" |
	sed -e "s,.*<a href=\"\($package-[^\"]*\).*,\1,")
	url="https://mirror.netcologne.de/archlinux/$repo/os/x86_64/$url"
	wget --quiet --directory-prefix=tmp/downloads "$url"

	# Update the manpages from the package
	latest_pkg_zst=$(ls tmp/downloads/$package-*.pkg.tar.zst 2>/dev/null)
	latest_pkg_xz=$(ls tmp/downloads/$package-*.pkg.tar.xz 2>/dev/null)
	latest=$latest_pkg_zst.$latest_pkg_xz
	if [ -z $latest ]; then
	    echo "Warning: Could not find .pkg.tar.(zst|xz) for package '$package'"
	elif [ -z $latest_pkg_xz ]; then
		echo "zst"
		#tar xaf $latest_pkg_zst --directory=tmp 2>/dev/null
		tar xaf $latest_pkg_zst --directory=tmp
		./move-manpages.sh
	else
		echo "xz"
		#tar xJf $latest_pkg_xz --directory=tmp 2>/dev/null
		tar xJf $latest_pkg_xz --directory=tmp
		./move-manpages.sh
	fi
	# Finally, remove the tarball, so that the regexp
	# matching does not match the wrong tarball.
	# See pacman and pacman-contrib for an example.
	rm -rf tmp
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
