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
from pathlib import Path
import subprocess
import sys

# Require package download information from a JSON file
package_data = {}
for distribution in Path("../upstream").glob("*"):
    if distribution.is_dir():
        distribution = distribution.name
        json_filename = "../upstream/{}/downloads/packages.json".format(distribution)
        if Path(json_filename).exists():
            with open(json_filename) as input_file:
                package_data[distribution] = json.loads(input_file.read())
        else:
            print("Error: The information about downloads is missing.", file=sys.stderr)
            sys.exit(1)

# Search all mandirs with translations and
# reduce them to mandir sections
mandirs = []
for directory in Path("../po").glob("*/man*"):
    if directory.name not in mandirs:
        mandirs.append(directory.name)
mandirs.sort()

# Find the original manpages for translations
# and map them to the upstream download dirs
manpages = {}
manpagefiles = Path("../upstream").glob("*/downloads/*/man*/*")
for manpagefile in manpagefiles:
    name = "{}/{}.po".format(manpagefile.parent.name, manpagefile.stem)
    distribution = manpagefile.parents[3].name
    packagename = manpagefile.parents[1].name
    if name not in manpages:
        manpages[name] = {distribution: packagename}
    else:
        manpages[name][distribution] = packagename

# Store the templates which are updated, so that the
# translations only get updated if needed.
needed_pofile_updates = []
for mandir in mandirs:
    print("Section", mandir)

    # Find all pofiles of the section in all languages
    # and reduce them to only one pofile
    translations = []
    pofiles = Path("../po").glob("*/{}/*.po".format(mandir))
    for pofile in pofiles:
        name = "{}/{}".format(pofile.parent.name, pofile.name)
        if name not in translations:
            translations.append(name)
    translations.sort()

    # First step: Generate all needed templates
    for translation in translations:
        generatetemplate = True
        if translation in manpages:
            info = manpages[translation]
            for distribution, package in info.items():
                if package in package_data[distribution]:
                    generatetemplate = package_data[distribution][package]['needs_templates']
        if generatetemplate:
            subprocess.run(['./generate-one-template.sh', Path(translation).stem])
            needed_pofile_updates.append(translation)

    # Second step: Reset the template flag
    for translation in translations:
        if translation in manpages:
            info = manpages[translation]
            for distribution, package in info.items():
                if package in package_data[distribution]:
                    package_data[distribution][package]['needs_templates'] = False

# Save updated package information in a JSON file
for distribution in package_data:
    json_filename = "../upstream/{}/downloads/packages.json".format(distribution)
    with open(json_filename, "w") as output_file:
        output_file.write(json.dumps(package_data[distribution], sort_keys=True, indent=4))

# Save template update information for translations
needed_pofile_updates.sort()
json_filename = "../po/needed-updates.json"
with open(json_filename, "w") as output_file:
    output_file.write(json.dumps(needed_pofile_updates, sort_keys=True, indent=4))
