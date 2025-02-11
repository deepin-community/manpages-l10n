#!/bin/sh
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
#             2021 Dr. Helge Kreutzmann <debian@helgefjell.de>
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
rm -rf man* links.txt untranslated.txt

mkdir man1 man2 man2type man3 man3const man3head man3type man4 man5 man6 man7 man8

cpio_archive=$(mktemp)
mirror="https://ftp.fau.de/fedora/linux/development/41/Everything/x86_64/os/Packages/"

# Process packages
while read package; do
	mkdir -p tmp/downloads
	page=$(mktemp)
	group=$(echo $package| awk '{print(tolower(substr($1,1,1)))}')

    # Download HTML page
	wget --quiet -O "$page" "$mirror/$group/"

  # Discover the correct link in HTML page.
  # Sometimes, there are multiple versions of a package
  # in the download page, e.g.
  #   man-pages-4.16-2.mga7.noarch.rpm
  #   man-pages-5.01-1.mga8.noarch.rpm
  # Because those links are sorted alphabetically, the newest
  # version should come last. Therefore, convert spaces
  # the the grep'ed string to newlines and use only the
  # last line.
	echo -n "Downloading and updating package '$package' from group '$group'"
  url=$(grep "\"$package-[0-9][^\"]*\.rpm[^.]" "$page" |
        sed -e "s,.*<a href=\"\($package-[^\"]*\).*,\1," |
        perl -pe "s/ /\n/g" |
        tail -n1)
  url="$mirror/$group/$url"
  wget --quiet --directory-prefix=tmp/downloads "$url"

	echo -n " with url '$url'"

	# Update the manpages from the package
	latest_rpm=$(ls tmp/downloads/$package-*.rpm)
	if [ -z $latest_rpm ]; then
		echo "Warning: Could not find .rpm for package '$package'"
	else
		rpm2cpio $latest_rpm > $cpio_archive
		cd tmp && bsdcpio -i --make-directories < "$cpio_archive"
		cd ..
		./move-manpages.sh "$package"
	fi
	# Finally, remove the tarball, so that the regexp
	# matching does not match the wrong tarball.
	# See pacman and pacman-contrib for an example.
	rm -rf tmp $page
done < packages.txt
rm "$cpio_archive"

	# Special case for grub2-mknetdir.1. This file contains an unprintable
	# character (detected as "\v") which po4a can't handle.
	# See https://savannah.gnu.org/bugs/?58936
	if [ -f ./man1/grub2-mknetdir.1 ]; then
	  sed -i -e "s|Prepares|Prepares|" ./man1/grub2-mknetdir.1
	fi
	
	# Remove some files due to licensing issues
	rm -f ./man1/hpcdtoppm.1
	rm -f ./man1/zipgrep.1
