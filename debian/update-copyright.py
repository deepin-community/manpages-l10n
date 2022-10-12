#!/usr/bin/python3

import glob
import re
import textwrap

# These two lists hold all combinations of translator names
# and their corresponding files.
translator_names = []
translator_files = []

# Generate a list of all translations
for filename in glob.iglob("../po/*/man*/*po"):
    # Strip the leading two dots and slash
    short_filename = filename[3:]
    # Read in the translators
    with open(filename) as in_file:
        # Create a new list holding all translator names
        # for the current file
        names = []
        for line in in_file:
            # Stop if the first msgid is found, we only need the header
            if re.match(r"^msgid", line):
                break
            # Extract the name, if there's an email detectable
            match = re.match(r"^# ([^<]+\s+<.+@.+>)", line)
            # Add each name only once
            if match and match.group(1) not in names:
                names.append(match.group(1))
        # Make the sorting deterministic
        names = sorted(names)
        if names not in translator_names:
            # Not yet seen this group, so add them.
            # Maintain the same index for the file list.
            translator_names.append(names)
            translator_files.append([short_filename])
        else:
            # The group is already present, find their
            # position in the name list and append the
            # file to the same list position.
            idx = translator_names.index(names)
            files = translator_files[idx]
            files.append(short_filename)
            translator_files[idx] = files

# Now there is a link between the names and files.
# Create the automatic part of the copyright file.
automatic_part = ""
for idx, filenames in enumerate(translator_files):
    # Join the files into a whitespace separated list,
    # at most 76 characters long
    files = " ".join(sorted(filenames))
    # The wrap is 69 + 7 (length of "Files: ") = 76
    files = textwrap.wrap(files, width=69, break_long_words=False, break_on_hyphens=False)
    files = "\n       ".join(files)
    automatic_part += "Files: " + files + "\n"
    # Add the copyright holders
    names = ("\n           © ".join(translator_names[idx]))
    automatic_part += "Copyright: © " + names + "\n"
    # Last, add the license
    automatic_part += "License: GPL-3+\n\n"

# Read in the first lines of copyright, without
# the automatically generated parts. Stop after
# the second occurence of "License".
manual_lines = ""
license_line_count = 0
with open("copyright") as copyright_file:
	for line in copyright_file:
		manual_lines += line
		if re.search(r"^License:", line):
			license_line_count += 1
			if license_line_count == 2:
				# Add a final newline for separation
				manual_lines += "\n"
				break

# Open the file for output
with open("copyright", "w") as copyright_file:
	copyright_file.write(manual_lines)
	copyright_file.write(automatic_part)
	copyright_file.write("""License: GPL-3+
 This package is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 .
 This package is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 .
 You should have received a copy of the GNU General Public License
 along with this package.  If not, see <http://www.gnu.org/licenses/>.
 .
 On Debian systems, the full text of the GNU General
 Public License version 3 can be found in the file
 `/usr/share/common-licenses/GPL-3'.
""")
