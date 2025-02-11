#!/bin/bash
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
#             2021,2023,2024 Dr. Helge Kreutzmann <debian@helgefjell.de>
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

if [ -d man1 ]; then
    lcode=$(basename $(pwd))
elif [ a"$3" != a ]; then
    if [ -d $3 ]; then
        cd $3
        lcode=$3
    else
        echo "Language $3 could not be found, aborting"
        exit 11
    fi
else
    echo "Could not determine target directory, aborting"
    exit 12
fi

source ../l10n_set


# This is the distribution for which the manpage should be generated
distribution="$1"

# This is the filename of the localized manpage
localized="$2"

# If the filename ends with ".po", remove that part.
localized=$(echo "$localized" | sed -e "s/\.po$//")

manname=$(echo "$localized"| cut -d "/" -f 2)

# Set up the path to the original manpage
master="../../upstream/$distribution/$localized"

# Cannot generate manpage if the original could not be found
if [ ! -f "$master" ]; then
	echo "The original manpage for '$localized' could not be found in '$distribution'." >&2
	exit
fi

# Set up the filename of the translation
translation="$localized.po"

# Append the output directory
localized="$distribution/$localized"

# It might be that addenda for a certain language do not (yet) work
if [ ! -f noaddendum ]; then
    # Create the addendum for this manpage
    addendum=$(mktemp)
    ./generate-addendum.sh "$translation" "$addendum"
fi

# Create a separate .po file for this distribution,
# otherwise po4a will emit really a lot of warnings
# about an outdated translation, because the number
# of translations in the (internally generated) pot
# and po file do not match.
pofile=$(mktemp)
msggrep --location="$distribution" $translation > $pofile

# We need to filter out some unsupported macros
tdir=$(mktemp -d)
mkdir $tdir/$distribution

if [  a"$4" == "a" ]; then
# #1 / #2 / # 3 Errors in some pages
# Po4a sometimes has troubles parsing \c - pattern (4) handles credentials.7.po and mkpasswd.1.po.; pattern (5) and (6) handle mkosi.1.po (OpenSuSE tumbleweed), (7) handles gawk(1)/Debian and (8) handles afmtodit.1.po [ see Debian #1036826 ] ; (9) und (10) handles update-openssh-known-hosts.8 (2024-11-05)
cat $master | sed "s/^.ft C$/^\".ft C$/" | sed "s/^.ft P$/^\".ft P$/" | sed "s/\\\\fb/\\fB/" | sed 's/\.BR \(.*\)\\c/.BR \1/' | sed 's/\.UE \\c/.UE /' | sed 's/^\\c$//'| sed 's/\.BI \(.*\)\\c/.BI \1/' | sed 's/\.RI \(.*\)\\c/.RI \1/' | sed 's/^Timo Weingärtner \\c$/Timo Weingärtner/' | sed 's/^.ME \\c./.ME/' > $tdir/$distribution/$manname
else
# Remove / Uncomment some macros po4a cannot handle
# #1 / #2 Errors in some pages
# #3 / #4 The last two can be removed, if mkpasswd (Debian BTS #1036908) and gawk (fixed upstream) are fixed (or Debian #1036826)
# #5 Po4a sometimes has troubles parsing \c - This crude pattern gets around this, but adding additional spaces and sometimes moving arguments into main text, see Debian #1036826
# #6 / #7 handles update-openssh-known-hosts.8 (2024-11-05)
cat $master | sed "s/^.ft C$/^\".ft C$/" | sed "s/^.ft P$/^\".ft P$/" | sed "s/\\\\fb/\\fB/" | sed "s/^\.BI \(\\\\.*\)\"\\\\c$/.BI \1\"/" | sed "s/^\.BR \(\\\\.*\)\"\\\\c$/.BI \1\"/" | sed "s/\\\\c$//" | sed 's/^Timo Weingärtner \\c$/Timo Weingärtner/' | sed 's/^.ME \\c./.ME/'  > $tdir/$distribution/$manname
fi

# Actual translation
if [ -f noaddendum ]; then
    po4a-translate \
	-f man \
	--option groff_code=verbatim \
	--option generated \
	--option untranslated="}1,Ds,zY,zZ,Ee,ES,dT,FN,NE,NS,EX,EE,Id,rstReportMargin,INDENT,UNINDENT,UN,a.RE,\|" \
	--option unknown_macros=untranslated \
	--option inline="MR" \
	-m "$tdir/$distribution/$manname" \
	-M "utf-8" \
	-p "$pofile" \
	-L UTF-8 \
	-l "$localized";
else
    po4a-translate \
	-f man \
	--option groff_code=verbatim \
	--option generated \
	--option untranslated="}1,Ds,zY,zZ,Ee,ES,dT,NE,NS,EX,EE,Id,rstReportMargin,INDENT,UNINDENT,UN,a.RE,\|" \
	--option unknown_macros=untranslated \
	--option inline="MR" \
	-m "$tdir/$distribution/$manname" \
	-M "utf-8" \
	-p "$pofile" \
	-a "$addendum" \
	-L UTF-8 \
	-l "$localized";
fi

# Ensure a proper encoding if the generation has been successful
if [ -f "$localized" ]; then
	encoding=$(mktemp)
	manpage=$(mktemp)
	# Check if the generated manpage already includes an encoding
	coding=$(head -n1 "$localized" | grep "coding:")
	if [ -n "$coding" ]; then
		# There is an encoding set, remove the first line
		sed -i -e "1d" "$localized"
	fi
	# Set an explicit encoding to prevent display errors
	echo ".\\\" -*- coding: UTF-8 -*-" > "$encoding"
	cat "$encoding" "$localized" > "$manpage"
	mv "$manpage" "$localized"
	rm "$encoding"
fi

if [ -f "$localized" ]; then
    # Fix for issue #18
    # Fix .NM macro
    # Man page name without suffix
    pname=$(echo $manname | cut -d. -f1)
    sed -i -e "s/^.Nm$/.Nm $pname/" "$localized"
    sed -i -e "s/^.Nm ,$/.Nm $pname ,/" "$localized"
    # Fix for issue #20
    sed -i -e ':a;N;$!ba;s/link\nhttp/link http/g' "$localized"
    sed -i -e ':a;N;$!ba;s/tty:\nlink/tty: link/g' "$localized"
fi

rm -f "$addendum" "$pofile"
rm -rf $tdir
