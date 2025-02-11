#!/bin/sh
#
# Copyright © 2021,2022 Dr. Helge Kreutzmann <debian@helgefjell.de>
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

cd ../upstream
for i in $(grep -Rl "\.Sh NAME" *); do fn=$(basename $i); dn=$(basename $(dirname $i)); echo "$dn/$fn"."po" ; done | sort -u > ../po/mdoc.cache
git commit -m "scripts: Refresh mdoc.cache" ../po/mdoc.cache
