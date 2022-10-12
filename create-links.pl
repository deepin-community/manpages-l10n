#!/usr/bin/perl
#
# Copyright © 2010-2012 Dr. Tobias Quathamer <toddy@debian.org>
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

# Get the installation path and compression extension from Makefile
my $install_path = $ARGV[0]
  or die "Please specify the installation path.";
my $comp_extension = $ARGV[1];
my $filename = $ARGV[2]
  or die "Please specify the filename with links.";

open( LINKS, '<', $filename ) or die "Cannot open link file: " . $!;

# Read the whole file
while (<LINKS>) {

    # Remove trailing newline
    chop();

    # Format is source, destination with their corresponding manpage section
    # e.g. man1/access.1 or man5/complex.5
    ( my $source, my $destination ) = split(/ /);

    # Determine whether the manpage section is equal
    my @source_parts      = split( /\//, $source );
    my @destination_parts = split( /\//, $destination );

    # If the manpages are in different sections, use a relative link
    if ( $source_parts[0] ne $destination_parts[0] ) {
        $source = '../' . $source;
    }
    else {
        # The sections are equal, remove them
        $source = $source_parts[1];
    }

    # Change directory to destination manpage for linking
    my $working_directory = $install_path . '/' . $destination_parts[0];

    # We always change the working directory to the destination manpage,
    # so remove the section directory
    $destination = $destination_parts[1];

    # Add the compression extension, if there is one.
    $source      = "$source$comp_extension";
    $destination = "$destination$comp_extension";

    # Finally, make sure that the source file really exists.
    # As these are translated manpages, some translations might not
    # be available.
    if ( -e $working_directory . '/' . $source ) {
        system("( cd $working_directory ; ln -sf $source $destination )");
    }
}

close(LINKS);
