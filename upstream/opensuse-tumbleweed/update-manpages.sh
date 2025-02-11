#!/bin/sh
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
#           © 2024 Dr. Helge Kreutzmann <debian@helgefjell.de>
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

mkdir man1 man2 man2type man3 man3const man3head man3type man4 man5 man6 man7 man7mp man8

# Download HTML page for x86_64
page=$(mktemp)
cpio_archive=$(mktemp)
wget --quiet -O "$page" "https://ftp.gwdg.de/pub/opensuse/tumbleweed/repo/oss/x86_64/"

# Process packages
while read package; do
	mkdir tmp

  # Discover the correct link in HTML page.
  # Sometimes, there are multiple versions of a package
  # in the download page, e.g.
  #   man-pages-4.16-2.mga7.noarch.rpm
  #   man-pages-5.01-1.mga8.noarch.rpm
  # Because those links are sorted alphabetically, the newest
  # version should come last. Therefore, convert spaces
  # the the grep'ed string to newlines and use only the
  # last line.
	echo -n "Downloading and updating package '$package' "
  url=$(grep "\"$package-[0-9][^\"]*\.rpm[^.]" "$page" |
        grep -v "\-32bit\-" |
        sed -e "s,.*<a href=\"\($package-[^\"]*\).*,\1," |
        perl -pe "s/ /\n/g" |
        tail -n1)

  url="https://ftp.gwdg.de/pub/opensuse/tumbleweed/repo/oss/x86_64/$url"
  wget --quiet --directory-prefix=tmp/downloads "$url"

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
	rm -rf tmp
done < packages.bin.txt
rm "$page" "$cpio_archive"

# Download HTML page for noarch
page=$(mktemp)
cpio_archive=$(mktemp)
wget --quiet -O "$page" "https://ftp.gwdg.de/pub/opensuse/tumbleweed/repo/oss/noarch/"

# Process packages
while read package; do
	mkdir tmp

  # Discover the correct link in HTML page.
  # Sometimes, there are multiple versions of a package
  # in the download page, e.g.
  #   man-pages-4.16-2.mga7.noarch.rpm
  #   man-pages-5.01-1.mga8.noarch.rpm
  # Because those links are sorted alphabetically, the newest
  # version should come last. Therefore, convert spaces
  # the the grep'ed string to newlines and use only the
  # last line.
	echo -n "Downloading and updating package '$package' "
  url=$(grep "\"$package-[0-9][^\"]*\.rpm[^.]" "$page" |
        sed -e "s,.*<a href=\"\($package-[^\"]*\).*,\1," |
        perl -pe "s/ /\n/g" |
        tail -n1)

  url="https://ftp.gwdg.de/pub/opensuse/tumbleweed/repo/oss/noarch/$url"
  wget --quiet --directory-prefix=tmp/downloads "$url"

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
	rm -rf tmp
done < packages.noarch.txt
rm "$page" "$cpio_archive"

	# Special case for grub2-mknetdir.1. This file contains an unprintable
	# character (detected as "\v") which po4a can't handle.
	# See https://savannah.gnu.org/bugs/?58936
	if [ -f ./man1/grub2-mknetdir.1 ]; then
	  sed -i -e "s|Prepares|Prepares|" ./man1/grub2-mknetdir.1
	fi
	
	# Remove some files due to licensing issues
	rm -f ./man1/hpcdtoppm.1
	rm -f ./man1/zipgrep.1
