#!/usr/bin/env perl
#
# Copyright © 2019 Dr. Tobias Quathamer <toddy@debian.org>
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

use strict;
use warnings;

# Set up month names
my @months =
  qw(јануара фебруара марта априла маја јуна јула августа септембра октобра новембра децембра);

# Split by paragraphs, in order to be able to remove a 'fuzzy' mark.
$/ = "";

while (<>) {

    # Does the current paragraph contain a date?
    if (/^msgid "([1-2][0-9]{3})-([0-1][0-9])-([0-3][0-9])"$/m) {
        my $year  = sprintf( "%4d", $1 );
        my $month = $months[ $2 - 1 ];
        my $day   = sprintf( "%d.", $3 );

        # Replace the current date translation with the new one.
        s/^msgstr \".*\"$/msgstr "$day $month $year"/m;

        # Remove the fuzzy flag if it's the only flag.
        s/^#, fuzzy\n//m;

        # Remove the fuzzy flag if there are other flags.
        s/^(#.*), fuzzy/$1/m;
    }
    print;
}
