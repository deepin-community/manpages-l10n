#!/bin/sh
#
# list-manpages - Find man pages available for translation
# Copyright © 2020 Rafael Fontenelle <rafaelff@gnome.org>
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

prog="./$(basename $0)"
distros=$(find '../../upstream/' -maxdepth 1 -type d | sed 's|../../upstream/||' | tr '\n' ' ')
untranslatedflag=0


while getopts 'hd:f:u' arg; do
  case $arg in
    h)
      echo "Usage: $prog [options]"
      echo "List man pages available for translation with or without filters;"
      echo "List all by default, unless a filter is used."
      echo ""
      echo "Options supported:"
      echo "  -d DISTRO   filter by distribution name DISTRO; valid names:"
      echo "               $distros"
      echo "  -f FILE     filter by FILE, which is a part or the whole man page filename"
      echo "  -u          filter by untranslated man pages (i.e. no po file yet)"
      echo "  -h          show this message and quit"
      echo ""
      echo "Example of uses:"
      echo " $prog                  (to list all man pages available)"
      echo " $prog -d debian-buster (to list debian-buster's man pages)"
      echo " $prog -f ext4          (to list man pages with 'ext4' in filename)"
      echo " $prog -uf intro        (to list untranslated 'intro' man pages)"
      echo ""
      exit
      ;;
    d)
      for distro in $distros; do
        if [ "$distro" = "$OPTARG" ]; then
            distrofilter=$OPTARG
            break
        fi
      done
      
      if [ -z "$distrofilter" ]; then
        echo "Invalid distribution name \"$distrofilter\". Valid name: $distros" >&2
        exit 1
      fi
      ;;
    f)
      filenamefilter=$OPTARG
      ;;
    u)
      untranslatedflag=1
      ;;
  esac
done


# If -d passed, filter by distribution name, or get all man page filenames
if [ -n "$distrofilter" ]; then
    manpages=$(find "../../upstream/$distrofilter"/man* -type f | cut -d/ -f4- | LC_ALL=C sort)
else
    manpages=$(find "../../upstream"/*/man* -type f | cut -d/ -f4- | LC_ALL=C sort)
fi


# If -f passed, filter by man page filename
if [ -n "$filenamefilter" ]; then
    manpages=$(echo "$manpages" | tr ' ' '\n' | grep "$filenamefilter")
fi


# If -u passed, show only untranslated man pages (i.e. not complete neither incomplete)
if [ $untranslatedflag -eq 1 ]; then

    # store man pages in temporary file
    tmpfile=$(mktemp)
    echo "$manpages" > "$tmpfile"
    
    # list translation files
    translatedfiles=$(find man?/ -type f -name '*.po')
    
    for translatedfile in $translatedfiles; do
        filename=$(echo "${translatedfile%%.po}" | sed 's|/|\\/|g')
        sed -i "/$filename/d" "$tmpfile"
    done
    
    manpages=$(cat $tmpfile)
fi

echo "$manpages" | tr ' ' '\n'
