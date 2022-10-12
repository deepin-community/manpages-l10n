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
if [ ! -d "upstream/$distribution" ]; then
	echo "The distribution '$distribution' does not exist."
	echo "Please start with the first part of this script."
	exit
fi

# Make sure that the update-manpages.sh script has been run
# Start with clean directories and no leftover links.txt
cd "upstream/$distribution"
rm -rf man* links.txt
./update-manpages.sh
# Sort the file links.txt
if [ -f links.txt ]; then
	LC_ALL=C sort links.txt > tmp.links
	mv tmp.links links.txt
fi
git add .
git commit -m "Add manpages for '$distribution'"
cd ../..

# Create the templates
cd "templates"
./update-all-templates.sh
git add man*
git commit -m "Add templates for new distribution '$distribution'"
./create-common-templates.sh
git add common/*
git commit -m "Add common templates for new distribution '$distribution'"
cd ..

# Update po files
cd "po"
./update-translations.sh
git add man*
git commit -m "Update .po files for new distribution '$distribution'"
./update-common.sh
git add common/*
git commit -m "Update common .po files for new distribution '$distribution'"
cd ..
