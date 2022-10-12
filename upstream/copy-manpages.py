#!/usr/bin/python3
#
# Copyright © 2020 Dr. Tobias Quathamer <toddy@debian.org>
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

import json
import os
import re
import subprocess
import sys
from pathlib import Path

# Get the current distribution from the command line 
if len(sys.argv) != 2:
    print("Error: Please specify the distribution.", file=sys.stderr)
    sys.exit(1)
distribution = sys.argv[1]

# Require package download information from a JSON file
package_data = {}
json_filename = "{}/downloads/packages.json".format(distribution)
if os.path.exists(json_filename):
    with open(json_filename) as input_file:
        package_data = json.loads(input_file.read())
else:
    print("Error: The information about downloads is missing.", file=sys.stderr)
    sys.exit(1)


# Cycle through all packages and look for needed updates
for package, info in package_data.items():
    print("Checking '{}' ... ".format(package), end="")
    if info['needs_update']:
        package_links = []
        workdir = "{}/downloads/{}".format(distribution, package)
        # Get all mandirs
        all_dirs = os.listdir(workdir)
        mandirs = []
        for mdir in all_dirs:
            if mdir.startswith("man"):
                mandirs.append(mdir)
        mandirs.sort()

        # Get all files in the mandirs
        for mandir in mandirs:
            # The section starts after "man", so remove 3 characters
            section = mandir[3:]
            manpages = os.listdir("{}/{}".format(workdir, mandir))
            manpages.sort()

            for manpage in manpages:
                manpage_path = "{}/{}/{}".format(workdir, mandir, manpage)
                if Path(manpage_path).is_symlink():
                    # This is a symlink, so add it to the links
                    link = os.readlink(manpage_path)
                    # Ensure that the link is always in the form
                    # of mandir/manpage
                    if (os.path.basename(os.path.dirname(link)).startswith("man")):
                        link = "{}/{}".format(os.path.basename(os.path.dirname(link)),
                            os.path.basename(link))
                    else:
                        link = "{}/{}".format(mandir, os.path.basename(link))
                    # Remove compression extension
                    for extension in ['.gz', '.bz2', '.xz']:
                        if link.endswith(extension):
                            link = link[:-len(extension)]
                        if manpage.endswith(extension):
                            manpage = manpage[:-len(extension)]
                    package_links.append("{} {}/{}".format(link, mandir, manpage))
                else:
                    # This is a regular file, first decompress it
                    new_filename = "{}/{}/{}".format(distribution, mandir, manpage)
                    if manpage.endswith(".gz"):
                        new_filename = new_filename[:-3]
                        manpage = manpage[:-3]
                        new_file = open(new_filename, "w")
                        subprocess.run(["gzip", "-cd", manpage_path], stdout=new_file)
                    elif manpage.endswith(".bz2"):
                        new_filename = new_filename[:-4]
                        manpage = manpage[:-4]
                        new_file = open(new_filename, "w")
                        subprocess.run(["bzip2", "-cd", manpage_path], stdout=new_file)
                    elif manpage.endswith(".xz"):
                        new_filename = new_filename[:-3]
                        manpage = manpage[:-3]
                        new_file = open(new_filename, "w")
                        subprocess.run(["xz", "-cd", manpage_path], stdout=new_file)
                    else:
                        new_file = open(new_filename, "w")
                        subprocess.run(["cat", manpage_path], stdout=new_file)
                    new_file.close()

                    # Check if it contains a manpage link with .so
                    see_other = None
                    try:
                        with open(new_filename, "rt", encoding="UTF-8") as new_file:
                            for line in new_file:
                                see_other = re.search(r"^\.so.(.*)", line)
                                if see_other:
                                    break
                    except UnicodeDecodeError:
                        with open(new_filename, "rt", encoding="ISO 8859-1") as new_file:
                            for line in new_file:
                                see_other = re.search(r"^\.so.(.*)", line)
                                if see_other:
                                    break
                    if see_other:
                        link = see_other.group(1)
                        # Ensure that the link is always in the form
                        # of mandir/manpage
                        if (os.path.basename(os.path.dirname(link)).startswith("man")):
                            link = "{}/{}".format(os.path.basename(os.path.dirname(link)),
                                os.path.basename(link))
                        else:
                            link = "{}/{}".format(mandir, os.path.basename(link))
                        package_links.append("{} {}/{}".format(link, mandir, manpage))
                        os.remove(new_filename)


        # Write all links of the package to a file
        if len(package_links) > 0:
            with open("{}/links.txt".format(workdir), "w") as links_file:
                for link in package_links:
                    links_file.write(link + "\n")

        # Reset the update flag
        package_data[package]['needs_update'] = False
        print("updated.")
    else:
        print("current.")


# Save updated package information in a JSON file
with open(json_filename, "w") as output_file:
    output_file.write(json.dumps(package_data, sort_keys=True, indent=4))
