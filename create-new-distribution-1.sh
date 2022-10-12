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

# Require one argument (the name of the new distribution)
distribution=$1
if [ -z "$distribution" ]; then
	echo "Please specify the name of the new distribution."
	exit 1
fi

# Safety net
if [ -d "upstream/$distribution" ]; then
	echo "The distribution '$distribution' already exists."
	exit
fi

# Create the upstream directory
mkdir "upstream/$distribution"
cd "upstream/$distribution"
touch links.txt
touch update-manpages.sh
chmod +x update-manpages.sh
git add .
git commit -m "Add skeleton for new distribution '$distribution'"

echo "Done."
echo "Please edit this script:"
echo
echo "  upstream/$distribution/update-manpages.sh"
echo
echo "See upstream/README.md for details."
echo "When ready, run the second part of this setup script."
