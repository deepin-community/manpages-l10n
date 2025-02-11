#!/bin/sh
#
# Copyright © 2021 Dr. Helge Kreutzmann <debian@helgefjell.de>
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

MT_LANGLIST=$(find . -maxdepth 1 -type d | grep -v scripts | grep -v "^\.$" | sed 's/\.\///' | sort)

echo -n "Processing: "

for mt_lang in $MT_LANGLIST; do
    echo -n "$mt_lang "
    mt_list=$(mktemp)
    for i in $(find ../templates/man* -name "*.pot"); do
	cu_name=$(basename -s ".pot" $i)
	cu_fullname=$cu_name".po"
	cu_mandir=$(basename $(dirname $i))
	cu_section=$(echo $cu_mandir|cut -c4 )
        cu_result=$(find $mt_lang/ -name $cu_fullname -ls)
	if [ -z "$cu_result" ]; then
# Placeholder for more to come …
# NOTE: Sometimes a man page appears in multiple upstreams - choose one randomly
	    mt_grep=$(grep -l "^$cu_fullname" ../upstreambug/CONFIG/CONFIG.*|head -n1)
	    if [ -z $mt_grep ]; then
		# The PO file is not registered (yet)
		mt_packetname="unassigned"
	    else
		mt_packetname=$(basename $mt_grep)
	    fi
	    echo $mt_packetname $i $cu_name >> $mt_list
	fi
    done
    sort $mt_list | sed 's/^CONFIG.//'|sed s'/\.\.\/templates\///' | sed 's/\// /' > $mt_lang/untranslated.txt
    rm -f $mt_list
done

echo ""
