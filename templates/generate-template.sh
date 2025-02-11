#!/bin/sh
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
#           © 2022,2023,2024 Dr. Helge Kreutzmann <debian@helgefjell.de>
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

# Require first argument (the name of the distribution)
if [ -z "$1" ]; then
	echo "Please specify the name of the distribution." >&2
	exit 1
fi
distribution="$1"

# Require a second argument (the name of the manpage)
if [ -z "$2" ]; then
	echo "Please specify the name of the manpage, e.g. 'arch.1'." >&2
	exit 1
fi

# Normalize to the basename of the manpage
manpage=$(basename $2)

# Find upstream manpages with a matching name
upstream_manpage=$(find "../upstream/$distribution/" -type f -name "$manpage")

if [ -z "$upstream_manpage" ]; then
	echo "A manpage named '$manpage' could not be found in distribution '$distribution'." >&2
	exit 1
fi

# Necessary, size 0 file of mktemp fails for UTF-8 characters, see Debian bug #1022216 // should be fixed in po4a 0.72
tdir=$(mktemp -d)
mkdir $tdir/$distribution

# Remove / Uncomment some macros po4a cannot handle
# #1 / #2 / # 3 Errors in some pages
# Po4a sometimes has troubles parsing \c - pattern (4) handles credentials.7.po and mkpasswd.1.po.; pattern (5) and (6) handle mkosi.1.po (OpenSuSE tumbleweed), (7) handles gawk(1)/Debian and (8) handles afmtodit.1.po [ see Debian #1036826 ], (8) and (9) handles update-openssh-known-hosts.8 (2024-11-05)
cat $upstream_manpage | sed "s/^.ft C$/^\".ft C$/" | sed "s/^.ft P$/^\".ft P$/" | sed "s/\\\\fb/\\fB/" | sed 's/\.BR \(.*\)\\c/.BR \1/' | sed 's/\.UE \\c/.UE /' | sed 's/^\\c$//'| sed 's/\.BI \(.*\)\\c/.BI \1/' | sed 's/\.RI \(.*\)\\c/.RI \1/' | sed 's/^Timo Weingärtner \\c$/Timo Weingärtner/' | sed 's/^.ME \\c./.ME/' > $tdir/$distribution/$manpage
#cat $upstream_manpage | sed "s/^.ft C$/^\".ft C$/" | sed "s/^.ft P$/^\".ft P$/" | sed "s/\\\\fb/\\fB/"  > $tdir/$distribution/$manpage
#cat $upstream_manpage | sed "s/^.ft C$/^\".ft C$/" | sed "s/^.ft P$/^\".ft P$/" | sed "s/\\\\fb/\\fB/" | sed "s/^\.BI \(\\\\.*\)\"\\\\c$/.BI \1\"/" | sed "s/^\.BR \(\\\\.*\)\"\\\\c$/.BI \1\"/" | sed "s/\\\\c$//"  > $tdir/$distribution/$manpage
#cat $upstream_manpage | sed "s/^.ft C$/^\".ft C$/" | sed "s/^.ft P$/^\".ft P$/" | sed "s/\\\\fb/\\fB/" | sed "s/^\.BI \(\\\\.*\)\"\\\\c$/.BI \1\"/" | sed "s/^\.BR \(\\\\.*\)\"\\\\c$/.BI \1\"/" | perl -p -e 's/\\c\n//'  > $tdir/$distribution/$manpage

po4a-updatepo -f man \
        --no-deprecation \
	--option groff_code=verbatim \
	--option generated \
	--option untranslated="}1,Ds,zY,zZ,Ee,ES,dT,FN,NE,NS,EX,EE,Id,rstReportMargin,INDENT,UNINDENT,UN,a.RE,\|" \
	--option unknown_macros=untranslated \
	--option inline="MR" \
	--master "$tdir/$distribution/$manpage" -M utf-8 \
	-p $tdir/tmp.pot

# Reduce the location lines from the full path and line number
cat $tdir/tmp.pot | sed -e "s,/tmp/\.private/[a-zA-Z0-9]*/tmp\.,/tmp/tmp.," | sed -e "s,^#: /tmp/tmp\.[a-zA-Z0-9]*/\([^/]\+\)/.*,#: \1," |\
	# Ensure the correct encoding is set
	sed -e "s/^\"Content-Type: text\/plain; charset=CHARSET\\\\n\"$/\"Content-Type: text\/plain; charset=UTF-8\\\\n\"/"

rm -rf $tdir
